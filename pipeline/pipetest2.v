module pipetest2;
reg [3:0] rs1 , rs2 , rd , func;
reg [7:0] addr;
reg clk1 , clk2;
wire [15:0] f;
integer k;
pipe2 u1(.rs1(rs1) , .rs2(rs2) , .rd(rd) , .func(func) , .addr(addr) , .clk1(clk1) , .clk2(clk2) , .f(f));
integer i;
initial begin
    clk1 = 0; clk2 = 0;
    forever begin
        #5 clk1 = ~clk1;
        #5 clk2 = ~clk2;
    end
end
initial begin
    for(i = 0 ; i < 16 ; i++)
    u1.regbank[i] = i;
end
initial begin
    #5  rs1 = 3;  rs2 = 5;  rd = 10; func = 0;  addr = 125;  // ADD
    #20 rs1 = 3;  rs2 = 8;  rd = 12; func = 2;  addr = 126;  // MUL
    #20 rs1 = 10; rs2 = 5;  rd = 14; func = 1;  addr = 127;  // SUB
    #20 rs1 = 7;  rs2 = 3;  rd = 13; func = 11; addr = 128;  // SLA
    #20 rs1 = 10; rs2 = 5;  rd = 15; func = 1;  addr = 129;  // SUB
    #20 rs1 = 12; rs2 = 13; rd = 16; func = 0;  addr = 130;  // ADD

    #60 for(i = 125 ; i <=130 ; i++)
    $display("mem[%3d] = %3d" , $time, u1.mem[i]);
end
initial begin
    $dumpfile("gtkwave.vcd");
    $dumpvars(0 , pipetest2);
    $monitor("time = %3d ,output = %3d" , $time , f);
    #300 $finish;
end
endmodule










