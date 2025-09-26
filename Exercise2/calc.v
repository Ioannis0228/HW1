module calc(clk,btnc,btnl,btnu,btnr,btnd,sw,led);
    
    input   clk,  // clock
            btnc, // center button 
            btnl, // left button
            btnu, // upper button
            btnr, // right button
            btnd; // down button

    input[15:0] sw;  // switches for input
    output[15:0] led; // LED for output


    wire[31:0] extend_sw,   //sign extend for switches 
               alu_result,  // result from alu
               extend_acc,  //sign extend for accumulator
               alu_op1,     
               alu_op2;
    wire[3:0] alu_control;

    assign extend_sw = {{16{sw[15]}}, sw};
    assign alu_op1 = extend_acc;
    assign alu_op2 = extend_sw;

    calc_env U1 (.btnc(btnc),
                 .btnl(btnl),
                 .btnr(btnr),
                 .alu_op(alu_control)
                );

    alu alu_inst (.op1(alu_op1),
                  .op2(alu_op2), 
                  .alu_op(alu_control),
                  .zero(),
                  .result(alu_result));

    reg [15:0] accumulator;
    always @(posedge clk) 
        begin
            if (btnu)
                accumulator <= 16'h00;
            else if(btnd)
                accumulator <= alu_result[15:0];
        end
    
    assign extend_acc = { {16{accumulator[15]}}, accumulator};
    assign led = accumulator;

endmodule