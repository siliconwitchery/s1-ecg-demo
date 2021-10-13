`timescale 1ns / 1ps
// `include "block_clock.v"

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

assign D3 = 1'b0;

// wire clk;
// reg led = 0;
// reg [21:0] count = 0;

// block_clock clk_src(
//                 .clk(clk)
//             );

// assign D8 = led;
// assign D7 = led;
// assign D1 = led;
// assign D4 = led;
// assign D3 = led;
// assign D2 = led;
// assign D5 = led;
// assign D6 = led;

// always @(posedge clk) begin
//     if(count == 0) led <= ~led;
//     count <= count + 1;
// end

endmodule
