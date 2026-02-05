module pipe2 (
    rs1 , rs2 , rd , func, addr,
    clk1 , clk2,
     f
);
 input [3:0] rs1 , rs2 , rd , func;
    input [7:0] addr;
    input clk1 , clk2;
    output [15:0] f;
reg[15:0] l12_a , l12_b  , l23_z , l34_z;
reg[3:0] l12_rd , l23_rd, l12_func;
reg[7:0] l23_addr , l12_addr, l34_addr;
reg [15:0] regbank[0:15];
reg[15:0] mem[0:255];
 assign f = l34_z; 
always @(posedge clk1) begin
    l12_a <= regbank[rs1];
    l12_b <= regbank[rs2];
    l12_rd <= rd;
    l12_func <= func;
    l12_addr <= addr;               ///////////////// stage 1 ////////////////////////
end
always @(negedge clk2) begin
    case(func)
    0: l23_z <= l12_a + l12_b;
    1: l23_z <= l12_a - l12_b;
    2: l23_z <= l12_a * l12_b;
    3: l23_z <= l12_a;
    4: l23_z <= l12_b;
    5: l23_z <= l12_a & l12_b;
    6: l23_z <= l12_a | l12_b;
    7: l23_z <= l12_a ^ l12_b;
    8: l23_z <= ~l12_a;
    9: l23_z <= ~l12_b;
   10: l23_z <= l12_a>>1;
   11: l23_z <= l12_b>>1;
   default : l23_z <= 16'hxxxx;
    endcase
    l23_addr  <= l12_addr;
    l23_rd <= l12_rd;
end
                                     //////////////////////
always @(posedge clk1) begin
    regbank[l12_rd] <= l23_z;
    l34_z <= l23_z;
    l34_addr <= addr;
end
                                     //////////////////////
always @(negedge clk2) begin
   mem[l34_addr] <= l34_z; 
end
 
                                  

endmodule