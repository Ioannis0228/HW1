module calc_env(btnc,btnl,btnr,alu_op);
    input btnc,
          btnl,
          btnr;
    output[3:0] alu_op;

    wire not_btnc,not_btnr,not_btnl,n1,n2,n3,n4,n5,n6,n7,n8,n9,n10;

    not(not_btnc, btnc);
    not(not_btnr,btnr);
    not(not_btnl,btnl);

   
    and(n1,not_btnc,btnr); // n1 = !btnc && btnr 
    and(n2,btnr,btnl);    // n2 = btnr && btnl
    or(alu_op[0],n1,n2);  // alu_op[0] = n1 || n2

    and(n3,not_btnl,btnc);  // n3 = !btnl && btnc
    and(n4,not_btnr,btnc);  // n4 = !btnr && btnc
    or(alu_op[1],n3,n4);    // alu_op[1] = n3 || n4


    and(n5,btnc,btnr);      // n5 = btnc && btnr
    and(n6,not_btnc,btnl);  // n6 = !btnc && btnl
    and(n7,n6,not_btnr);    // n7 = n6 && !btnr
    or(alu_op[2],n5,n7);    // alu_op[2] = n5 || n7

    
    and(n8,btnl,btnc);      // n8 = btnc && btnl
    and(n9,n6,btnr);        // n9 = n6 && btnr
    and(n10,not_btnr,n8);   // n10 = !btnr && n8
    or(alu_op[3],n9,n10);   // alu_op[3] = n9 || n10
    

endmodule