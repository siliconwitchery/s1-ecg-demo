/**
 * @file  s1-ecg-demo/main.c
 *
 * @brief Tiny ECG Application running on S1
 *
 *        Includes basic configuration of the S1 module, and
 *        operations required to boot the FPGA. The FPGA
 *        verilog project can be built by running:
 *           "make build-verilog"
 *        from this folder.
 *
 * @attention Copyright 2022 Silicon Witchery AB
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
static const nrfx_spim_t spi = NRFX_SPIM_INSTANCE(0);

void spi_init()
{
    // SPI hardware configuration
    nrfx_spim_config_t spi_config = NRFX_SPIM_DEFAULT_CONFIG;
    spi_config.mosi_pin = SPI_SO_PIN;
    spi_config.miso_pin = SPI_SI_PIN;
    spi_config.sck_pin = SPI_CLK_PIN;
    spi_config.ss_pin = SPI_CS_PIN;
    spi_config.frequency = NRF_SPIM_FREQ_125K;
    spi_config.ss_active_high = 1; // Inverted CS

    // Initialise the SPI if it was not already
    APP_ERROR_CHECK(nrfx_spim_init(&spi, &spi_config, NULL, NULL));
}

void spi_tx(uint8_t *tx_buffer, uint8_t len)
{
    nrfx_spim_xfer_desc_t spi_xfer = NRFX_SPIM_XFER_TX(tx_buffer, len);
    APP_ERROR_CHECK(nrfx_spim_xfer(&spi, &spi_xfer, 0));
}

void s1_fpga_io_update(s1_fpga_pins_t *s1_fpga_pins)
{
    static uint8_t tx_buffer[2];
    for (int i = 0; i < 8; i++)
    {
        tx_buffer[0] = i; // pin numbering starts at 1
        tx_buffer[1] = s1_fpga_pins->duty_cycle[i];
        spi_tx(tx_buffer, 2);
    }
}

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
        s1_pimc_set_vfpga(true);
        s1_pmic_set_vio(3.3, false);
        s1_pmic_set_vaux(3.3);
        s1_pmic_set_chg(4.2, 150.0);
        s1_fpga_hold_reset();
        s1_flash_wakeup();
        fpga_boot_state = CHECK_BIN_CRC;
        break;

    // Check if the Flash has the correct FPGA binary, otherwise update it
    case CHECK_BIN_CRC:
        if (!s1_flash_is_busy())
        {
            if (s1_fpga_crc_check())
            {
                LOG("Flash already programmed. Booting.");
                s1_fpga_boot();
                fpga_boot_state = BOOTING;
            }
            else
            {
                LOG("Erasing flash. Takes up to 80 seconds.");
                s1_flash_erase_all();
                fpga_boot_state = ERASING;
            }
        }
        break;

    // Wait for erase to complete
    case ERASING:
        if (!s1_flash_is_busy())
        {
            pages_remaining = (uint32_t)ceil((float)fpga_binfile_bin_len / 256.0);
            fpga_boot_state = FLASHING;
            LOG("Flashing %d pages.", (int)pages_remaining);
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

    // Initialise the SPI after the delay while the FPGA boots
    case BOOTING:
        if (s1_fpga_is_booted())
        {
            LOG("FPGA started. Enabling ECG.");
            fpga_boot_state = UPDATE_PINS;
            spi_init(NRF_SPIM_FREQ_125K);
            lod_gpio_init();
            ecg_wake();
        }
        break;

    // Send SPI data to the FPGA
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
            led_idx = ceil(filtered_val / 585) + 1; // 7 sections plus offset
            if (led_idx > 7)
                led_idx = 7;
            led_idx = 8 - led_idx; // flip the wave
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
        LOG("Shutting down FPGA and flash.");
        tx_buffer[0] = 0xFF;
        tx_buffer[1] = 0xFF;
        spi_tx(&tx_buffer, 2);
        s1_pmic_set_vaux(0.0);
        s1_pmic_set_vio(0.0, false);
        s1_pimc_set_vfpga(false);
        flash_tx_rx((uint8_t *)&flash_sleep_cmd, 1, NULL, 0);
        NRFX_DELAY_US(2); // Flash needs a delay after sleep command
        nrf_pwr_mgmt_shutdown(NRF_PWR_MGMT_SHUTDOWN_GOTO_SYSOFF);
        break;

    // Sleeping. We wake whenever the ECG amp gives the signal.
    case SLEEPING:
        if (ecg_active)
        {
            fpga_boot_state = WAKE;
            LOG("FPGA waking from sleep.");
        }
        break;

    // Turn on fpga voltages
    case WAKE:
        s1_pimc_set_vfpga(true);
        s1_pmic_set_vio(3.3, false);
        s1_pmic_set_vaux(3.3);
        s1_fpga_boot();
        fpga_boot_state = LOAD_FROM_FLASH;
        break;

    // Load image from flash
    case LOAD_FROM_FLASH:
        if (s1_fpga_is_booted())
        {
            spi_init(NRF_SPIM_FREQ_125K);
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

        if (adc_val < 0)
            adc_val = 0;
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
    check_leads_off();
}

void ecg_sleep()
{
    // Stop tasks
    APP_ERROR_CHECK(app_timer_stop(adc_task_id));
    APP_ERROR_CHECK(app_timer_stop(filter_task_id));
    ecg_active = 0;
    // Set all LED duty cycle to 0
    for (int i = 0; i < 8; i++)
        s1_fpga_pins.duty_cycle[i] = 0;
    s1_fpga_io_update(&s1_fpga_pins);
    fpga_boot_state = SLEEP;
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
}

void check_leads_off()
{
    uint32_t lod = nrf_gpio_pin_read(ADC2_PIN_AS_GPIO);
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
}

/**
 * @brief Main application entry for the fpga-blinky demo.
 */
int main(void)
{
    // Log some stuff about this project
    LOG_CLEAR();
    LOG("S1 ECG Kit Demo – Built: %s %s – SDK Version: %s.",
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
                                    APP_TIMER_TICKS(5),
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