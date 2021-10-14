# S1 ECG Reference Kit

**Features:**

- Single chip frontend based on the [AD8233](https://www.analog.com/en/products/ad8233.html)
- S1 Module with Bluetooth 5.2 and FPGA
- Integrated lithium battery
- Ultra low power auto-sleep down to 175uA
- Open source design

**Applications:**

- Learning and teaching around heart health
- Research of ML based ECG algorithms
- Wireless ECG data logging
- New product development

A powerful analog frontend combined with the S1 Module makes this an all-in-one kit to deploy and test algorithms with ease. Be that for learning, research, or as the starting point for your next product.


<br>

![S1 ECG Board](images/s1-ecg-kit-front.png)
![S1 ECG Board](images/s1-ecg-kit-back.png)

<br>

## Getting started

The S1 ECG reference kit uses a three probe measurement to determine heart activity. By holding the board with both hands, the device automatically wakes from sleep, and begins calibrating the amplifier sensitivity. After a few seconds, you will see your pulse displayed on the LED bar graph. Letting go of the terminals puts the system back into sleep mode.

The base firmware is highly expandable and a perfect starting point for new designs. To get started, clone this repository:

``` bash
git clone --recurse-submodules https://github.com/siliconwitchery/s1-ecg-demo.git
```

You may need to follow the steps [here](https://github.com/siliconwitchery/s1-sdk) in order to set up the S1 SDK if you haven't already.

To build the project, run make:

``` bash
make -C firmware/
make flash -C firmware/
```

In order to flash the board. You will need a suitable SWD flasher such as a [JLink Edu Mini](https://www.digikey.se/product-detail/en/segger-microcontroller-systems/8-08-91-J-LINK-EDU-MINI/899-1061-ND/7387472), [nRF devkit](https://infocenter.nordicsemi.com/topic/ug_nrf52832_dk/UG/nrf52_DK/hw_debug_out.html) or [Blackmagic probe](https://github.com/blacksphere/blackmagic/wiki).

You will also need a Tag Connect TC2030-CTX [6 pin cable](https://www.digikey.se/product-detail/en/tag-connect-llc/TC2030-CTX/TC2030-CTX-ND/5023324).

To learn more about the S1 Module. Visit our [documentation center](https://docs.siliconwitchery.com).


## Hardware

- [Schematic](https://github.com/siliconwitchery/s1-ecg-demo/blob/main/schematic.pdf)
- [Bill of materials](https://github.com/siliconwitchery/s1-ecg-demo/blob/main/bill-of-materials.pdf)

The design was produced in [KiCad v5.1](https://www.kicad.org/download/).

## Measuring sleep current

The board features a jumper disconnect to allow for the battery current to be directly measured. During sleep modes, this can be configured down to as low as 175uA or less, depending on the sleep state needed.

Note that if the USB-C power cable is plugged in while measuring, the charge current to the battery will be measured rather than the discharge current.

## Sensitivity of the ECG amplifier and EMI

The ECG amplifier is designed to pick up the tiny signals across your hands. It's therefore quite sensitive to external interference. Operation solely from the lithium battery is ideal. Here the board remains isolated from other noise sources and accurate measurements can be made.

Certain USB-C charges can induce a lot of EMI and ground loops can be created via the users hands. This may create noise in the measurement so it's worth keeping in mind when developing or logging data.

## Looking after the battery

**Lithium batteries are of course dangerous if improperly handled.** The S1 module features safety checks to avoid damage and such damage is unlikely. However it is possible to misconfigure the integrated power management IC to overcharge/undercharge or charge the lithium battery with too much current.

It is recommended to only use the battery configuration provided in this example to ensure safety and lifetime of the lithium battery.

If in doubt, it is possible to simply remove the battery current measurement jumper, and this will disconnect the battery from the system.

## Licence

**This design is released under the [Creative Commons Attribution 4.0 International](https://creativecommons.org/licenses/by/4.0/) Licence.**

This is a human-readable summary of (and not a substitute for) the [license](https://creativecommons.org/licenses/by/4.0/legalcode).

### You are free to:

**Share** — copy and redistribute the material in any medium or format

**Adapt** — remix, transform, and build upon the material
for any purpose, even commercially.

The licensor cannot revoke these freedoms as long as you follow the license terms.

### Under the following terms:

**Attribution** — You must give appropriate credit, provide a link to the license, and indicate if changes were made. You may do so in any reasonable manner, but not in any way that suggests the licensor endorses you or your use.

**No additional restrictions** — You may not apply legal terms or technological measures that legally restrict others from doing anything the license permits.

### Notices:

You do not have to comply with the license for elements of the material in the public domain or where your use is permitted by an applicable exception or limitation.

No warranties are given. The license may not give you all of the permissions necessary for your intended use. For example, other rights such as publicity, privacy, or moral rights may limit how you use the material.