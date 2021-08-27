`timescale 1ns / 1ps
`include "io_extend.v"

module io_extend_tb;

parameter DURATION = 100;

reg SI, SCK, SS, clk;
wire D1, D2, D3, D4, D5, D6, D7, SO;

io_extend io_extend(.SI(SI), .SO(SO), .SCK(SCK), .SS(SS), .D1(D1),
                    .D2(D2), .D3(D3), .D4(D4), .D5(D5), .D6(D6), .D7(D7), .sim_clk(clk));

initial begin
    $dumpfile("io_extend_tb");      // create a VCD waveform dump
    $dumpvars(0, io_extend_tb); // dump variable changes in the testbench
    clk = 0;
    SI = 0; SCK = 0; SS = 1;
    forever begin
        clk = 0;
        #1;
        clk = 1;
        #1;
    end
end

initial begin
    // #(DURATION)
    //  $finish;
    #2; SS = 1;
    #2; SCK = 1; SI = 0; #2; SCK = 0; // 0
    #2; SCK = 1; SI = 0; #2; SCK = 0;
    #2; SCK = 1; SI = 0; #2; SCK = 0;
    #2; SCK = 1; SI = 0; #2; SCK = 0;
    #2; SCK = 1; SI = 0; #2; SCK = 0;
    #2; SCK = 1; SI = 0; #2; SCK = 0;
    #2; SCK = 1; SI = 0; #2; SCK = 0;
    #2; SCK = 1; SI = 0; #2; SCK = 0;
    #2; SCK = 1; SI = 0; #2; SCK = 0;
    #2; SCK = 1; SI = 0; #2; SCK = 0;
    #2; SCK = 1; SI = 0; #2; SCK = 0;
    #2; SCK = 1; SI = 0; #2; SCK = 0;
    #2; SCK = 1; SI = 0; #2; SCK = 0;
    #2; SCK = 1; SI = 0; #2; SCK = 0;
    #2; SCK = 1; SI = 0; #2; SCK = 0;
    #2; SCK = 1; SI = 1; #2; SCK = 0; //15
    #2; SS = 0;

    #50; $finish;

end

endmodule