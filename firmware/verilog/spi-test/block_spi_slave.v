module block_spi_slave(input wire clk, input wire reset, input wire SPI_SCK,
                       input wire SPI_CS, input wire SPI_MOSI, output SPI_MISO,
                       output [7:0] address_out, output [7:0] data_out, output data_ready
                      );

// sync to FPGA clock using a 3-bit shift register
reg [2:0] SCKreg;
reg [2:0] CSreg;
reg [1:0] MOSIreg;

wire SCK_rising = (SCKreg[2:1]==2'b01);  // rising edges
wire SCK_falling = (SCKreg[2:1]==2'b10);  // falling edges
wire CS_active = CSreg[1];  // CS is active high
wire MOSI_data = MOSIreg[1];

reg [3:0] bit_counter;

reg data_ready;  // high when a byte has been received
reg [15:0] data_received = 0;
reg [7:0] address_out = 0;
reg [7:0] data_out = 0;

always @(posedge clk) begin
    SCKreg <= {SCKreg[1:0], SPI_SCK};
    CSreg <= {CSreg[1:0], SPI_CS};
    MOSIreg <= {MOSIreg[0], SPI_MOSI};

    if(!CS_active) begin
        bit_counter <= 0;
        data_out <= data_received[7:0];
        address_out <= data_received[15:8];
        data_ready <= 1;
    end
    else begin
        data_ready <= 0;
        if(SCK_rising)  begin
            bit_counter <= bit_counter + 1;
            data_received <= {data_received[14:0], MOSI_data};
        end
    end
end

endmodule
