module block_spi_slave(input wire clk, input wire reset, input wire SPI_SCK,
                       input wire SPI_SS, input wire SPI_MOSI, output SPI_MISO,
                       output [7:0] o_data
                      );

reg r_w;
reg [3:0] bit_counter;
reg [7:0] recv_buf;
reg [7:0] send_buf;
reg trans_queued;
reg LED;
reg SPI_MISO;
reg [7:0] old_recv;

initial begin
    bit_counter = 0;
    r_w  = 0;
    // trans_queued = 0;
    LED = 0;
    recv_buf = 0;
    send_buf = 'h3;
    SPI_MISO = 0;
end

// SPI_MODE_1 -> Data sampled on falling edge and shifted out on the rising edge by master
always @(posedge SPI_SCK) begin
    // SO
    if (SPI_SS == 0 && !r_w) begin
        SPI_MISO <= send_buf[bit_counter];
    end
end

always @(negedge SPI_SCK) begin
    // SI
    if (SPI_SS == 0 && !r_w) begin
        recv_buf[bit_counter] <= SPI_MOSI;
        if (bit_counter == 'd7) begin
            bit_counter <= 0;
            // send_buf <= recv_buf;
        end
        else bit_counter <= bit_counter + 1;
    end
end

always @(posedge clk) begin
    if (trans_queued==1) begin
        if (recv_buf[0] == 1 || recv_buf[7] == 1) LED <= 1;
        else LED <= 0;
        trans_queued <= 0;
    end
end

endmodule
