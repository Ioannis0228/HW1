module datapath (clk,rst,instr,PCSrc,ALUSrc,RegWrite,MemToReg,ALUCtrl,
                loadPC,PC,Zero,dAddress,dWriteData,dReadData,WriteBackData);

    parameter INITIAL_PC = 32'h00400000;
    parameter instr_Rtype = 7'b0110011,
              instr_Itype = 7'b0010011,
              instr_Stype = 7'b0100011,
              instr_Btype = 7'b1100011;
    input clk,rst,PCSrc,ALUSrc,RegWrite,MemToReg,loadPC;
    input[31:0] instr,dReadData;
    input[3:0] ALUCtrl;

    output Zero;
    output[31:0] dAddress,dWriteData,WriteBackData;
    output reg[31:0] PC;

    wire[4:0] rs1,rs2,rd;
    //wire[2:0] funct3;
    //wire[6:0] funct7;
    wire[6:0] opcode;
    wire[31:0] read_data1,read_data2,ext_imm,alu_result,op2_alu;
    
    wire[11:0] branch_offset,imm;

    always@(posedge clk)begin
        if(rst)
            PC <= INITIAL_PC; 
        else if(loadPC && PCSrc)
            PC <= PC + branch_offset /*+4*/; 
        else if(loadPC)
            PC <= PC + 4;
    end

    assign opcode = instr[6:0];
    assign rd = instr[11:7];
    //assign funct3 = instr[14:12];
    assign rs1 = instr[19:15];
    assign rs2 = instr[24:20];
    //assign funct7 = instr[31:25];
    
    assign imm = (opcode == instr_Stype) ? {instr[31:25],instr[11:7]} :
                 (opcode == instr_Itype || opcode == 7'b0000011) ? instr[31:20] :
                 (opcode == instr_Btype) ? {instr[31],instr[7],instr[30:25],instr[11:8]}:
                 12'bx;
    
    assign ext_imm = {{20{imm[11]}}, imm};
    assign branch_offset = ext_imm << 1;

    regfile regfile(.clk(clk),
               .readReg1(rs1),
               .readReg2(rs2),
               .writeReg(rd),
               .writeData(WriteBackData),
               .write(RegWrite),
               .readData1(read_data1),
               .readData2(read_data2));

    assign op2_alu = (ALUSrc == 0) ? read_data2 :
                     (ALUSrc == 1) ? ext_imm :
                     32'bx;

    alu alu(.op1(read_data1),
           .op2(op2_alu),
           .alu_op(ALUCtrl),
           .zero(Zero),
           .result(alu_result));

    assign dAddress = alu_result;
    assign dWriteData = read_data2;

    assign WriteBackData = (MemToReg == 0) ? alu_result :
                           (MemToReg == 1) ? dReadData :
                           32'bx;


endmodule