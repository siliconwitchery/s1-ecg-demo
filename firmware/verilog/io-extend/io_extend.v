`timescale 1ns / 1ps
`include "block_clock.v"
`include "block_spi_slave.v"
`include "block_pwm.v"

`define SIM 1

module top(input wire SI,
           output wire SO,
           input wire SCK,
           input wire SS,
           output wire D5,
           output wire D6,
           output wire D8,
           output wire D7,
           output wire D1,
           output wire D4,
           output wire D3,
           output wire D2
          );

io_extend io_extend(.SI(SI), .SO(SO), .SCK(SCK), .SS(SS), .D1(D1),
                    .D2(D2), .D3(D3), .D4(D4), .D5(D5), .D6(D6), .D7(D7));

endmodule

    module io_extend(input SI,
                     output SO,
                     input SCK,
                     input SS,
                     output D5,
                     output D6,
                     output D8,
                     output D7,
                     output D1,
                     output D4,
                     output D3,
                     output D2,
                     input sim_clk
                    );

wire clk, SI, SO, SCK, SS;
wire D1, D2, D3, D4, D5, D6, D7;
wire D1_o, D2_o, D3_o, D4_o, D5_o, D6_o, D7_o;
wire D1_i, D2_i, D3_i, D4_i, D5_i, D6_i, D7_i;
wire D1_pwm, D2_pwm, D3_pwm, D4_pwm, D5_pwm, D6_pwm, D7_pwm;
wire D1_oe, D2_oe, D3_oe, D4_oe, D5_oe, D6_oe, D7_oe;

reg [7:0] duty_cycle1 = 0;
reg [7:0] duty_cycle2 = 0;
reg [7:0] duty_cycle3 = 0;
reg [7:0] duty_cycle4 = 0;
reg [7:0] duty_cycle5 = 0;
reg [7:0] duty_cycle6 = 0;
reg [7:0] duty_cycle7 = 0;

wire [7:0] data_out;
reg [7:0] data_in = 0;
wire [7:0] address;
wire data_ready;
wire address_ready;

reg [7:0] pwm_ctrl_reg = 0;
reg [7:0] d_in_ctrl_reg = 0;
wire [7:0] d_in_data_reg = 0;
reg [7:0] d_out_ctrl_reg = 0;
reg [7:0] d_out_data_reg = 0;

`ifdef SIM
assign clk = sim_clk;
`else
block_clock clock(.clk(clk));
`endif

// SPI block
block_spi_slave spi_slave(.clk(clk), .SPI_SCK(SCK), .SPI_CS(SS), .SPI_MOSI(SI),
                          .SPI_MISO(SO), .data_out(data_out), .data_in(data_in),
                          .address_out(address), .data_ready(data_ready),
                          .address_ready(address_ready));

// PWM blocks
block_pwm pwm1(.clk(clk), .duty_cycle(duty_cycle1), .pwm_out(D1_pwm));
block_pwm pwm2(.clk(clk), .duty_cycle(duty_cycle2), .pwm_out(D2_pwm));
block_pwm pwm3(.clk(clk), .duty_cycle(duty_cycle3), .pwm_out(D3_pwm));
block_pwm pwm4(.clk(clk), .duty_cycle(duty_cycle4), .pwm_out(D4_pwm));
block_pwm pwm5(.clk(clk), .duty_cycle(duty_cycle5), .pwm_out(D5_pwm));
block_pwm pwm6(.clk(clk), .duty_cycle(duty_cycle6), .pwm_out(D6_pwm));
block_pwm pwm7(.clk(clk), .duty_cycle(duty_cycle7), .pwm_out(D7_pwm));

always @(posedge clk) begin
    if (data_ready) begin
        case (address)
            'h00 : pwm_ctrl_reg <= data_out;
            'h01 : duty_cycle1 <= data_out;
            'h02 : duty_cycle2 <= data_out;
            'h03 : duty_cycle3 <= data_out;
            'h04 : duty_cycle4 <= data_out;
            'h05 : duty_cycle5 <= data_out;
            'h06 : duty_cycle6 <= data_out;
            'h07 : duty_cycle7 <= data_out;
            'h10 : d_out_ctrl_reg <= data_out;
            'h11 : d_out_data_reg <= data_out;
            'h20 : d_in_ctrl_reg <= data_out;
        endcase
    end
    if (address_ready && address == 'h21) begin
        data_in <= d_in_data_reg;
    end
end

// Tristate blocks for pins
SB_IO #(
          .PIN_TYPE(6'b1010_01), .PULLUP(1'b0)
      ) triState1 (
          .PACKAGE_PIN(D1), .OUTPUT_ENABLE(D1_oe), .D_OUT_0(D1_i), .D_IN_0(D1_o)
      );
SB_IO #(
          .PIN_TYPE(6'b1010_01), .PULLUP(1'b0)
      ) triState2 (
          .PACKAGE_PIN(D2), .OUTPUT_ENABLE(D2_oe), .D_OUT_0(D2_i), .D_IN_0(D2_o)
      );
SB_IO #(
          .PIN_TYPE(6'b1010_01), .PULLUP(1'b0)
      ) triState3 (
          .PACKAGE_PIN(D3), .OUTPUT_ENABLE(D3_oe), .D_OUT_0(D3_i), .D_IN_0(D3_o)
      );
SB_IO #(
          .PIN_TYPE(6'b1010_01), .PULLUP(1'b0)
      ) triState4 (
          .PACKAGE_PIN(D4), .OUTPUT_ENABLE(D4_oe), .D_OUT_0(D4_i), .D_IN_0(D4_o)
      );
SB_IO #(
          .PIN_TYPE(6'b1010_01), .PULLUP(1'b0)
      ) triState5 (
          .PACKAGE_PIN(D5), .OUTPUT_ENABLE(D5_oe), .D_OUT_0(D5_i), .D_IN_0(D5_o)
      );
SB_IO #(
          .PIN_TYPE(6'b1010_01), .PULLUP(1'b0)
      ) triState6 (
          .PACKAGE_PIN(D6), .OUTPUT_ENABLE(D6_oe), .D_OUT_0(D6_i), .D_IN_0(D6_o)
      );
SB_IO #(
          .PIN_TYPE(6'b1010_01), .PULLUP(1'b0)
      ) triState7 (
          .PACKAGE_PIN(D7), .OUTPUT_ENABLE(D7_oe), .D_OUT_0(D7_i), .D_IN_0(D7_o)
      );

assign D1_o = (D1_pwm & pwm_ctrl_reg[0]) ^ (d_out_data_reg[0] & d_out_ctrl_reg[0]);
assign D2_o = (D2_pwm & pwm_ctrl_reg[1]) ^ (d_out_data_reg[1] & d_out_ctrl_reg[1]);
assign D3_o = (D3_pwm & pwm_ctrl_reg[2]) ^ (d_out_data_reg[2] & d_out_ctrl_reg[2]);
assign D4_o = (D4_pwm & pwm_ctrl_reg[3]) ^ (d_out_data_reg[3] & d_out_ctrl_reg[3]);
assign D5_o = (D5_pwm & pwm_ctrl_reg[4]) ^ (d_out_data_reg[4] & d_out_ctrl_reg[4]);
assign D6_o = (D6_pwm & pwm_ctrl_reg[5]) ^ (d_out_data_reg[5] & d_out_ctrl_reg[5]);
assign D7_o = (D7_pwm & pwm_ctrl_reg[6]) ^ (d_out_data_reg[6] & d_out_ctrl_reg[6]);

assign d_in_data_reg = {1'b0, D7_i, D6_i, D5_i, D4_i, D3_i, D2_i, D1_i};

assign D1_oe = pwm_ctrl_reg[0] ^ d_out_ctrl_reg[0];
assign D2_oe = pwm_ctrl_reg[1] ^ d_out_ctrl_reg[1];
assign D3_oe = pwm_ctrl_reg[2] ^ d_out_ctrl_reg[2];
assign D4_oe = pwm_ctrl_reg[3] ^ d_out_ctrl_reg[3];
assign D5_oe = pwm_ctrl_reg[4] ^ d_out_ctrl_reg[4];
assign D6_oe = pwm_ctrl_reg[5] ^ d_out_ctrl_reg[5];
assign D7_oe = pwm_ctrl_reg[6] ^ d_out_ctrl_reg[6];

endmodule
