`timescale 1ns / 1ps

module block_pwm (input clk, input [7:0] duty_cycle, output pwm_out);

wire clk;
wire [7:0] duty_cycle;
reg pwm_out = 0;
reg [7:0] counter = 0;

always @(posedge clk) begin
    counter <= counter + 1;
    if (counter < duty_cycle) pwm_out <= 1; 
    else pwm_out <= 0;
end

endmodule

module block_spi_peripheral(input wire clk, input wire reset, input wire SPI_SCK,
                       input wire SPI_CS, input wire SPI_COPI, output SPI_CIPO,
                       output [7:0] address_out, output [7:0] data_out, output data_ready
                      );

// sync to FPGA clock using a 3-bit shift register
reg [2:0] SCKreg;
reg [2:0] CSreg;
reg [1:0] MOSIreg;

wire SCK_rising = (SCKreg[2:1]==2'b01);  // rising edges
wire SCK_falling = (SCKreg[2:1]==2'b10);  // falling edges
wire CS_active = CSreg[1];  // CS is active high
wire MOSI_data = MOSIreg[1];

reg [3:0] bit_counter;

reg data_ready;  // high when a byte has been received
reg [15:0] data_received = 0;
reg [7:0] address_out = 0;
reg [7:0] data_out = 0;

always @(posedge clk) begin
    SCKreg <= {SCKreg[1:0], SPI_SCK};
    CSreg <= {CSreg[1:0], SPI_CS};
    MOSIreg <= {MOSIreg[0], SPI_COPI};

    if(!CS_active) begin
        bit_counter <= 0;
        data_out <= data_received[7:0];
        address_out <= data_received[15:8];
        data_ready <= 1;
    end
    else begin
        data_ready <= 0;
        if(SCK_rising)  begin
            bit_counter <= bit_counter + 1;
            data_received <= {data_received[14:0], MOSI_data};
        end
    end
end

endmodule


module top(input COPI,
           output CIPO,
           input SCK,
           input CS,
           output D6,
           output D8,
           output D7,
           output D1,
           output D4,
           output D3,
           output D2,
           output D5);

wire sys_clk, pwm_clk;
wire COPI, CIPO, SCK, CS, COPI_i, SCK_i, CS_i;
wire D1, D2, D3, D4, D5, D6, D7, D8, D8_i;
reg D8_oe = 0, D8_o = 0;

SB_HFOSC #(.CLKHF_DIV("0b11"))  osc(.CLKHFEN(1'b1),     // enable
                                    .CLKHFPU(1'b1), // power up
                                    .CLKHF(sys_clk)         // output to sysclk
                                   ) /* synthesis ROUTE_THROUGH_FABRIC=0 */;
reg [9:0] clk_counter;
assign pwm_clk = clk_counter[9];

always @(posedge sys_clk) begin
    // Count and increment the output port
    clk_counter <= clk_counter + 1'b1;
end

block_spi_peripheral spi_peripheral(.clk(sys_clk), .SPI_SCK(SCK_i), .SPI_CS(CS_i), .SPI_COPI(COPI_i),
                          .data_out(data), .address_out(address),
                          .data_ready(data_ready));

reg [7:0] duty_cycle1 = 0;
reg [7:0] duty_cycle2 = 0;
reg [7:0] duty_cycle3 = 0;
reg [7:0] duty_cycle4 = 0;
reg [7:0] duty_cycle5 = 0;
reg [7:0] duty_cycle6 = 0;
reg [7:0] duty_cycle7 = 0;
wire [7:0] data;
wire [7:0] address;
wire data_ready;

block_pwm pwm1(.clk(pwm_clk), .duty_cycle(duty_cycle1), .pwm_out(D2));
block_pwm pwm2(.clk(pwm_clk), .duty_cycle(duty_cycle2), .pwm_out(D3));
block_pwm pwm3(.clk(pwm_clk), .duty_cycle(duty_cycle3), .pwm_out(D4));
block_pwm pwm4(.clk(pwm_clk), .duty_cycle(duty_cycle4), .pwm_out(D1));
block_pwm pwm5(.clk(pwm_clk), .duty_cycle(duty_cycle5), .pwm_out(D7));
block_pwm pwm6(.clk(pwm_clk), .duty_cycle(duty_cycle6), .pwm_out(D6));
block_pwm pwm7(.clk(pwm_clk), .duty_cycle(duty_cycle7), .pwm_out(D5));

SB_IO #(
          .PIN_TYPE(6'b1010_01), .PULLUP(1'b0)
      ) tristate_D8 (
          .PACKAGE_PIN(D8), .OUTPUT_ENABLE(D8_oe), .D_OUT_0(D8_o), .D_IN_0(D8_i)
      );

SB_IO #(
          .PIN_TYPE(6'b1010_01), .PULLUP(1'b0)
      ) tristate_SI (
          .PACKAGE_PIN(COPI), .OUTPUT_ENABLE(1'b0), .D_OUT_0(1'b0), .D_IN_0(COPI_i)
      );
SB_IO #(
          .PIN_TYPE(6'b1010_01), .PULLUP(1'b0)
      ) tristate_SO (
          .PACKAGE_PIN(CIPO), .OUTPUT_ENABLE(1'b0), .D_OUT_0(1'b0)
      );
SB_IO #(
          .PIN_TYPE(6'b1010_01), .PULLUP(1'b0)
      ) tristate_SCK (
          .PACKAGE_PIN(SCK), .OUTPUT_ENABLE(1'b0), .D_OUT_0(1'b0), .D_IN_0(SCK_i)
      );
SB_IO #(
          .PIN_TYPE(6'b1010_01), .PULLUP(1'b0)
      ) tristate_SS (
          .PACKAGE_PIN(CS), .OUTPUT_ENABLE(1'b0), .D_OUT_0(1'b0), .D_IN_0(CS_i)
      );

always @(posedge sys_clk) begin
    if (data_ready) begin
        case (address)
            1 : duty_cycle1 <= data;
            2 : duty_cycle2 <= data;
            3 : duty_cycle3 <= data;
            4 : duty_cycle4 <= data;
            5 : duty_cycle5 <= data;
            6 : duty_cycle6 <= data;
            7 : duty_cycle7 <= data;
            0 : D8_oe <= ~data[0];
            'hFF : begin
                duty_cycle1 <= 0;
                duty_cycle2 <= 0;
                duty_cycle3 <= 0;
                duty_cycle4 <= 0;
                duty_cycle5 <= 0;
                duty_cycle6 <= 0;
                duty_cycle7 <= 0;
            end
        endcase
    end
end
endmodule
