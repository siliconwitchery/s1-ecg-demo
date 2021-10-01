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
#include "nrf_pwr_mgmt.h"
#include "s1.h"
#include "nrfx_gpiote.h"
#include "fir_filter.h"

typedef enum
{
    STARTED,
    ERASING,
    FLASHING,
    BOOTING,
    UPDATE_PINS,
    WAIT,
    IDLE,
    SLEEP,
    SLEEPING,
    WAKE,
    LOAD_FROM_FLASH,
    CHECK_BIN_CRC
} fpga_boot_state_t;

/**
 * @brief Check CRC match between flash and fpga binfile
 */
bool s1_fpga_crc_check();

/**
 * @brief Timer based state machine for flashing the FPGA
 *        image and booting the FPGA. As some of the flash
 *        operations take a lot of time, using a timer based
 *        state machine avoids the main thread hanging while
 *        waiting for flash operations to complete.
 */
void fpga_boot_task(void *p_context);

/**
 * @brief Debug function to plot a variable over log
 */
void graph_to_log(uint32_t value, uint32_t min, uint32_t max, uint8_t steps);

/**
 * @brief ADC callback function
 */
void saadc_callback(nrfx_saadc_evt_t const *p_event);

/**
 * @brief Function to initialize ADC
 */
void saadc_init(void);

/**
 * @brief ADC task
 */
void saadc_task(void *p_context);

/**
 * @brief Filter task callback
 */
void filter_task(void *p_context);

/**
 * @brief Helper function to stop ecg associated tasks
 */
void ecg_sleep();

/**
 * @brief Helper function to start ecg associated tasks
 */
void ecg_wake();

/**
 * @brief Initializes GPIOTE module, interrupt handler called when LOD pin
 * when LOD pin toggles
 */
void lod_gpio_init(void);

/**
 * @brief Checks leads off pin, if true, calls ecg_sleep
 */
void check_leads_off();