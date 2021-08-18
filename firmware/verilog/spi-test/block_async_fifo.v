module block_async_fifo (input [7:0] w_data, output [7:0] r_data, input w_clk,
                         input r_clk, output r_fail
                        );

reg [4:0] r_ptr;
reg [4:0] w_ptr;
reg [7:0] r_data;
reg [31:0] fifo;
reg r_fail;

initial begin
    r_ptr = 0;
    w_ptr = 0;
    fifo = 0;
    r_fail = 0;
end

always @(posedge w_clk) begin
    fifo[w_ptr+0] <= w_data[0];
    fifo[w_ptr+1] <= w_data[1];
    fifo[w_ptr+2] <= w_data[2];
    fifo[w_ptr+3] <= w_data[3];
    fifo[w_ptr+4] <= w_data[4];
    fifo[w_ptr+5] <= w_data[5];
    fifo[w_ptr+6] <= w_data[6];
    fifo[w_ptr+7] <= w_data[7];
    w_ptr = w_ptr + 'd8;
    // TODO : Add a write fail to prevent FIFO overflow
end

always @(posedge r_clk) begin
    // read and write pointer != then send out data, else assert write_fail
    if (r_ptr != w_ptr) begin
        r_data[0] <= fifo[r_ptr+0];
        r_data[1] <= fifo[r_ptr+1];
        r_data[2] <= fifo[r_ptr+2];
        r_data[3] <= fifo[r_ptr+3];
        r_data[4] <= fifo[r_ptr+4];
        r_data[5] <= fifo[r_ptr+5];
        r_data[6] <= fifo[r_ptr+6];
        r_data[7] <= fifo[r_ptr+7];
        r_fail <= 0;
        r_ptr = r_ptr + 'd8;
    end
    else r_fail <= 1;
end
endmodule
