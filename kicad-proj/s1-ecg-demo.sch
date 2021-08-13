EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 1
Title "S1 ECG Demo"
Date "2021-08-10"
Rev "1"
Comp "Silicon Witchery AB"
Comment1 "Engineer - Rohit Nareshkumar"
Comment2 "https://creativecommons.org/licenses/by/4.0/"
Comment3 "Attribution 4.0 International License"
Comment4 "Released under the Creative Commons"
$EndDescr
$Comp
L s1-module:s1-module MOD1
U 1 1 61124856
P 2675 2400
F 0 "MOD1" H 2675 3415 50  0000 C CNN
F 1 "s1-module" H 2675 3324 50  0000 C CNN
F 2 "s1-module:s1-module" H 2675 3300 50  0001 C CNN
F 3 "" H 2675 2400 50  0001 C CNN
	1    2675 2400
	1    0    0    -1  
$EndComp
$Comp
L sw-logo:LOGO #G1
U 1 1 611251B7
P 10200 6850
F 0 "#G1" H 10200 6647 60  0001 C CNN
F 1 "LOGO" H 10200 7053 60  0001 C CNN
F 2 "" H 10200 6850 50  0001 C CNN
F 3 "" H 10200 6850 50  0001 C CNN
	1    10200 6850
	1    0    0    -1  
$EndComp
$Comp
L s1-ecg-demo:AD8233 U1
U 1 1 6112908F
P 8825 3450
F 0 "U1" H 8825 5115 50  0000 C CNN
F 1 "AD8233" H 8825 5024 50  0000 C CNN
F 2 "s1-ecg-demo:WLCSP-20" H 7575 2950 50  0001 C CNN
F 3 "https://www.analog.com/media/en/technical-documentation/data-sheets/ad8233.pdf" H 7575 2950 50  0001 C CNN
	1    8825 3450
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C5
U 1 1 6112D102
P 8850 1575
F 0 "C5" V 9079 1575 50  0000 C CNN
F 1 "0.22u" V 8988 1575 50  0000 C CNN
F 2 "" H 8850 1575 50  0001 C CNN
F 3 "~" H 8850 1575 50  0001 C CNN
	1    8850 1575
	0    -1   -1   0   
$EndComp
$Comp
L Device:C_Small C6
U 1 1 6112DEAF
P 9775 3150
F 0 "C6" H 9525 3200 50  0000 L CNN
F 1 "0.1u" H 9525 3100 50  0000 L CNN
F 2 "" H 9775 3150 50  0001 C CNN
F 3 "~" H 9775 3150 50  0001 C CNN
	1    9775 3150
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C7
U 1 1 6112EC74
P 10250 3025
F 0 "C7" H 10342 3071 50  0000 L CNN
F 1 "1u" H 10342 2980 50  0000 L CNN
F 2 "" H 10250 3025 50  0001 C CNN
F 3 "~" H 10250 3025 50  0001 C CNN
	1    10250 3025
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C3
U 1 1 6113068D
P 8050 3150
F 0 "C3" H 7950 3075 50  0000 R CNN
F 1 "1n" H 7950 3150 50  0000 R CNN
F 2 "" H 8050 3150 50  0001 C CNN
F 3 "~" H 8050 3150 50  0001 C CNN
	1    8050 3150
	-1   0    0    1   
$EndComp
$Comp
L Device:C_Small C1
U 1 1 6113493A
P 6925 2925
F 0 "C1" H 7175 2850 50  0000 R CNN
F 1 "0.22u" H 7225 2950 50  0000 R CNN
F 2 "" H 6925 2925 50  0001 C CNN
F 3 "~" H 6925 2925 50  0001 C CNN
	1    6925 2925
	-1   0    0    1   
$EndComp
$Comp
L Device:C_Small C4
U 1 1 61136345
P 8075 4075
F 0 "C4" H 8325 4025 50  0000 R CNN
F 1 "22n" H 8325 4100 50  0000 R CNN
F 2 "" H 8075 4075 50  0001 C CNN
F 3 "~" H 8075 4075 50  0001 C CNN
	1    8075 4075
	-1   0    0    1   
$EndComp
$Comp
L Device:C_Small C2
U 1 1 61137B1B
P 7300 4625
F 0 "C2" H 7575 4550 50  0000 R CNN
F 1 "10n" H 7575 4650 50  0000 R CNN
F 2 "" H 7300 4625 50  0001 C CNN
F 3 "~" H 7300 4625 50  0001 C CNN
	1    7300 4625
	-1   0    0    1   
$EndComp
Wire Wire Line
	7300 4725 7300 4850
Wire Wire Line
	7300 4850 7625 4850
Wire Wire Line
	8225 2100 8050 2100
Wire Wire Line
	8050 2100 8050 1575
Wire Wire Line
	8050 1575 8750 1575
Wire Wire Line
	9425 2100 9550 2100
Wire Wire Line
	9550 2100 9550 1575
Wire Wire Line
	9550 1575 8950 1575
Wire Wire Line
	8050 3050 8050 3000
Wire Wire Line
	8050 3000 8225 3000
Wire Wire Line
	8050 3250 8050 3300
Wire Wire Line
	8050 3300 8225 3300
Wire Wire Line
	6925 2825 6925 1200
Wire Wire Line
	6925 1200 9950 1200
Wire Wire Line
	9950 1200 9950 2400
Wire Wire Line
	9950 2400 9550 2400
Wire Wire Line
	10250 2700 10250 2925
Wire Wire Line
	10250 3125 10250 3300
Wire Wire Line
	10250 3300 9975 3300
Wire Wire Line
	9775 3250 9775 3300
Connection ~ 9775 3300
Wire Wire Line
	9775 3300 9425 3300
Wire Wire Line
	9425 3000 9550 3000
Wire Wire Line
	9775 3000 9775 3050
Wire Wire Line
	7300 4525 7300 3900
$Comp
L Device:R_Small R9
U 1 1 61146CE9
P 7625 4700
F 0 "R9" H 7425 4775 50  0000 L CNN
F 1 "1M" H 7425 4675 50  0000 L CNN
F 2 "" H 7625 4700 50  0001 C CNN
F 3 "~" H 7625 4700 50  0001 C CNN
	1    7625 4700
	1    0    0    -1  
$EndComp
$Comp
L Device:R_Small R8
U 1 1 611482B4
P 7625 4400
F 0 "R8" H 7375 4475 50  0000 L CNN
F 1 "100k" H 7375 4375 50  0000 L CNN
F 2 "" H 7625 4400 50  0001 C CNN
F 3 "~" H 7625 4400 50  0001 C CNN
	1    7625 4400
	1    0    0    -1  
$EndComp
Wire Wire Line
	7625 4500 7625 4550
Wire Wire Line
	7625 4800 7625 4850
Connection ~ 7625 4850
Wire Wire Line
	7625 4850 8225 4850
Wire Wire Line
	8225 4550 7625 4550
Connection ~ 7625 4550
Wire Wire Line
	7625 4550 7625 4600
Wire Wire Line
	8225 4250 8075 4250
Wire Wire Line
	7625 4250 7625 4300
Wire Wire Line
	8225 3900 8075 3900
$Comp
L Device:R_Small R11
U 1 1 611542F5
P 7825 3900
F 0 "R11" V 7629 3900 50  0000 C CNN
F 1 "1M" V 7720 3900 50  0000 C CNN
F 2 "" H 7825 3900 50  0001 C CNN
F 3 "~" H 7825 3900 50  0001 C CNN
	1    7825 3900
	0    1    1    0   
$EndComp
Wire Wire Line
	7725 3900 7300 3900
Wire Wire Line
	8075 3975 8075 3900
Connection ~ 8075 3900
Wire Wire Line
	8075 3900 7925 3900
Wire Wire Line
	8075 4175 8075 4250
Connection ~ 8075 4250
Wire Wire Line
	8075 4250 7625 4250
$Comp
L Device:R_Small R15
U 1 1 61157822
P 9550 2850
F 0 "R15" H 9609 2896 50  0000 L CNN
F 1 "10M" H 9609 2805 50  0000 L CNN
F 2 "" H 9550 2850 50  0001 C CNN
F 3 "~" H 9550 2850 50  0001 C CNN
	1    9550 2850
	1    0    0    -1  
$EndComp
Wire Wire Line
	9550 2950 9550 3000
Connection ~ 9550 3000
Wire Wire Line
	9550 3000 9775 3000
Wire Wire Line
	9425 2700 9550 2700
Wire Wire Line
	9550 2750 9550 2700
Connection ~ 9550 2700
Wire Wire Line
	9550 2700 9975 2700
$Comp
L Device:R_Small R14
U 1 1 6115B822
P 9550 2225
F 0 "R14" H 9609 2271 50  0000 L CNN
F 1 "10M" H 9609 2180 50  0000 L CNN
F 2 "" H 9550 2225 50  0001 C CNN
F 3 "~" H 9550 2225 50  0001 C CNN
	1    9550 2225
	1    0    0    -1  
$EndComp
Wire Wire Line
	9550 2325 9550 2400
Connection ~ 9550 2400
Wire Wire Line
	9550 2400 9425 2400
Wire Wire Line
	9550 2125 9550 2100
Connection ~ 9550 2100
$Comp
L Device:R_Small R16
U 1 1 61162002
P 9975 3025
F 0 "R16" H 10025 3050 50  0000 L CNN
F 1 "10M" H 10025 2950 50  0000 L CNN
F 2 "" H 9975 3025 50  0001 C CNN
F 3 "~" H 9975 3025 50  0001 C CNN
	1    9975 3025
	1    0    0    -1  
$EndComp
Wire Wire Line
	9975 3125 9975 3300
Connection ~ 9975 3300
Wire Wire Line
	9975 3300 9775 3300
Wire Wire Line
	9975 2925 9975 2700
Connection ~ 9975 2700
Wire Wire Line
	9975 2700 10250 2700
Wire Wire Line
	9425 3600 9625 3600
Wire Wire Line
	9425 3900 9625 3900
Wire Wire Line
	9625 3900 9625 4250
Wire Wire Line
	9625 4250 9425 4250
$Comp
L Device:R_Small R7
U 1 1 61197DAA
P 7700 2925
F 0 "R7" H 7775 3000 50  0000 L CNN
F 1 "10M" H 7775 2925 50  0000 L CNN
F 2 "" H 7700 2925 50  0001 C CNN
F 3 "~" H 7700 2925 50  0001 C CNN
	1    7700 2925
	1    0    0    -1  
$EndComp
Connection ~ 8050 3300
Wire Wire Line
	7700 3300 7700 3025
$Comp
L Device:R_Small R6
U 1 1 6119C8AC
P 7525 3100
F 0 "R6" H 7350 3125 50  0000 L CNN
F 1 "10M" H 7325 3025 50  0000 L CNN
F 2 "" H 7525 3100 50  0001 C CNN
F 3 "~" H 7525 3100 50  0001 C CNN
	1    7525 3100
	1    0    0    -1  
$EndComp
Wire Wire Line
	7525 3200 7525 3300
Wire Wire Line
	7525 3300 7700 3300
Connection ~ 7700 3300
$Comp
L Device:R_Small R12
U 1 1 6119E901
P 7925 2400
F 0 "R12" V 7750 2325 50  0000 L CNN
F 1 "182k" V 7825 2325 50  0000 L CNN
F 2 "" H 7925 2400 50  0001 C CNN
F 3 "~" H 7925 2400 50  0001 C CNN
	1    7925 2400
	0    1    1    0   
$EndComp
$Comp
L Device:R_Small R13
U 1 1 6119FD58
P 7925 2700
F 0 "R13" V 7750 2625 50  0000 L CNN
F 1 "182k" V 7825 2625 50  0000 L CNN
F 2 "" H 7925 2700 50  0001 C CNN
F 3 "~" H 7925 2700 50  0001 C CNN
	1    7925 2700
	0    1    1    0   
$EndComp
Wire Wire Line
	8025 2700 8225 2700
Wire Wire Line
	8025 2400 8225 2400
Wire Wire Line
	7825 2700 7525 2700
Wire Wire Line
	7825 2400 7700 2400
Wire Wire Line
	7700 2825 7700 2400
Connection ~ 7700 2400
Wire Wire Line
	7700 2400 6550 2400
Wire Wire Line
	7525 3000 7525 2700
Connection ~ 7525 2700
$Comp
L Device:R_Small R5
U 1 1 611CE91D
P 7125 3900
F 0 "R5" V 7275 3875 50  0000 L CNN
F 1 "200k" V 7200 3800 50  0000 L CNN
F 2 "" H 7125 3900 50  0001 C CNN
F 3 "~" H 7125 3900 50  0001 C CNN
	1    7125 3900
	0    -1   -1   0   
$EndComp
$Comp
L Device:R_Small R4
U 1 1 611D1A4B
P 6925 4075
F 0 "R4" H 6675 4150 50  0000 L CNN
F 1 "100k" H 6675 4050 50  0000 L CNN
F 2 "" H 6925 4075 50  0001 C CNN
F 3 "~" H 6925 4075 50  0001 C CNN
	1    6925 4075
	1    0    0    -1  
$EndComp
Wire Wire Line
	7225 3900 7300 3900
Connection ~ 7300 3900
Wire Wire Line
	6925 3975 6925 3900
Wire Wire Line
	6925 3900 7025 3900
Wire Wire Line
	6925 4175 6925 4250
Wire Wire Line
	6925 4250 7625 4250
Connection ~ 7625 4250
Wire Wire Line
	6575 4850 7300 4850
Connection ~ 7300 4850
Wire Wire Line
	6925 3025 6925 3900
Connection ~ 6925 3900
Wire Wire Line
	7525 2700 6550 2700
NoConn ~ 3175 2750
Wire Wire Line
	2175 1950 1900 1950
Wire Wire Line
	2175 2850 1900 2850
Wire Wire Line
	10250 3300 10475 3300
Connection ~ 10250 3300
Text Label 6550 2700 2    50   ~ 0
RA
Text Label 6550 2400 2    50   ~ 0
LA
Text Label 6575 4850 2    50   ~ 0
ECG_OUT
Wire Wire Line
	3175 2850 3450 2850
Wire Wire Line
	3175 2650 3450 2650
Wire Wire Line
	3175 2450 3450 2450
Text Label 3450 2450 0    50   ~ 0
LOD
Wire Wire Line
	3175 2350 3450 2350
Text Label 3450 2350 0    50   ~ 0
LA
Wire Wire Line
	3450 2150 3175 2150
Text Label 3450 2150 0    50   ~ 0
SWDIO
Wire Wire Line
	3175 1950 3450 1950
Wire Wire Line
	3175 2050 3450 2050
Text Label 3450 2050 0    50   ~ 0
SWDCLK
Wire Wire Line
	9775 3000 9775 2650
Connection ~ 9775 3000
Text Label 3450 2850 0    50   ~ 0
VBAT
Text Label 1900 2850 2    50   ~ 0
VBUS
Text Notes 8600 5225 0    50   ~ 0
GAIN = 1100\n7Hz - 26Hz
$Comp
L s1-ecg-demo:USB-C-16-Pin J1
U 1 1 6112F19C
P 1475 6475
F 0 "J1" H 1225 7350 50  0000 C CNN
F 1 "USB-C-16-Pin" H 1475 7250 50  0000 C CNN
F 2 "" H 1475 6475 50  0001 C CNN
F 3 "" H 1475 6475 50  0001 C CNN
	1    1475 6475
	1    0    0    -1  
$EndComp
NoConn ~ 2075 6975
NoConn ~ 2075 7075
Wire Wire Line
	2075 6375 2075 6475
Wire Wire Line
	2075 6575 2075 6675
$Comp
L Device:R_Small R1
U 1 1 6113C090
P 2300 6075
F 0 "R1" V 2150 6025 50  0000 L CNN
F 1 "5.1k" V 2225 6025 50  0000 L CNN
F 2 "" H 2300 6075 50  0001 C CNN
F 3 "~" H 2300 6075 50  0001 C CNN
	1    2300 6075
	0    1    1    0   
$EndComp
$Comp
L Device:R_Small R2
U 1 1 6113DBC7
P 2300 6175
F 0 "R2" V 2375 6125 50  0000 L CNN
F 1 "5.1k" V 2450 6125 50  0000 L CNN
F 2 "" H 2300 6175 50  0001 C CNN
F 3 "~" H 2300 6175 50  0001 C CNN
	1    2300 6175
	0    1    1    0   
$EndComp
Wire Wire Line
	2075 6075 2200 6075
Wire Wire Line
	2075 6175 2200 6175
Wire Wire Line
	2400 6075 2400 6175
Wire Wire Line
	2400 6175 2575 6175
Connection ~ 2400 6175
Text Label 2575 5875 0    50   ~ 0
VBUS
Wire Wire Line
	2075 5875 2575 5875
Wire Wire Line
	2075 6675 2575 6675
Connection ~ 2075 6675
Wire Wire Line
	2075 6475 2575 6475
Connection ~ 2075 6475
Text Label 1900 2050 2    50   ~ 0
LED2
Wire Wire Line
	1900 2050 2175 2050
$Comp
L Connector:Conn_ARM_JTAG_SWD_10 J2
U 1 1 61185655
P 3825 6625
F 0 "J2" H 3500 7600 50  0000 R CNN
F 1 "Conn_ARM_JTAG_SWD_10" H 4325 7475 50  0000 R CNN
F 2 "" H 3825 6625 50  0001 C CNN
F 3 "http://infocenter.arm.com/help/topic/com.arm.doc.ddi0314h/DDI0314H_coresight_components_trm.pdf" V 3475 5375 50  0001 C CNN
	1    3825 6625
	1    0    0    -1  
$EndComp
Text Label 3450 2250 0    50   ~ 0
VREF
Wire Wire Line
	3175 2250 3450 2250
Text Label 3900 6000 0    50   ~ 0
VREF
Wire Wire Line
	3825 6025 3825 6000
Wire Wire Line
	3825 6000 3900 6000
NoConn ~ 4325 6725
NoConn ~ 4325 6825
NoConn ~ 4325 6325
Wire Wire Line
	3725 7225 3825 7225
Wire Wire Line
	3825 7225 3825 7375
Connection ~ 3825 7225
Text Label 4500 6525 0    50   ~ 0
SWDCLK
Text Label 4500 6625 0    50   ~ 0
SWDIO
Wire Wire Line
	4325 6525 4500 6525
Wire Wire Line
	4325 6625 4500 6625
Wire Wire Line
	9425 4550 9625 4550
Wire Wire Line
	9625 4550 9625 4250
Connection ~ 9625 4250
Text Label 9825 4850 0    50   ~ 0
LOD
Wire Wire Line
	9425 4850 9825 4850
Wire Wire Line
	1900 2250 2175 2250
Text Label 1900 2250 2    50   ~ 0
LED4
Text Label 1900 2150 2    50   ~ 0
LED3
Wire Wire Line
	1900 2150 2175 2150
NoConn ~ 2575 6475
NoConn ~ 2575 6675
Wire Wire Line
	3200 4625 3200 4725
$Comp
L Device:R_Small R3
U 1 1 611FF2F6
P 3200 4525
F 0 "R3" H 3025 4450 50  0000 L CNN
F 1 "665" H 2975 4525 50  0000 L CNN
F 2 "" H 3200 4525 50  0001 C CNN
F 3 "~" H 3200 4525 50  0001 C CNN
	1    3200 4525
	-1   0    0    1   
$EndComp
Wire Wire Line
	1350 4675 1350 4975
Text Label 1350 4575 2    50   ~ 0
VBAT
$Comp
L Connector_Generic:Conn_01x02 J3
U 1 1 611DEDCA
P 1550 4975
F 0 "J3" H 1630 4967 50  0000 L CNN
F 1 "Battery Port" H 1630 4876 50  0000 L CNN
F 2 "" H 1550 4975 50  0001 C CNN
F 3 "~" H 1550 4975 50  0001 C CNN
	1    1550 4975
	1    0    0    -1  
$EndComp
Wire Wire Line
	3200 5150 3075 5150
Wire Wire Line
	3200 5025 3200 5150
$Comp
L Device:LED D1
U 1 1 611FA4FD
P 3200 4875
F 0 "D1" V 3239 4757 50  0000 R CNN
F 1 "LED" V 3148 4757 50  0000 R CNN
F 2 "" H 3200 4875 50  0001 C CNN
F 3 "~" H 3200 4875 50  0001 C CNN
	1    3200 4875
	0    -1   -1   0   
$EndComp
Text Label 3200 4250 2    50   ~ 0
LED1
Text Label 1900 2350 2    50   ~ 0
LED1
Text Label 1900 2450 2    50   ~ 0
LED7
Text Label 1900 2650 2    50   ~ 0
LED6
Text Label 1900 2750 2    50   ~ 0
LED5
Wire Wire Line
	2175 2350 1900 2350
Wire Wire Line
	2175 2450 1900 2450
Wire Wire Line
	2175 2650 1900 2650
Wire Wire Line
	2175 2750 1900 2750
Wire Wire Line
	1900 2550 2175 2550
$Comp
L Device:LED D2
U 1 1 611BF889
P 3600 4900
F 0 "D2" V 3639 4782 50  0000 R CNN
F 1 "LED" V 3548 4782 50  0000 R CNN
F 2 "" H 3600 4900 50  0001 C CNN
F 3 "~" H 3600 4900 50  0001 C CNN
	1    3600 4900
	0    -1   -1   0   
$EndComp
$Comp
L Device:LED D3
U 1 1 611C0A6C
P 3975 4900
F 0 "D3" V 4014 4782 50  0000 R CNN
F 1 "LED" V 3923 4782 50  0000 R CNN
F 2 "" H 3975 4900 50  0001 C CNN
F 3 "~" H 3975 4900 50  0001 C CNN
	1    3975 4900
	0    -1   -1   0   
$EndComp
$Comp
L Device:LED D4
U 1 1 611C0E9A
P 4350 4900
F 0 "D4" V 4389 4782 50  0000 R CNN
F 1 "LED" V 4298 4782 50  0000 R CNN
F 2 "" H 4350 4900 50  0001 C CNN
F 3 "~" H 4350 4900 50  0001 C CNN
	1    4350 4900
	0    -1   -1   0   
$EndComp
$Comp
L Device:LED D5
U 1 1 611C8BEB
P 4725 4900
F 0 "D5" V 4764 4782 50  0000 R CNN
F 1 "LED" V 4673 4782 50  0000 R CNN
F 2 "" H 4725 4900 50  0001 C CNN
F 3 "~" H 4725 4900 50  0001 C CNN
	1    4725 4900
	0    -1   -1   0   
$EndComp
$Comp
L Device:LED D6
U 1 1 611C9243
P 5075 4900
F 0 "D6" V 5114 4782 50  0000 R CNN
F 1 "LED" V 5023 4782 50  0000 R CNN
F 2 "" H 5075 4900 50  0001 C CNN
F 3 "~" H 5075 4900 50  0001 C CNN
	1    5075 4900
	0    -1   -1   0   
$EndComp
$Comp
L Device:LED D7
U 1 1 611C94F1
P 5425 4900
F 0 "D7" V 5464 4782 50  0000 R CNN
F 1 "LED" V 5373 4782 50  0000 R CNN
F 2 "" H 5425 4900 50  0001 C CNN
F 3 "~" H 5425 4900 50  0001 C CNN
	1    5425 4900
	0    -1   -1   0   
$EndComp
$Comp
L Device:R_Small R17
U 1 1 611E7792
P 3600 4525
F 0 "R17" H 3425 4450 50  0000 L CNN
F 1 "665" H 3375 4525 50  0000 L CNN
F 2 "" H 3600 4525 50  0001 C CNN
F 3 "~" H 3600 4525 50  0001 C CNN
	1    3600 4525
	-1   0    0    1   
$EndComp
$Comp
L Device:R_Small R18
U 1 1 611E7C2E
P 3975 4525
F 0 "R18" H 3800 4450 50  0000 L CNN
F 1 "665" H 3750 4525 50  0000 L CNN
F 2 "" H 3975 4525 50  0001 C CNN
F 3 "~" H 3975 4525 50  0001 C CNN
	1    3975 4525
	-1   0    0    1   
$EndComp
$Comp
L Device:R_Small R19
U 1 1 611E8186
P 4350 4525
F 0 "R19" H 4175 4450 50  0000 L CNN
F 1 "665" H 4125 4525 50  0000 L CNN
F 2 "" H 4350 4525 50  0001 C CNN
F 3 "~" H 4350 4525 50  0001 C CNN
	1    4350 4525
	-1   0    0    1   
$EndComp
$Comp
L Device:R_Small R20
U 1 1 611E86B7
P 4725 4525
F 0 "R20" H 4550 4450 50  0000 L CNN
F 1 "665" H 4500 4525 50  0000 L CNN
F 2 "" H 4725 4525 50  0001 C CNN
F 3 "~" H 4725 4525 50  0001 C CNN
	1    4725 4525
	-1   0    0    1   
$EndComp
$Comp
L Device:R_Small R21
U 1 1 611E8CBB
P 5075 4525
F 0 "R21" H 4900 4450 50  0000 L CNN
F 1 "665" H 4850 4525 50  0000 L CNN
F 2 "" H 5075 4525 50  0001 C CNN
F 3 "~" H 5075 4525 50  0001 C CNN
	1    5075 4525
	-1   0    0    1   
$EndComp
$Comp
L Device:R_Small R22
U 1 1 611E98C2
P 5425 4525
F 0 "R22" H 5250 4450 50  0000 L CNN
F 1 "665" H 5200 4525 50  0000 L CNN
F 2 "" H 5425 4525 50  0001 C CNN
F 3 "~" H 5425 4525 50  0001 C CNN
	1    5425 4525
	-1   0    0    1   
$EndComp
Text Label 3600 4250 2    50   ~ 0
LED2
Text Label 3975 4250 2    50   ~ 0
LED3
Text Label 4350 4250 2    50   ~ 0
LED4
Text Label 4725 4250 2    50   ~ 0
LED5
Text Label 5075 4250 2    50   ~ 0
LED6
Text Label 5425 4250 2    50   ~ 0
LED7
Wire Wire Line
	3200 4250 3200 4425
Wire Wire Line
	3600 4250 3600 4425
Wire Wire Line
	3975 4250 3975 4425
Wire Wire Line
	4350 4250 4350 4425
Wire Wire Line
	4725 4250 4725 4425
Wire Wire Line
	5075 4250 5075 4425
Wire Wire Line
	5425 4250 5425 4425
Wire Wire Line
	5425 4625 5425 4750
Wire Wire Line
	5075 4625 5075 4750
Wire Wire Line
	4725 4625 4725 4750
Wire Wire Line
	4350 4625 4350 4750
Wire Wire Line
	3600 4625 3600 4750
Wire Wire Line
	3975 4625 3975 4750
Wire Wire Line
	3600 5050 3600 5150
Wire Wire Line
	3600 5150 3200 5150
Connection ~ 3200 5150
Wire Wire Line
	3975 5050 3975 5150
Wire Wire Line
	3975 5150 3600 5150
Connection ~ 3600 5150
Wire Wire Line
	4350 5050 4350 5150
Wire Wire Line
	4350 5150 3975 5150
Connection ~ 3975 5150
Wire Wire Line
	4350 5150 4725 5150
Wire Wire Line
	4725 5150 4725 5050
Connection ~ 4350 5150
Wire Wire Line
	4725 5150 5075 5150
Wire Wire Line
	5075 5150 5075 5050
Connection ~ 4725 5150
Wire Wire Line
	5075 5150 5425 5150
Wire Wire Line
	5425 5150 5425 5050
Connection ~ 5075 5150
$Comp
L power:GND #PWR03
U 1 1 612788AB
P 3075 5150
F 0 "#PWR03" H 3075 4900 50  0001 C CNN
F 1 "GND" H 3080 4977 50  0000 C CNN
F 2 "" H 3075 5150 50  0001 C CNN
F 3 "" H 3075 5150 50  0001 C CNN
	1    3075 5150
	1    0    0    -1  
$EndComp
Wire Wire Line
	3175 2550 3450 2550
$Comp
L power:+3V3 #PWR02
U 1 1 612824F5
P 3450 2650
F 0 "#PWR02" H 3450 2500 50  0001 C CNN
F 1 "+3V3" V 3425 2750 50  0000 L CNN
F 2 "" H 3450 2650 50  0001 C CNN
F 3 "" H 3450 2650 50  0001 C CNN
	1    3450 2650
	0    1    1    0   
$EndComp
$Comp
L power:GND #PWR01
U 1 1 6127ADA9
P 3450 2550
F 0 "#PWR01" H 3450 2300 50  0001 C CNN
F 1 "GND" H 3525 2600 50  0001 C CNN
F 2 "" H 3450 2550 50  0001 C CNN
F 3 "" H 3450 2550 50  0001 C CNN
	1    3450 2550
	0    -1   -1   0   
$EndComp
$Comp
L power:GND #PWR06
U 1 1 612AC006
P 10475 3300
F 0 "#PWR06" H 10475 3050 50  0001 C CNN
F 1 "GND" H 10550 3350 50  0001 C CNN
F 2 "" H 10475 3300 50  0001 C CNN
F 3 "" H 10475 3300 50  0001 C CNN
	1    10475 3300
	1    0    0    -1  
$EndComp
$Comp
L power:+3V3 #PWR05
U 1 1 612C0F0A
P 9800 3600
F 0 "#PWR05" H 9800 3450 50  0001 C CNN
F 1 "+3V3" H 9700 3750 50  0000 L CNN
F 2 "" H 9800 3600 50  0001 C CNN
F 3 "" H 9800 3600 50  0001 C CNN
	1    9800 3600
	1    0    0    -1  
$EndComp
$Comp
L Connector_Generic:Conn_01x02 J4
U 1 1 612E8F9F
P 1550 4575
F 0 "J4" H 1630 4567 50  0000 L CNN
F 1 "Current Probe" H 1630 4476 50  0000 L CNN
F 2 "" H 1550 4575 50  0001 C CNN
F 3 "~" H 1550 4575 50  0001 C CNN
	1    1550 4575
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR08
U 1 1 612FCD59
P 1900 1950
F 0 "#PWR08" H 1900 1700 50  0001 C CNN
F 1 "GND" H 1975 2000 50  0001 C CNN
F 2 "" H 1900 1950 50  0001 C CNN
F 3 "" H 1900 1950 50  0001 C CNN
	1    1900 1950
	-1   0    0    1   
$EndComp
$Comp
L power:+3V3 #PWR012
U 1 1 612FFD06
P 9775 2650
F 0 "#PWR012" H 9775 2500 50  0001 C CNN
F 1 "+3V3" H 9675 2800 50  0000 L CNN
F 2 "" H 9775 2650 50  0001 C CNN
F 3 "" H 9775 2650 50  0001 C CNN
	1    9775 2650
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR011
U 1 1 61352A98
P 3825 7375
F 0 "#PWR011" H 3825 7125 50  0001 C CNN
F 1 "GND" H 3900 7425 50  0001 C CNN
F 2 "" H 3825 7375 50  0001 C CNN
F 3 "" H 3825 7375 50  0001 C CNN
	1    3825 7375
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR07
U 1 1 61355C6C
P 1475 7375
F 0 "#PWR07" H 1475 7125 50  0001 C CNN
F 1 "GND" H 1550 7425 50  0001 C CNN
F 2 "" H 1475 7375 50  0001 C CNN
F 3 "" H 1475 7375 50  0001 C CNN
	1    1475 7375
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR09
U 1 1 61356705
P 2575 6175
F 0 "#PWR09" H 2575 5925 50  0001 C CNN
F 1 "GND" H 2650 6225 50  0001 C CNN
F 2 "" H 2575 6175 50  0001 C CNN
F 3 "" H 2575 6175 50  0001 C CNN
	1    2575 6175
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR010
U 1 1 61359CD0
P 3450 1950
F 0 "#PWR010" H 3450 1700 50  0001 C CNN
F 1 "GND" H 3525 2000 50  0001 C CNN
F 2 "" H 3450 1950 50  0001 C CNN
F 3 "" H 3450 1950 50  0001 C CNN
	1    3450 1950
	-1   0    0    1   
$EndComp
$Comp
L power:GND #PWR04
U 1 1 6135CB63
P 1350 5075
F 0 "#PWR04" H 1350 4825 50  0001 C CNN
F 1 "GND" H 1425 5125 50  0001 C CNN
F 2 "" H 1350 5075 50  0001 C CNN
F 3 "" H 1350 5075 50  0001 C CNN
	1    1350 5075
	1    0    0    -1  
$EndComp
Wire Wire Line
	7700 3300 8050 3300
$Comp
L Device:R_Small R10
U 1 1 611989CB
P 7150 3300
F 0 "R10" V 6950 3225 50  0000 L CNN
F 1 "499k" V 7025 3225 50  0000 L CNN
F 2 "" H 7150 3300 50  0001 C CNN
F 3 "~" H 7150 3300 50  0001 C CNN
	1    7150 3300
	0    1    1    0   
$EndComp
Wire Wire Line
	7250 3300 7525 3300
Connection ~ 7525 3300
Wire Wire Line
	7050 3300 6550 3300
Text Label 6550 3300 2    50   ~ 0
RL
NoConn ~ 1900 2550
$Comp
L Device:R_Small R23
U 1 1 611B2E24
P 7975 3600
F 0 "R23" V 8125 3575 50  0000 L CNN
F 1 "100k" V 8050 3500 50  0000 L CNN
F 2 "" H 7975 3600 50  0001 C CNN
F 3 "~" H 7975 3600 50  0001 C CNN
	1    7975 3600
	0    -1   -1   0   
$EndComp
Wire Wire Line
	8075 3600 8225 3600
Wire Wire Line
	7625 4250 7625 3600
Wire Wire Line
	7625 3600 7875 3600
Wire Wire Line
	9625 3900 9625 3600
Connection ~ 9625 3900
Wire Wire Line
	9800 3600 9625 3600
Connection ~ 9625 3600
$EndSCHEMATC
