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
           output D2);

wire clk;
wire SI;
wire SO;
wire SCK;
wire SS;
wire D1;
wire D2;
wire D3;
wire D4;
wire D6;
wire D7;
wire D8;
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

block_clock clock(.clk(clk));
block_spi_slave spi_slave(.clk(clk), .SPI_SCK(SCK), .SPI_CS(SS), .SPI_MOSI(SI),
                          .SPI_MISO(SO), .data_out(data), .address_out(address),
                          .data_ready(data_ready));
block_pwm pwm1(.clk(clk), .duty_cycle(duty_cycle1), .pwm_out(D6));
block_pwm pwm2(.clk(clk), .duty_cycle(duty_cycle2), .pwm_out(D8));
block_pwm pwm3(.clk(clk), .duty_cycle(duty_cycle3), .pwm_out(D7));
block_pwm pwm4(.clk(clk), .duty_cycle(duty_cycle4), .pwm_out(D1));
block_pwm pwm5(.clk(clk), .duty_cycle(duty_cycle5), .pwm_out(D4));
block_pwm pwm6(.clk(clk), .duty_cycle(duty_cycle6), .pwm_out(D3));
block_pwm pwm7(.clk(clk), .duty_cycle(duty_cycle7), .pwm_out(D2));

always @(posedge clk) begin
    if (data_ready) begin
        case (address)
            1 : duty_cycle1 <= data;
            2 : duty_cycle2 <= data;
            3 : duty_cycle3 <= data;
            4 : duty_cycle4 <= data;
            5 : duty_cycle5 <= data;
            6 : duty_cycle6 <= data;
            7 : duty_cycle7 <= data;
        endcase
    end
end

endmodule
