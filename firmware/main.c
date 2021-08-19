/**
 * @file  s1-ecg-demo/main.c
 * @brief Simple FPGA blinky Application running on S1
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

#include <math.h>
#include "app_scheduler.h"
#include "app_timer.h"
#include "fpga_binfile.h"
#include "nrf_gpio.h"
#include "nrf52811.h"
#include "nrfx_clock.h"
#include "nrfx_saadc.h"
#include "nrfx_spim.h"
#include "nrfx_twim.h"
#include "s1.h"
#include "fir_filter.h"

#define SPI_SI_PIN NRF_GPIO_PIN_MAP(0, 8)
#define SPI_SO_PIN NRF_GPIO_PIN_MAP(0, 11)
#define SPI_CS_PIN NRF_GPIO_PIN_MAP(0, 12)
#define SPI_CLK_PIN NRF_GPIO_PIN_MAP(0, 15)

static nrf_saadc_value_t m_buffer;
static uint32_t SAMPLES_IN_BUFFER = 1;
static uint32_t m_adc_evt_counter;
static int32_t adc_val;

static float buffer[65];
static int32_t buff_idx = 0;
static float filtered_val;

APP_TIMER_DEF(fpga_boot_task_id);
APP_TIMER_DEF(adc_task_id);
APP_TIMER_DEF(filter_task_id);

typedef enum
{
    STARTED,
    ERASING,
    FLASHING,
    BOOTING,
    DONE
} fpga_boot_state_t;

static fpga_boot_state_t fpga_boot_state = STARTED;
static uint32_t pages_remaining;
static uint32_t page_address = 0x000000;

/**
 * @brief Clock event callback. Not used but required to have.
 */
void clock_event_handler(nrfx_clock_evt_type_t event) {}

/**
 * @brief Timer based state machine for flashing the FPGA
 *        image and booting the FPGA. As some of the flash
 *        operations take a lot of time, using a timer based
 *        state machine avoids the main thread hanging while
 *        waiting for flash operations to complete.
 */
static void fpga_boot_task(void *p_context)
{
    UNUSED_PARAMETER(p_context);
    switch (fpga_boot_state)
    {
    // Configure power and erase the flash
    case STARTED:
        s1_pimc_fpga_vcore(true);
        s1_pmic_set_vio(3.3);
        s1_pmic_set_vaux(3.3);
        s1_fpga_hold_reset();
        s1_flash_wakeup();
        s1_flash_erase_all();
        fpga_boot_state = ERASING;
        LOG("Erasing flash. Takes up to 80 seconds.");
        break;

    // Wait for erase to complete
    case ERASING:
        if (!s1_flash_is_busy())
        {
            pages_remaining = (uint32_t)ceil((float)fpga_binfile_bin_len / 256.0);
            fpga_boot_state = FLASHING;
            // LOG("Flashing %d pages.", pages_remaining);
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
            // LOG("Flashing done.");
            break;
        }
        break;

    // Wait for CDONE pin to go high then stop the task
    case BOOTING:
        if (s1_fpga_is_booted())
        {
            app_timer_stop(fpga_boot_task_id);
            fpga_boot_state = DONE;
            // LOG("FPGA started.");
        }
        break;
    }
}

void graph_to_log(uint32_t value)
{
    const uint32_t steps = 30;
    uint32_t idx = value / floor(4095.0 / steps);
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
    float scaled_value = value / 4095.0 * 1.8;
    LOG_RAW("| %.2f \r\n", scaled_value);
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
    // graph_to_log((uint32_t)adc_val);

    ret_code_t err_code;
    err_code = nrfx_saadc_sample();
    APP_ERROR_CHECK(err_code);
}

void filter_task(void *p_context)
{
    buffer[buff_idx] = adc_val;
    if (buff_idx == 64)
        buff_idx = 0;
    else
        buff_idx = buff_idx + 1;
    filtered_val = 0;
    for (int i = 0; i < 65; i++)
    {
        if (i + buff_idx < 65)
            filtered_val += buffer[i + buff_idx] * fir_coefs[i];
        else
            filtered_val += buffer[i + buff_idx - 65] * fir_coefs[i];
    }
    graph_to_log((uint32_t)filtered_val);
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

    // Initialise ADC
    saadc_init();

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
    // Run ADC at 125Hz -> 1000 / 125 = 8ms
    APP_ERROR_CHECK(app_timer_start(adc_task_id,
                                    APP_TIMER_TICKS(8),
                                    NULL));

    // Create timer for filter
    APP_ERROR_CHECK(app_timer_create(&filter_task_id,
                                     APP_TIMER_MODE_REPEATED,
                                     filter_task));

    APP_ERROR_CHECK(app_timer_start(filter_task_id,
                                    APP_TIMER_TICKS(8),
                                    NULL));

    // The CPU is free to do nothing in the meanwhile
    for (;;)
    {
        __WFI();
    }
}