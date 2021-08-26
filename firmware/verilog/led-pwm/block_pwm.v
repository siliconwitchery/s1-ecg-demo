module block_pwm (input clk, input [7:0] duty_cycle, output pwm_out);

wire clk;
wire [7:0] duty_cycle;
reg pwm_out = 0;
reg [7:0] counter = 0;

always @(posedge clk) begin
    counter <= counter + 1;
    if (counter > duty_cycle) pwm_out <= 0; 
    else pwm_out <= 1;
end

endmodule