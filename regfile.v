module regfile (clk,readReg1,readReg2,writeReg,writeData,write,readData1,readData2);
    parameter DATAWIDTH = 32;
    integer i;

    input clk,write;
    input[4:0] readReg1,readReg2,writeReg;
    input[DATAWIDTH-1:0] writeData;
    output reg[DATAWIDTH-1:0] readData1,readData2;

    reg[DATAWIDTH-1:0] registers [31:0]; 

    initial begin
        for(i=0;i<32;i=i+1)begin
            registers[i] = {DATAWIDTH{1'b0}};
        end
    end
    
    always @(posedge clk)
        begin
            if(write && readReg1 == writeReg)begin
                registers[writeReg] <= writeData;
                readData1 <= writeData;
                readData2 <= registers[readReg2];
            end
            else if(write && readReg2 == writeReg)begin
                registers[writeReg] <= writeData;
                readData1 <= registers[readReg1];
                readData2 <= writeData;
            end
            else if(write)begin
                registers[writeReg] <= writeData;
                readData1 <= registers[readReg1];
                readData2 <= registers[readReg2];
            end
            else begin
                readData1 <= registers[readReg1];
                readData2 <= registers[readReg2];
            end
        end
endmodule