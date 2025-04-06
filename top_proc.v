module top_proc(clk,rst,instr,dReadData,PC,dAddress,dWriteData,MemRead,MemWrite,WriteBackData);
    parameter INITIAL_PC = 32'h00400000;

    parameter IF = 3'b000,
              ID = 3'b001,
              EX = 3'b010,
              MEM = 3'b100,
              WB = 3'b101;
    reg[2:0] current_state,next_state; 

    input clk,rst;
    input[31:0] instr,dReadData;

    output MemRead,MemWrite;
    output[31:0] PC,dAddress,dWriteData,WriteBackData;

    reg loadPC,RegWrite,MemToReg,MemRead,MemWrite,PCSrc;
    wire[3:0] ALUCtrl;
    wire ALUSrc;

    wire[4:0] rs1,rs2,rd;
    wire[2:0] funct3;
    wire[6:0] funct7;
    wire[6:0] opcode;
    wire zero;

    always@(posedge clk) 
        begin : STATE_MEMORY
            if(rst)
                current_state <= IF;
            else
                current_state <= next_state;
        end

    always@(current_state)
        begin : NEXT_STATE_LOGIC
            case (current_state)
                IF : next_state = ID;
                ID : next_state = EX;
                EX : next_state = MEM;
                MEM : next_state = WB;
                WB : next_state = IF; 
            endcase
        end

    always @(current_state) 
        begin : OUTPUT_LOGIC
            case (current_state)
                IF :begin
                        loadPC = 0;
                        RegWrite = 0;
                        MemToReg = 0;
                        PCSrc = 0;
                    end
                ID :begin
                    
                    end 
                EX :begin
                    
                    end 
                MEM :begin
                        if(opcode == 7'b0000011)
                            MemRead = 1;
                        else if(opcode == 7'b0100011)
                            MemWrite = 1;
                        PCSrc =  (opcode == 7'b1100011 && funct3 == 3'b000 && zero == 1'b1) ? 1'b1:
                                  1'b0;

                     end 
                WB :begin 
                        MemRead = 0;
                        MemWrite = 0;
                        loadPC = 1;
                        if(!(opcode == 7'b0100011 && funct3 == 3'b010)&&
                           !(opcode == 7'b1100011 && funct3 == 3'b000))
                                RegWrite = 1;
                        if(opcode == 7'b0000011 && funct3 == 3'b010)
                            MemToReg = 1;
                    end
            endcase
        end

    assign opcode = instr[6:0];
    assign rd = instr[11:7];
    assign funct3 = instr[14:12];
    assign rs1 = instr[19:15];
    assign rs2 = instr[24:20];
    assign funct7 = instr[31:25];

    assign ALUCtrl = (funct3 == 3'b111 && 
                     (opcode == 7'b0010011 || (opcode == 7'b0110011 && funct7 == 7'b0000000))) ? 4'b0000: // ANDI and AND
                     (funct3 == 3'b110 &&
                     (opcode == 7'b0010011 || (opcode == 7'b0110011 && funct7 == 7'b0000000))) ? 4'b0001: // ORI and OR
                     (funct3 == 3'b000 &&  
                     (opcode == 7'b0010011 || (opcode == 7'b0110011 && funct7 == 7'b0000000))) ? 4'b0010: // ADDI and ADD 
                     (funct3 == 3'b000 &&
                     (opcode == 7'b1100011 || (opcode == 7'b0110011 && funct7 == 7'b0100000))) ? 4'b0110: // BEQ and SUB
                     (funct3 == 3'b010 &&
                     (opcode == 7'b0010011 || (opcode == 7'b0110011 && funct7 == 7'b0000000))) ? 4'b0100: // SLTI and SLT
                     (funct3 == 3'b101 && funct7 == 7'b0000000 &&
                     (opcode == 7'b0010011 || opcode == 7'b0110011)) ? 4'b1000: // SRLI and SRL
                     (funct3 == 3'b001 && funct7 == 7'b0000000 &&
                     (opcode == 7'b0010011 || opcode == 7'b0110011)) ? 4'b1001: // SLLI and SLL
                     (funct3 == 3'b101 && funct7 == 7'b0100000 &&
                     (opcode == 7'b0010011 || opcode == 7'b0110011)) ? 4'b1010: // SRAI and SRA
                     (funct3 == 3'b100  &&
                     (opcode == 7'b0010011 || (opcode == 7'b0110011 && funct7 == 7'b0000000))) ? 4'b0101: // XORI and XOR
                     (funct3 == 3'b010 &&
                     (opcode == 7'b0000011 || opcode == 7'b0100011)) ? 4'b0010: // LW and SW
                     4'bx;

    assign ALUSrc = (opcode == 7'b0000011 ||
                     opcode == 7'b0100011 ||
                     opcode == 7'b0010011) ? 1'b1:
                    1'b0;

    datapath #(INITIAL_PC) datapath (
                .clk(clk),
                .rst(rst),
                .instr(instr),
                .PCSrc(PCSrc),
                .ALUSrc(ALUSrc),
                .RegWrite(RegWrite),
                .MemToReg(MemToReg),
                .ALUCtrl(ALUCtrl),
                .loadPC(loadPC),
                .PC(PC),
                .Zero(zero),
                .dAddress(dAddress),
                .dReadData(dReadData),
                .dWriteData(dWriteData),
                .WriteBackData(WriteBackData));
    
endmodule