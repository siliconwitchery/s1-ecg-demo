module block_clock (
           input clk_en,
           output sys_clk,
           output pwm_clk
       );

wire clock;
wire sys_clk;
wire pwm_clk;
wire clk_en;

SB_HFOSC #(.CLKHF_DIV("0b11"))  osc(.CLKHFEN(1'b1),     // enable
                                    .CLKHFPU(1'b1), // power up
                                    .CLKHF(clock)         // output to sysclk
                                   ) /* synthesis ROUTE_THROUGH_FABRIC=0 */;

reg [9:0] counter;
assign pwm_clk = counter[9];

always @(posedge clock) begin
    // Count and increment the output port
    counter <= counter + 1'b1;
end

assign sys_clk = clock;

endmodule
