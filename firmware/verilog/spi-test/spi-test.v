`timescale 1ns / 1ps

module top(output D3, input D1, input D2, input D7, output D8);

wire clk;

block_clock clock(.clk(clk));
block_spi_slave spi_slave_inst(.clk(clk), .SPI_SCK(D1), .SPI_SS(D2), .SPI_MOSI(D7),
                               .SPI_MISO(D8)
                              );
block_async_fifo fifo(.w_clk(w_clk));
endmodule
