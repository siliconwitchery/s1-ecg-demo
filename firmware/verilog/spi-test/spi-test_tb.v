`default_nettype none
`define DUMPSTR(x) `"x.vcd`"
`timescale 10 ns / 1 ns


module main_tb;

// Input/Output
reg clk;
// reg sck;
// reg ss;
// reg si;
// wire d3;
// wire so;

reg bclk;
reg [7:0] wdata;
wire wclk, rclk;
reg wrst_n;
wire winc;
wire rinc;
reg rrst_n;
wire [7:0] rdata;
wire wfull, rempty;
reg write_en = 0, read_en = 0;

// Module instance
// block_spi_slave spi_slave_inst(.clk(clk), .SPI_SCK(sck), .SPI_SS(ss), .SPI_MOSI(si),
//    .SPI_MISO(so), .LED(d3));

block_fifo fifo (.rdata(rdata), .wfull(wfull), .rempty(rempty), .wdata(wdata),
                 .winc(winc), .wclk(wclk), .wrst_n(wrst_n), .rinc(rinc), .rclk(rclk),
                 .rrst_n(rrst_n));

initial begin
    // File were to store the simulation results
    $dumpfile(`DUMPSTR(`VCD_OUTPUT));
    $dumpvars(0, main_tb);
    clk = 0;
    forever begin
        clk = #2 ~clk;
    end
end

initial begin
    bclk = 0;
    forever begin
        bclk = #3 ~bclk;
    end
end

initial begin
    //     sck = 0;
    //     ss = 1;
    //     si = 0;

    //     #50;
    //     ss = 0;
    //     #2; sck = 1; si = 1;
    //     #1; sck = 0;
    //     #1; sck = 1; si = 1;
    //     #1; sck = 0;
    //     #1; sck = 1; si = 1;
    //     #1; sck = 0;
    //     #1; sck = 1; si = 1;
    //     #1; sck = 0;
    //     #1; sck = 1; si = 1;
    //     #1; sck = 0;
    //     #1; sck = 1; si = 1;
    //     #1; sck = 0;
    //     #1; sck = 1; si = 1;
    //     #1; sck = 0;
    //     #1; sck = 1; si = 1;
    //     #1; sck = 0;
    //     #2; ss = 1;

    //     ss = 0;
    //     #2; sck = 1; si = 1;
    //     #1; sck = 0;
    //     #1; sck = 1; si = 1;
    //     #1; sck = 0;
    //     #1; sck = 1; si = 1;
    //     #1; sck = 0;
    //     #1; sck = 1; si = 1;
    //     #1; sck = 0;
    //     #1; sck = 1; si = 0;
    //     #1; sck = 0;
    //     #1; sck = 1; si = 0;
    //     #1; sck = 0;
    //     #1; sck = 1; si = 0;
    //     #1; sck = 0;
    //     #1; sck = 1; si = 0;
    //     #1; sck = 0;
    //     #2; ss = 1;

    //     ss = 0;
    //     #2; sck = 1; si = 1;
    //     #1; sck = 0;
    //     #1; sck = 1; si = 1;
    //     #1; sck = 0;
    //     #1; sck = 1; si = 1;
    //     #1; sck = 0;
    //     #1; sck = 1; si = 1;
    //     #1; sck = 0;
    //     #1; sck = 1; si = 1;
    //     #1; sck = 0;
    //     #1; sck = 1; si = 1;
    //     #1; sck = 0;
    //     #1; sck = 1; si = 1;
    //     #1; sck = 0;
    //     #1; sck = 1; si = 1;
    //     #1; sck = 0;
    //     #2; ss = 1;
    wrst_n = 1;
    rrst_n = 1;
    #10
    wrst_n = 0;
    rrst_n = 0; #4;
    wrst_n = 1;
    rrst_n = 1;
    wdata = 'h33;
    write_en = 1; #4;
    write_en = 0;
    wdata = 'h34;
    write_en = 1; #4;
    write_en = 0;
    read_en = 1; #6;
    read_en = 0;
    read_en = 1; #6;
    read_en = 0;

    #100;
    $display("End of simulation");
    $finish;
end

assign wclk = (write_en) ? clk : 0;
assign rclk = (read_en) ? bclk : 0;
assign winc = (clk & write_en) ? 1 : 0;
assign rinc = (bclk & read_en) ? 1 : 0;

endmodule
