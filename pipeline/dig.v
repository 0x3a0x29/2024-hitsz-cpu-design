`timescale 1ns / 1ps

module dig(
    input wire        rst,
    input wire        clk,
    input wire [31:0] addr,
    input wire        we,
    input wire [31:0] wdata,
    
    output reg [ 7:0]  dig_en,
    output reg         DN_A,
    output reg         DN_B,
    output reg         DN_C,
    output reg         DN_D,
    output reg         DN_E,
    output reg         DN_F,
    output reg         DN_G,
    output reg         DN_DP
);

    reg  [3:0]  number;
    reg  [17:0] cnt;
    reg  [31:0] dig_data;
    wire        next;
    
    always @(posedge clk or posedge rst) begin
        if(rst) dig_data <= 32'd0;
        else if(~we) dig_data <= dig_data;
        else dig_data <= wdata;
    end
    
    assign next = ( cnt == 18'd49999 );
    
    always @(posedge clk or posedge rst) begin
        if(rst) cnt <= 18'd0;
        else if(next) cnt <= 18'd0;
        else cnt <= cnt + 18'd1;
    end

    always @(posedge clk or posedge rst) begin
        if(rst) dig_en <= 8'b11111110;
        else if(next) dig_en <= {dig_en[6:0],dig_en[7]};
        else dig_en <= dig_en;
    end

    always@(*) begin
        case(1'b0)
        dig_en[0]: number = dig_data[3 :0 ];
        dig_en[1]: number = dig_data[7 :4 ];
        dig_en[2]: number = dig_data[11:8 ];
        dig_en[3]: number = dig_data[15:12];
        dig_en[4]: number = dig_data[19:16];
        dig_en[5]: number = dig_data[23:20];
        dig_en[6]: number = dig_data[27:24];
        default:   number = dig_data[31:28];
        endcase
    end

    always@(*) begin
        case(number)
        4'h0:    { DN_A , DN_B , DN_C, DN_D , DN_E , DN_F , DN_G , DN_DP } = 8'b00000011;
        4'h1:    { DN_A , DN_B , DN_C, DN_D , DN_E , DN_F , DN_G , DN_DP } = 8'b10011111;
        4'h2:    { DN_A , DN_B , DN_C, DN_D , DN_E , DN_F , DN_G , DN_DP } = 8'b00100101;
        4'h3:    { DN_A , DN_B , DN_C, DN_D , DN_E , DN_F , DN_G , DN_DP } = 8'b00001101;
        4'h4:    { DN_A , DN_B , DN_C, DN_D , DN_E , DN_F , DN_G , DN_DP } = 8'b10011001;
        4'h5:    { DN_A , DN_B , DN_C, DN_D , DN_E , DN_F , DN_G , DN_DP } = 8'b01001001;
        4'h6:    { DN_A , DN_B , DN_C, DN_D , DN_E , DN_F , DN_G , DN_DP } = 8'b01000001;
        4'h7:    { DN_A , DN_B , DN_C, DN_D , DN_E , DN_F , DN_G , DN_DP } = 8'b00011111;
        4'h8:    { DN_A , DN_B , DN_C, DN_D , DN_E , DN_F , DN_G , DN_DP } = 8'b00000001;
        4'h9:    { DN_A , DN_B , DN_C, DN_D , DN_E , DN_F , DN_G , DN_DP } = 8'b00011001;
        4'ha:    { DN_A , DN_B , DN_C, DN_D , DN_E , DN_F , DN_G , DN_DP } = 8'b00010001;
        4'hb:    { DN_A , DN_B , DN_C, DN_D , DN_E , DN_F , DN_G , DN_DP } = 8'b11000001;
        4'hc:    { DN_A , DN_B , DN_C, DN_D , DN_E , DN_F , DN_G , DN_DP } = 8'b11100101;
        4'hd:    { DN_A , DN_B , DN_C, DN_D , DN_E , DN_F , DN_G , DN_DP } = 8'b10000101;
        4'he:    { DN_A , DN_B , DN_C, DN_D , DN_E , DN_F , DN_G , DN_DP } = 8'b01100001;
        default: { DN_A , DN_B , DN_C, DN_D , DN_E , DN_F , DN_G , DN_DP } = 8'b01110001;
        endcase
    end

endmodule
