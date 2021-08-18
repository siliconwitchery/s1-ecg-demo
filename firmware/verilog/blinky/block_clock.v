module block_clock (
           output clk,
           output i2c_clk
       );

wire clock;

SB_HFOSC #(.CLKHF_DIV("0b11"))  osc(.CLKHFEN(1'b1),     // enable 01
                                    .CLKHFPU(1'b1), // power up
                                    .CLKHF(clock)         // output to sysclk
                                   ) /* synthesis ROUTE_THROUGH_FABRIC=0 */;

reg [7:0] counter;
reg [15:0] counter2;
reg state = 0;
reg state2 = 0;
reg slow_clk;

always @(posedge clk) begin

    // Count and increment the output port
    counter <= counter + 1'b1;
    // 24MHz / 30 = 800kHz, use 14 for half duty cycle
    if(counter == 8'd14)begin // d14
        counter <= 0;
        state = ~state;
    end
end

always @(posedge clock) begin

    // Count and increment the output port
    counter2 <= counter2 + 1'b1;
    // 6MHz / 14 = 400kHz
    if(counter2 == 'd100) begin
        counter2 <= 0;
        state2 = ~state2;
    end
end

assign i2c_clk = state;
assign clk = clock;
// assign clk = state2;

endmodule
