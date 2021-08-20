`timescale 1ns / 1ps
`include "block_clock.v"
`include "block_spi_slave.v"
`include "block_pwm.v"

module top(input SI,
           output SO,
           input SCK,
           input SS,
           output D3);

wire clk;
wire SI;
wire SO;
wire SCK;
wire SS;
wire D3;
wire [7:0] data;
wire data_ready;
wire pwm_val;

block_clock clock(.clk(clk));
block_spi_slave spi_slave(.clk(clk), .SPI_SCK(SCK), .SPI_CS(SS), .SPI_MOSI(SI),
                          .SPI_MISO(SO), .data_out(data), .data_ready(data_ready));
block_pwm pwm(.clk(clk), .duty_cycle(data), .pwm_out(pwm_val));

assign D3 = pwm_val;

endmodule
