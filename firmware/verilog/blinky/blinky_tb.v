`timescale 1ns / 1ps

module blinky_tb;

parameter DURATION = 5000000;

// Connections
reg clk;

initial begin
    $dumpfile("blinky_tb");      // create a VCD waveform dump
    $dumpvars(2, blinky_tb); // dump variable changes in the testbench
    clk = 0;
    forever begin
        clk = 0;
        #1;
        clk = 1;
        #1;
    end
end

initial begin
    // Initialize Inputs
    clk = 0;
    #(DURATION)
     $finish;
end

always @(posedge i2c_clk) begin
    if (state == INIT) begin
        if (init_delay_count != 0) begin
            global_rst <= 1;
            init_delay_count <= init_delay_count - 1;
        end
        else begin
            global_rst <= 0;
            state <= I2C;
        end
    end

    if (state == I2C) begin
        led_enable <= 1;
    end
end

endmodule

    module clk_div (
        input wire clk, input wire rst, output wire i2c_clk
    );

reg bs = 0;
reg [7:0] counter = 0;
assign i2c_clk = bs;

always @(posedge clk) begin
    if (!rst) begin
        counter <= counter + 1'b1;
        // 24MHz / 30 = 800kHz, use 14 for half duty cycle
        if(counter == 'd14)begin // d14
            counter <= 0;
            bs <= ~bs;
        end
    end
end
endmodule
