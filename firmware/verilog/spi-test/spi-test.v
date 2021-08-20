`timescale 1ns / 1ps
`include "block_clock.v"
`include "block_spi_slave.v"

module top(input SI,
           output SO,
           input SCK,
           input SS,
           output D3,
           output D6,
           output D7,
           output D8);

wire clk;
wire SI;
wire SO;
wire SCK;
wire SS;
wire D3;
wire D6;
wire D7;
wire D8;
wire [7:0] data;
wire data_ready;

// assign D6 = SCK;
// assign D7 = SI;
// assign D8 = data_ready;
assign D6 = data[0];
assign D7 = data[2];
assign D8 = data[1];

block_clock clock(.clk(clk));
block_spi_slave spi_slave(.clk(clk), .SPI_SCK(SCK), .SPI_CS(SS), .SPI_MOSI(SI),
                          .SPI_MISO(SO), .data_out(data), .data_ready(data_ready));

assign D3 = data[0];

endmodule
