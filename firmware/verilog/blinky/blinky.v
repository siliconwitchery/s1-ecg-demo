`timescale 1ns / 1ps
`include "block_clock.v"

module top (
           output wire D1,
           output wire D2,
           output wire D3,
           output wire D4,
           output wire D5,
           output wire D6,
           output wire D7,
           output wire D8
       );

wire clk;
reg led = 0;
reg [21:0] count = 0;

block_clock clk_src(
                .clk(clk)
            );

assign D8 = 0;
assign D7 = 0;
assign D1 = 0;
assign D4 = 0;
assign D3 = led;
assign D2 = 0;
assign D5 = 0;
assign D6 = 0;

always @(posedge clk) begin
    if(count == 0) led <= ~led;
    count <= count + 1;
end

endmodule
