module block_clock (
           output clk
       );

wire clock;
wire clk;
wire slow_clk;

SB_HFOSC #(.CLKHF_DIV("0b11"))  osc(.CLKHFEN(1'b1),     // enable
                                    .CLKHFPU(1'b1), // power up
                                    .CLKHF(clock)         // output to sysclk
                                   ) /* synthesis ROUTE_THROUGH_FABRIC=0 */;

reg [9:0] counter;
assign slow_clk = counter[9];

always @(posedge clock) begin
    // Count and increment the output port
    counter <= counter + 1'b1;
end

assign clk = clock;
// assign clk = clock;

endmodule
