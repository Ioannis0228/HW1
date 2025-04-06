module INSTRUCTION_MEMORY(
 input clk,
 input [8:0] addr,
 output reg [31:0] dout
 );
reg [7:0] ROM [0:511];// ROM[511:0] this give warning

initial
begin
$readmemb("rom_bytes.data", ROM);
end

always @(posedge clk)
begin
dout <= {ROM[addr], ROM[addr + 1], ROM[addr + 2], ROM[addr + 3]};
end

endmodule
