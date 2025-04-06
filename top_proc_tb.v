`timescale 1ns/1ps
`include "regfile.v"
`include "alu.v"
`include "datapath.v"
`include "rom.v"
`include "ram.v"
`include "top_proc.v"

module top_proc_tb;

reg clk,rst;//,MemRead,MemWrite;
//reg[31:0] ;
wire[31:0] instr,PC,dReadData,dAddress,dWriteData,WriteBackData;
wire MemRead,MemWrite;

INSTRUCTION_MEMORY U1(.clk(clk),
                      .addr(PC[8:0]),
                      .dout(instr));

top_proc U2(.clk(clk),
            .rst(rst),
            .instr(instr),
            .dReadData(dReadData),
            .PC(PC),
            .dAddress(dAddress),
            .dWriteData(dWriteData),
            .MemRead(MemRead),
            .MemWrite(MemWrite),
            .WriteBackData(WriteBackData));

DATA_MEMORY U3(.clk(clk),
               .we(MemWrite),
               .addr(dAddress[8:0]),
               .din(dWriteData),
               .dout(dReadData));


initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

integer i;

initial begin
        
        $dumpfile("top_proc_tb.vcd");
        $dumpvars(0, top_proc_tb,U3.RAM[4]);
        for(i=0;i<=20;i=i+1)
            $dumpvars(0,U2.datapath.regfile.registers [i]);
        #1 rst = 1;
        #9 rst = 0;
        #1270 // 24 instructions in rom * 5 cycles of clock * 10 time units of 1 clock cycle
        $finish;

    end

endmodule