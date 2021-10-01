/**
 * @file  s1-ecg-demo/main.c
 * @brief Tiny ECG Application running on S1
 *        
 *        Includes basic configuration of the S1 module, and
 *        operations required to boot the FPGA. The FPGA 
 *        verilog project can be built by running:
 *           "make build-verilog" 
 *        from this folder.
 * 
 * @attention Copyright 2021 Silicon Witchery AB
 *
 * Permission to use, copy, modify, and/or distribute this 
 * software for any purpose with or without fee is hereby
 * granted, provided that the above copyright notice and this
 * permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS
 * ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL 
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO 
 * EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, 
 * INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER 
 * RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN 
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, 
 * ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE 
 * OF THIS SOFTWARE.
 */

// #define STEPPED_LPM

#include "main.h"

// Globals
static uint16_t fpga_spi_delay_counter = 0;
static nrf_saadc_value_t m_buffer;
static uint8_t SAMPLES_IN_BUFFER = 1;
static uint32_t m_adc_evt_counter;
static int32_t adc_val;

static float buffer[65];
static uint8_t buff_idx = 0;
static uint32_t filtered_val;
static bool ecg_active = 1;

APP_TIMER_DEF(fpga_boot_task_id);
APP_TIMER_DEF(adc_task_id);
APP_TIMER_DEF(filter_task_id);

static fpga_boot_state_t fpga_boot_state = STARTED;
static uint32_t pages_remaining;
static uint32_t page_address = 0x000000;

s1_fpga_pins_t s1_fpga_pins;

/**
 * @brief Clock event callback. Not used but required to have.
 */
void clock_event_handler(nrfx_clock_evt_type_t event) {}

void fpga_boot_task(void *p_context)
{
    UNUSED_PARAMETER(p_context);
    uint8_t led_idx;
    const uint8_t STEP = 50;
    uint8_t flash_sleep_cmd = 0xB9;
    uint8_t tx_buffer[2];
    switch (fpga_boot_state)
    {
    // Configure power and erase the flash
    case STARTED:
        s1_pimc_fpga_vcore(true);
        s1_pmic_set_vio(3.3);
        s1_pmic_set_vaux(3.3);
        s1_fpga_hold_reset();
        s1_flash_wakeup();
        fpga_boot_state = CHECK_BIN_CRC;
        break;

    case CHECK_BIN_CRC:
        if (!s1_flash_is_busy())
        {
            if (s1_fpga_crc_check())
            {
                LOG("CRC OK");
                s1_fpga_boot();
                fpga_boot_state = BOOTING;
            }
            else
            {
                LOG("CRC mismatch");
                s1_flash_erase_all();
                fpga_boot_state = ERASING;
                LOG("Erasing flash. Takes up to 80 seconds.");
            }
        }
        break;

    // Wait for erase to complete
    case ERASING:
        if (!s1_flash_is_busy())
        {
            pages_remaining = (uint32_t)ceil((float)fpga_binfile_bin_len / 256.0);
            fpga_boot_state = FLASHING;
            LOG("Flashing %d pages.", pages_remaining);
        }
        break;

    // Flash every page until done
    case FLASHING:
        if (!s1_flash_is_busy())
        {
            s1_flash_page_from_image(page_address, &fpga_binfile_bin);
            pages_remaining--;
            page_address += 0x100;
        }

        if (pages_remaining == 0)
        {
            fpga_boot_state = BOOTING;
            s1_fpga_boot();
            LOG("Flashing done.");
            break;
        }
        break;

    // Wait for CDONE pin to go high then stop the task
    case BOOTING:
        if (s1_fpga_is_booted())
        {
            // Small delay here for fpga to setup
            if (fpga_spi_delay_counter > 5)
            {
                // app_timer_stop(fpga_boot_task_id);
                fpga_boot_state = UPDATE_PINS;
                // TODO: add an IDLE state when fpga <-> nrf comms not needed
                s1_generic_spi_init();
                lod_gpio_init();
                LOG("FPGA started.");
                ecg_wake();
                fpga_spi_delay_counter = 0;
            }
            else
            {
                fpga_spi_delay_counter += 1;
            }
        }
        break;

    // SPI pin data with fpga
    case UPDATE_PINS:
        for (int i = 0; i < 8; i++)
        {
            if (s1_fpga_pins.duty_cycle[i] > STEP)
            {
                s1_fpga_pins.duty_cycle[i] = s1_fpga_pins.duty_cycle[i] - STEP;
            }
            else
                s1_fpga_pins.duty_cycle[i] = 0;
        }
        if (ecg_active)
        {
            led_idx = ceil(filtered_val / 585); // 7 sections
            // led_idx = ceil((filtered_val - 2450) / 60); // 7 sections
            // FIXME - hack to subtract min value
            if (led_idx > 7)
                led_idx = 7;
            led_idx = 8 - led_idx; // flip the wave
            LOG("%d %d", led_idx, filtered_val);
            s1_fpga_pins.duty_cycle[led_idx] = 255;
            s1_fpga_pins.duty_cycle[0] = 255;

            fpga_boot_state = WAIT;
        }
        else
        {
            fpga_boot_state = SLEEP;
        }

        s1_fpga_io_update(&s1_fpga_pins);
        break;

    // Wait for n timer ticks
    case WAIT:
        if (fpga_spi_delay_counter == 1)
        {
            fpga_boot_state = UPDATE_PINS;
            fpga_spi_delay_counter = 0;
        }
        else
            fpga_spi_delay_counter += 1;
        break;

    // Set everything to 0
    case IDLE:
        for (int i = 0; i < 8; i++)
        {
            if (s1_fpga_pins.duty_cycle[i] > STEP)
            {
                s1_fpga_pins.duty_cycle[i] = s1_fpga_pins.duty_cycle[i] - STEP;
            }
            else
                s1_fpga_pins.duty_cycle[i] = 0;
        }
        s1_fpga_io_update(&s1_fpga_pins);
        break;

    // Shutdown fpga on leads off
    case SLEEP:
#ifdef STEPPED_LPM
        if (fpga_spi_delay_counter == 100)
        {
#endif
            tx_buffer[0] = 0xFF;
            tx_buffer[1] = 0xFF;
            s1_generic_spi_tx(&tx_buffer, 2);
            s1_pmic_set_vaux(0.0);
            s1_pmic_set_vio(0.0);
            s1_pimc_fpga_vcore(false);
            // s1_fpga_hold_reset();
            LOG("FPGA shutdown");
#ifdef STEPPED_LPM
        }
        else if (fpga_spi_delay_counter == 200)
        {
#endif
            // Put flash in deep sleep
            flash_tx_rx((uint8_t *)&flash_sleep_cmd, 1, NULL, 0);
            LOG("Flash deep sleep");
            NRFX_DELAY_US(2);
            // APP_ERROR_CHECK(app_timer_stop(fpga_boot_task_id));
#ifdef STEPPED_LPM
        }
        else if (fpga_spi_delay_counter == 300)
        {
#endif
            nrf_pwr_mgmt_shutdown(NRF_PWR_MGMT_SHUTDOWN_GOTO_SYSOFF);
#ifdef STEPPED_LPM
        }
        LOG("%d", fpga_spi_delay_counter);
        fpga_spi_delay_counter++;
#endif
        break;

    case SLEEPING:
        if (ecg_active)
        {
            fpga_boot_state = WAKE;
            LOG("FPGA wakeup seq initiated");
        }
        break;

    // Turn on fpga voltages
    case WAKE:
        s1_pimc_fpga_vcore(true);
        s1_pmic_set_vio(3.3);
        s1_pmic_set_vaux(3.3);
        s1_fpga_boot();
        LOG("FPGA vcore on");
        fpga_boot_state = LOAD_FROM_FLASH;
        break;

    // Load image from flash
    case LOAD_FROM_FLASH:
        if (s1_fpga_is_booted())
        {
            s1_generic_spi_init();
            LOG("FPGA boot complete");
            fpga_boot_state = UPDATE_PINS;
        }
        break;
    }
}

bool s1_fpga_crc_check()
{
    uint8_t tx_buffer[4];
    uint8_t rx_buffer[7] = {0};
    uint32_t flash_crc;
    uint32_t binfile_crc;

    // Read flash [0x03], 3 bytes from 0x019694 -> CRC location
    tx_buffer[0] = 0x03;
    tx_buffer[1] = 0x01;
    tx_buffer[2] = 0x96;
    tx_buffer[3] = 0x94;

    // Careful when using this after boot, will deinit other SPI functionality
    flash_tx_rx((uint8_t *)&tx_buffer, 4, (uint8_t *)&rx_buffer, 7);

    flash_crc = (rx_buffer[4] << 16) + (rx_buffer[5] << 8) + rx_buffer[6];
    binfile_crc = (fpga_binfile_bin[104084] << 16) + (fpga_binfile_bin[104085] << 8) + fpga_binfile_bin[104086];
    if (flash_crc == binfile_crc)
        return true;
    else
        return false;
}

void graph_to_log(uint32_t value, uint32_t min, uint32_t max, uint8_t steps)
{
    uint32_t idx = value / floor((max - min) / steps);
    // LOG_RAW("%d__|", idx);
    LOG_RAW(" |");
    if (idx > 0)
    {
        for (int i = 0; i < idx; i++)
        {
            LOG_RAW(" ");
        }
    }
    LOG_RAW("*");
    if (idx < steps)
    {
        for (int i = idx + 1; i < steps + 1; i++)
        {
            LOG_RAW(" ");
        }
    }
    LOG_RAW("| %lu \r\n", value);
}

void saadc_callback(nrfx_saadc_evt_t const *p_event)
{
    if (p_event->type == NRFX_SAADC_EVT_DONE)
    {
        ret_code_t err_code;

        // Get SAMPLES_IN_BUFFER x samples when its time
        err_code = nrfx_saadc_buffer_convert(p_event->data.done.p_buffer, SAMPLES_IN_BUFFER);
        APP_ERROR_CHECK(err_code);

        // Average the samples
        adc_val = 0;
        for (int i = 0; i < SAMPLES_IN_BUFFER; i++)
        {
            adc_val = adc_val + p_event->data.done.p_buffer[i];
        }
        adc_val = adc_val / SAMPLES_IN_BUFFER; // note adc_val is int

        // TODO: Add ADC calibration here, clipping negatives to 0
        if (adc_val < 0)
            adc_val = 0;
        // LOG("%u", adc_val);
        // adc_val = 255 - (adc_val >> 4);
        m_adc_evt_counter++;
    }
}

void saadc_init(void)
{
    ret_code_t err_code;

    nrfx_saadc_config_t adc_config = {
        .resolution = NRF_SAADC_RESOLUTION_12BIT,
        .oversample = NRF_SAADC_OVERSAMPLE_DISABLED};

    nrf_saadc_channel_config_t channel_config = {
        .resistor_p = NRF_SAADC_RESISTOR_DISABLED,
        .resistor_n = NRF_SAADC_RESISTOR_DISABLED,
        .gain = NRF_SAADC_GAIN1_3,                 // so that Vmax/gain = 0.6
        .reference = NRF_SAADC_REFERENCE_INTERNAL, // internal ref 0.6V
        .acq_time = NRF_SAADC_ACQTIME_3US,
        .mode = NRF_SAADC_MODE_SINGLE_ENDED,
        .burst = NRF_SAADC_BURST_DISABLED,
        .pin_p = NRF_SAADC_INPUT_AIN2,
        .pin_n = NRF_SAADC_INPUT_DISABLED};

    err_code = nrfx_saadc_init(&adc_config, saadc_callback);
    APP_ERROR_CHECK(err_code);

    err_code = nrfx_saadc_channel_init(0, &channel_config);
    APP_ERROR_CHECK(err_code);

    err_code = nrfx_saadc_buffer_convert(&m_buffer, SAMPLES_IN_BUFFER);
    APP_ERROR_CHECK(err_code);
}

void saadc_task(void *p_context)
{
    // LOG("# %u %d", m_adc_evt_counter, adc_val);
    // graph_to_log((uint32_t)adc_val, 0, 4095, 10);

    ret_code_t err_code;
    err_code = nrfx_saadc_sample();
    APP_ERROR_CHECK(err_code);
}

void filter_task(void *p_context)
{
    // Moving average filter
    uint8_t WINDOW_SIZE = 8;
    buffer[buff_idx] = adc_val;
    if (buff_idx == WINDOW_SIZE)
        buff_idx = 0;
    else
        buff_idx = buff_idx + 1;
    filtered_val = 0;
    for (int i = 0; i < WINDOW_SIZE + 1; i++)
    {
        filtered_val += buffer[i];
    }
    filtered_val = filtered_val / WINDOW_SIZE;
    // LOG("%d", filtered_val);
    // graph_to_log((uint32_t)filtered_val, 0, 4095, 10);

    // FIR notch filter
    // buffer[buff_idx] = adc_val;
    // if (buff_idx == 64)
    //     buff_idx = 0;
    // else
    //     buff_idx = buff_idx + 1;
    // filtered_val = 0;
    // for (int i = 0; i < 65; i++)
    // {
    //     if (i + buff_idx < 65)
    //         filtered_val += buffer[i + buff_idx] * fir_coefs[i];
    //     else
    //         filtered_val += buffer[i + buff_idx - 65] * fir_coefs[i];
    // }
    // graph_to_log((uint32_t)filtered_val, 0, 4095, 10);
    check_leads_off();
}

void ecg_sleep()
{
    // Stop tasks
    APP_ERROR_CHECK(app_timer_stop(adc_task_id));
    APP_ERROR_CHECK(app_timer_stop(filter_task_id));
    ecg_active = 0;
    for (int i = 0; i < 8; i++)
        s1_fpga_pins.duty_cycle[i] = 0;
    s1_fpga_io_update(&s1_fpga_pins);

    // nrf_gpio_cfg_input(20, NRF_GPIO_PIN_NOPULL);
    // nrf_gpio_cfg_input(8, NRF_GPIO_PIN_NOPULL);
    // nrf_gpio_cfg_input(11, NRF_GPIO_PIN_NOPULL);
    // nrf_gpio_cfg_input(12, NRF_GPIO_PIN_NOPULL);
    // nrf_gpio_cfg_input(15, NRF_GPIO_PIN_NOPULL);
    fpga_boot_state = SLEEP;
    LOG("ecg sleep");
}

void ecg_wake()
{
    // Restart tasks
    APP_ERROR_CHECK(app_timer_start(adc_task_id,
                                    APP_TIMER_TICKS(1),
                                    NULL));
    APP_ERROR_CHECK(app_timer_start(filter_task_id,
                                    APP_TIMER_TICKS(1),
                                    NULL));
    ecg_active = 1;
    LOG("ecg wake");
}

void check_leads_off()
{
    uint32_t lod = nrf_gpio_pin_read(GPIO2_PIN);
    if (fpga_boot_state > 3)
    {
        if (lod)
            ecg_sleep();
    }
}

void lod_gpio_init(void)
{
    ret_code_t err_code;

    nrf_gpio_cfg_sense_input(5, NRF_GPIO_PIN_NOPULL, NRF_GPIO_PIN_SENSE_LOW);
    // nrf_delay_ms(1);

    // err_code = nrfx_gpiote_init();
    // APP_ERROR_CHECK(err_code);

    // nrfx_gpiote_in_config_t in_config = NRFX_GPIOTE_RAW_CONFIG_IN_SENSE_HITOLO(true);
    // in_config.pull = NRF_GPIO_PIN_NOPULL;

    // err_code = nrfx_gpiote_in_init(GPIO2_PIN, &in_config, in_pin_handler);
    // APP_ERROR_CHECK(err_code);

    // nrfx_gpiote_in_event_enable(GPIO2_PIN, true);
}

/**
 * @brief Main application entry for the fpga-blinky demo.
 */
int main(void)
{
    // Log some stuff about this project
    LOG_CLEAR();
    LOG("S1 FPGA Blinky Demo – Built: %s %s – SDK Version: %s.",
        __DATE__,
        __TIME__,
        __S1_SDK_VERSION__);

    // Initialise S1 base setting
    APP_ERROR_CHECK(s1_init());

    // Initialise LFXO required by the App Timer
    APP_ERROR_CHECK(nrfx_clock_init(clock_event_handler));
    nrfx_clock_lfclk_start();

    // Initialise the App Timer
    APP_ERROR_CHECK(app_timer_init());
    APP_SCHED_INIT(sizeof(uint32_t), 5);

    // Initialise power management
    APP_ERROR_CHECK(nrf_pwr_mgmt_init());

    // Initialise ADC
    saadc_init();

    // Make all fpga pins PWM and clear outputs
    for (int i = 0; i < 8; i++)
    {
        s1_fpga_pins.pin_mode[i] = PWM;
        s1_fpga_pins.duty_cycle[i] = 0;
    }

    // Create and start a timer for the FPGA flash/boot task
    APP_ERROR_CHECK(app_timer_create(&fpga_boot_task_id,
                                     APP_TIMER_MODE_REPEATED,
                                     fpga_boot_task));

    APP_ERROR_CHECK(app_timer_start(fpga_boot_task_id,
                                    APP_TIMER_TICKS(10),
                                    NULL));

    // Create timer for ADC
    APP_ERROR_CHECK(app_timer_create(&adc_task_id,
                                     APP_TIMER_MODE_REPEATED,
                                     saadc_task));

    // Create timer for filter
    APP_ERROR_CHECK(app_timer_create(&filter_task_id,
                                     APP_TIMER_MODE_REPEATED,
                                     filter_task));

    // The CPU is free to do nothing in the meanwhile
    for (;;)
    {
        nrf_pwr_mgmt_run();
    }
}