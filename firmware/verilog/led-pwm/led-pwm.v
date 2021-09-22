`timescale 1ns / 1ps
`include "block_clock.v"
`include "block_spi_slave.v"
`include "block_pwm.v"

module top(input SI,
           output SO,
           input SCK,
           input SS,
           output D6,
           output D8,
           output D7,
           output D1,
           output D4,
           output D3,
           output D2,
           output D5);

wire sys_clk;
wire pwm_clk;
wire SI;
wire SO;
wire SCK;
wire SS;
wire SI_i;
wire SCK_i;
wire SS_i;
wire D1;
wire D2;
wire D3;
wire D4;
wire D6;
wire D7;
wire D8;
reg D8_oe = 0;
wire D8_i;
reg D8_o = 0;
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

block_clock clock(.sys_clk(sys_clk), .pwm_clk(pwm_clk));
block_spi_slave spi_slave(.clk(sys_clk), .SPI_SCK(SCK_i), .SPI_CS(SS_i), .SPI_MOSI(SI_i),
                          .data_out(data), .address_out(address),
                          .data_ready(data_ready));
block_pwm pwm1(.clk(pwm_clk), .duty_cycle(duty_cycle1), .pwm_out(D2));
block_pwm pwm2(.clk(pwm_clk), .duty_cycle(duty_cycle2), .pwm_out(D3));
block_pwm pwm3(.clk(pwm_clk), .duty_cycle(duty_cycle3), .pwm_out(D4));
block_pwm pwm4(.clk(pwm_clk), .duty_cycle(duty_cycle4), .pwm_out(D1));
block_pwm pwm5(.clk(pwm_clk), .duty_cycle(duty_cycle5), .pwm_out(D7));
block_pwm pwm6(.clk(pwm_clk), .duty_cycle(duty_cycle6), .pwm_out(D6));
block_pwm pwm7(.clk(pwm_clk), .duty_cycle(duty_cycle7), .pwm_out(D5));
SB_IO #(
          .PIN_TYPE(6'b1010_01), .PULLUP(1'b0)
      ) triState_D8 (
          .PACKAGE_PIN(D8), .OUTPUT_ENABLE(D8_oe), .D_OUT_0(D8_o), .D_IN_0(D8_i)
      );

SB_IO #(
          .PIN_TYPE(6'b1010_01), .PULLUP(1'b0)
      ) triState_SI (
          .PACKAGE_PIN(SI), .OUTPUT_ENABLE(1'b0), .D_OUT_0(1'b0), .D_IN_0(SI_i)
      );
SB_IO #(
          .PIN_TYPE(6'b1010_01), .PULLUP(1'b0)
      ) triState_SO (
          .PACKAGE_PIN(SO), .OUTPUT_ENABLE(1'b0), .D_OUT_0(1'b0)
      );
SB_IO #(
          .PIN_TYPE(6'b1010_01), .PULLUP(1'b0)
      ) triState_SCK (
          .PACKAGE_PIN(SCK), .OUTPUT_ENABLE(1'b0), .D_OUT_0(1'b0), .D_IN_0(SCK_i)
      );
SB_IO #(
          .PIN_TYPE(6'b1010_01), .PULLUP(1'b0)
      ) triState_SS (
          .PACKAGE_PIN(SS), .OUTPUT_ENABLE(1'b0), .D_OUT_0(1'b0), .D_IN_0(SS_i)
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
