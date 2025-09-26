module alu(op1,op2,alu_op,zero,result);
    parameter [3:0]ALUOP_AND        = 4'b0000, // logical and
                   ALUOP_OR         = 4'b0001, // logical or
                   ALUOP_ADD        = 4'b0010, // addition
                   ALUOP_SUB        = 4'b0110, // subtraction
                   ALUOP_LESS       = 4'b0100, // less than
                   ALUOP_SHIFTR     = 4'b1000, // logical right shift
                   ALUOP_SHIFTL     = 4'b1001, // logical left shift
                   ALUOP_AR_SHIFTR  = 4'b1010, // arithmetic rigth shift
                   ALUOP_XOR        = 4'b0101; // logical xor

    output zero;
    output reg[31:0]result;
    input [31:0] op1,op2;
    input [3:0]alu_op;

    always @(*) begin
        case (alu_op)
            ALUOP_AND:      result = op1 & op2;
            ALUOP_OR:       result = op1 | op2;
            ALUOP_ADD:      result = op1 + op2;
            ALUOP_SUB:      result = op1 - op2;
            ALUOP_LESS:     result = ($signed(op1) < $signed(op2)) ? 32'b1 : 32'b0;
            ALUOP_SHIFTR:   result = op1 >> op2[4:0];
            ALUOP_SHIFTL:   result = op1 << op2[4:0];
            ALUOP_AR_SHIFTR: result = $signed(op1) >>> op2[4:0];
            ALUOP_XOR:      result = op1 ^ op2;
            default:        result = 32'b0;
        endcase
    end    

    assign zero = (result == 0) ? 1'b1 : 1'b0;

endmodule