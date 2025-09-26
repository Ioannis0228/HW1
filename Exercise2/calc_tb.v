`timescale 1ns/1ps
`include "alu.v"
`include "calc.v"
`include "calc_ev.v"

module calc_tb;
    reg[15:0] sw;
    reg clk;
    reg btnl,btnc,btnr,btnu,btnd;
    wire[15:0] result;

    // Instantiate the calc module
    calc uut(
        .clk(clk),
        .btnc(btnc),
        .btnl(btnl),
        .btnu(btnu),
        .btnr(btnr),
        .btnd(btnd),
        .sw(sw),
        .led(result)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    // testbench logic
    initial begin
        $dumpfile("calc_tb.vcd");
        $dumpvars(0, calc_tb);
        #1 btnu = 1;
        #9 btnu = 0;btnl = 0; btnc = 0; btnr = 0; btnd = 0;
        #10 sw = 16'h354a; btnc = 1; btnd = 0;
        #10 btnd = 1;
        #10 sw = 16'h1234; btnr = 1; btnd = 0;
        #10 btnd = 1;
        #10 btnc = 0; sw = 16'h1001; btnd = 0;
        #10 btnd = 1;
        #10 btnr = 0; sw = 16'hf0f0; btnd = 0;
        #10 btnd = 1;
        #10 btnl = 1; btnc = 1; btnr = 1; sw = 16'h1fa2; btnd = 0;
        #10 btnd = 1;
        #10 btnl = 0; btnr = 0; sw = 16'h6aa2; btnd = 0;
        #10 btnd = 1;
        #10 btnl = 1; btnc = 0; btnr = 1; sw = 16'h0004; btnd = 0; 
        #10 btnd = 1;
        #10 btnc = 1; btnr = 0; sw = 16'h0001; btnd = 0;
        #10 btnd = 1;
        #10 btnc = 0; sw = 16'h46ff; btnd = 0; 
        #10 btnd = 1;
        #20
        $finish;
    end
    
    
endmodule