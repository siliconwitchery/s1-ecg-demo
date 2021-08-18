# FPGA Demo Project
#
# Here we build fpga demo including the verilog project 
# which outputs the FPGA binary. Once the binary is made,
# we convert it into a c header file, add some formating,
# and then we add it into the nRF project build.
#
# To build the FPGA blinky demo, run the commands:
#
#	cd examples/fpga-blinky
#	make build-verilog
#	make flash
#
# Include the S1 core makefile. Change S1_SDK_ROOT if you
# move the project to a different location. Note that
# "SDK_ROOT" is the nordic SDK. The name is unchanged to
# to ensure compatibity when copying makefiles from an nRF
# project.

S1_SDK_ROOT ?= ../..
VERILOG_ROOT ?= ../..
TOP ?= ../..
include $(S1_SDK_ROOT)/s1.mk

# In this project we always for recomple on main.c to
# include latest timestamps for __DATE__ and __TIME__.
$(shell touch main.c)

# Everything below here is the same as an nRF example
# Makefile. Note that the linker script, and S1 SDK files
# arel already included from s1.mk, so we dont need to add
# them here.
#
# At the bottom of this file, there is also a task to build
# the FPGA verilog project. Run it once before building the
# project by calling "make build-verlog".


TARGETS          := thermal-cam-demo
OUTPUT_DIRECTORY := .build

# Source files common to all targets
SRC_FILES += \
  main.c \
  $(SDK_ROOT)/modules/nrfx/mdk/gcc_startup_nrf52811.S \
  $(SDK_ROOT)/components/libraries/atomic_fifo/nrf_atfifo.c \
  $(SDK_ROOT)/components/libraries/atomic/nrf_atomic.c \
  $(SDK_ROOT)/components/libraries/balloc/nrf_balloc.c \
  $(SDK_ROOT)/components/libraries/memobj/nrf_memobj.c \
  $(SDK_ROOT)/components/libraries/ringbuf/nrf_ringbuf.c \
  $(SDK_ROOT)/components/libraries/scheduler/app_scheduler.c \
  $(SDK_ROOT)/components/libraries/sortlist/nrf_sortlist.c \
  $(SDK_ROOT)/components/libraries/strerror/nrf_strerror.c \
  $(SDK_ROOT)/components/libraries/timer/app_timer2.c \
  $(SDK_ROOT)/components/libraries/timer/drv_rtc.c \
  $(SDK_ROOT)/components/libraries/util/app_error_handler_gcc.c \
  $(SDK_ROOT)/components/libraries/util/app_error_weak.c \
  $(SDK_ROOT)/components/libraries/util/app_error.c \
  $(SDK_ROOT)/components/libraries/util/app_util_platform.c \
  $(SDK_ROOT)/components/libraries/util/nrf_assert.c \
  $(SDK_ROOT)/external/fprintf/nrf_fprintf_format.c \
  $(SDK_ROOT)/external/fprintf/nrf_fprintf.c \
  $(SDK_ROOT)/external/segger_rtt/SEGGER_RTT_printf.c \
  $(SDK_ROOT)/external/segger_rtt/SEGGER_RTT_Syscalls_GCC.c \
  $(SDK_ROOT)/external/segger_rtt/SEGGER_RTT.c \
  $(SDK_ROOT)/modules/nrfx/drivers/src/nrfx_clock.c \
  $(SDK_ROOT)/modules/nrfx/drivers/src/nrfx_saadc.c \
  $(SDK_ROOT)/modules/nrfx/drivers/src/nrfx_spim.c \
  $(SDK_ROOT)/modules/nrfx/drivers/src/nrfx_twim.c \
  $(SDK_ROOT)/modules/nrfx/mdk/system_nrf52811.c \
  $(SDK_ROOT)/modules/nrfx/soc/nrfx_atomic.c \

# Include folders common to all targets
INC_FOLDERS += \
  . \
  $(SDK_ROOT)/components \
  $(SDK_ROOT)/components/drivers_nrf/nrf_soc_nosd \
  $(SDK_ROOT)/components/libraries/atomic \
  $(SDK_ROOT)/components/libraries/atomic_fifo \
  $(SDK_ROOT)/components/libraries/balloc \
  $(SDK_ROOT)/components/libraries/bsp \
  $(SDK_ROOT)/components/libraries/delay \
  $(SDK_ROOT)/components/libraries/experimental_section_vars \
  $(SDK_ROOT)/components/libraries/log \
  $(SDK_ROOT)/components/libraries/log/src \
  $(SDK_ROOT)/components/libraries/memobj \
  $(SDK_ROOT)/components/libraries/ringbuf \
  $(SDK_ROOT)/components/libraries/scheduler \
  $(SDK_ROOT)/components/libraries/sortlist \
  $(SDK_ROOT)/components/libraries/timer \
  $(SDK_ROOT)/components/libraries/strerror \
  $(SDK_ROOT)/components/libraries/util \
  $(SDK_ROOT)/components/toolchain/cmsis/include \
  $(SDK_ROOT)/external/fprintf \
  $(SDK_ROOT)/external/segger_rtt \
  $(SDK_ROOT)/integration/nrfx \
  $(SDK_ROOT)/modules/nrfx \
  $(SDK_ROOT)/modules/nrfx/drivers/include \
  $(SDK_ROOT)/modules/nrfx/hal \
  $(SDK_ROOT)/modules/nrfx/mdk \

# Libraries common to all targets
LIB_FILES += \

# Optimization flags
OPT += -flto # Link time optimisation
OPT += -g3 # Debugging information

# C flags common to all targets
CFLAGS += $(OPT)
CFLAGS += -DAPP_TIMER_V2
CFLAGS += -DAPP_TIMER_V2_RTC1_ENABLED
CFLAGS += -DFLOAT_ABI_SOFT
CFLAGS += -DNRF52811_XXAA
CFLAGS += -DNRFX_COREDEP_DELAY_US_LOOP_CYCLES=3
CFLAGS += -mcpu=cortex-m4
CFLAGS += -mthumb -mabi=aapcs
CFLAGS += -Wall
CFLAGS += -mfloat-abi=soft
# keep every function in a separate section, this allows linker to discard unused ones
CFLAGS += -ffunction-sections -fdata-sections -fno-strict-aliasing
CFLAGS += -fno-builtin -fshort-enums

# C++ flags common to all targets
CXXFLAGS += $(OPT)

# Assembler flags common to all targets
ASMFLAGS += -DAPP_TIMER_V2
ASMFLAGS += -DAPP_TIMER_V2_RTC1_ENABLED
ASMFLAGS += -mcpu=cortex-m4
ASMFLAGS += -mthumb -mabi=aapcs
ASMFLAGS += -mfloat-abi=soft
ASMFLAGS += -DFLOAT_ABI_SOFT
ASMFLAGS += -DNRF52811_XXAA
ASMFLAGS += -DNRFX_COREDEP_DELAY_US_LOOP_CYCLES=3

# Linker flags
LDFLAGS += $(OPT)
LDFLAGS += -mthumb -mabi=aapcs -L$(SDK_ROOT)/modules/nrfx/mdk -T$(LINKER_SCRIPT)
LDFLAGS += -mcpu=cortex-m4
LDFLAGS += -Wl,--gc-sections # let linker dump unused sections
LDFLAGS += --specs=nano.specs # use newlib in nano version
LDFLAGS += -u _printf_float # required to print floats

thermal-cam-demo: CFLAGS += -D__HEAP_SIZE=2048
thermal-cam-demo: CFLAGS += -D__STACK_SIZE=2048
thermal-cam-demo: ASMFLAGS += -D__HEAP_SIZE=2048
thermal-cam-demo: ASMFLAGS += -D__STACK_SIZE=2048

# Add standard libraries at the very end of the linker input, after all objects
# that may need symbols provided by these libraries.
LIB_FILES += -lc -lnosys -lm

TEMPLATE_PATH := $(SDK_ROOT)/components/toolchain/gcc

include $(TEMPLATE_PATH)/Makefile.common

$(foreach target, $(TARGETS), $(call define_target, $(target)))

.PHONY: default flash erase reset help

# Run "make" to build the project
default: thermal-cam-demo

# Run "make flash" to build and flash the project
flash: thermal-cam-demo
	nrfjprog -f nrf52 --program $(OUTPUT_DIRECTORY)/thermal-cam-demo.hex --sectorerase -r

# "make erase" fully erase the nRF52811 chip
erase:
	nrfjprog -f nrf52 --eraseall

# "make reset" will reset the nRF52811 chip
reset:
	nrfjprog -f nrf52 -r

# "make sdk_config" will open the nRF SDK configuration utility
sdk_config:
	java -jar $(SDK_ROOT)/external_tools/cmsisconfig/CMSIS_Configuration_Wizard.jar sdk_config.h

# "make build-verilog" will build the fpga project.
# Ensure you have apio installed from here:
# (https://github.com/FPGAwars/apio)
build-verilog-apio:
	# Build the FPGA project using APIO
	# If you dont have it, get it here:
	# https://github.com/FPGAwars/apio
	cd $(VERILOG_ROOT) && apio build

	# Use xxd to convert the bin into a c
	# header file. The file name becomes
	# the C variable name, so we must
	# change the name from "hardware" to
	# "fpga_blinky_bin".
	mv $(VERILOG_ROOT)/hardware.bin $(VERILOG_ROOT)/fpga_binfile.bin
	cd $(VERILOG_ROOT) && xxd -i fpga_binfile.bin fpga_binfile.h.old

	# Then we want the FPGA binary array
	# stored in flash, so we append it
	# with "const" using the sed tool.
	sed '1s/^/const /' $(VERILOG_ROOT)/fpga_binfile.h.old > fpga_binfile.h

build-verilog:
	cd $(VERILOG_ROOT) && yosys -p "synth_ice40 -json hardware.json" $(TOP).v -q
	cd $(VERILOG_ROOT) && nextpnr-ice40 --up5k --package uwg30 --json hardware.json --asc hardware.asc --pcf s1.pcf -q
	cd $(VERILOG_ROOT) && icepack hardware.asc fpga_binfile.bin
	# Use xxd to convert the bin into a c
	# header file. The file name becomes
	# the C variable name
	cd $(VERILOG_ROOT) && xxd -i fpga_binfile.bin fpga_binfile.h.old

	# Then we want the FPGA binary array
	# stored in flash, so we append it
	# with "const" using the sed tool.
	sed '1s/^/const /' $(VERILOG_ROOT)/fpga_binfile.h.old > fpga_binfile.h

sim-verilog:
	cd $(VERILOG_ROOT) && iverilog -o $(TOP)_tb.out -D VCD_OUTPUT=$(TOP)_tb cells_sim.v $(TOP)_tb.v
	cd $(VERILOG_ROOT) && vvp $(TOP)_tb.out -fst
	cd $(VERILOG_ROOT) && gtkwave $(TOP)_tb.fst