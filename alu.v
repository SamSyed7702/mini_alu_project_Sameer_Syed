// alu.v - Simple parameterized ALU (8- or 16-bit)
// Verilog-2001 compatible

module alu #(parameter W = 8) (
  input  [W-1:0] a,
  input  [W-1:0] b,
  input  [3:0]   op,
  output reg [W-1:0] y,
  output reg z, n, c, v
);

  localparam integer SHW = (W==8)?3:(W==16)?4:5;
  wire [SHW-1:0] shamt = b[SHW-1:0];
  wire [W:0] sum  = {1'b0,a} + {1'b0,b};
  wire [W:0] diff = {1'b0,a} + {1'b0,~b} + 1'b1;

  always @* begin
    y = 0; c = 0; v = 0;
    case(op)
      4'h0: begin y = sum[W-1:0]; c = sum[W]; v = (a[W-1]==b[W-1]) && (y[W-1]!=a[W-1]); end
      4'h1: begin y = diff[W-1:0]; c = diff[W]; v = (a[W-1]!=b[W-1]) && (y[W-1]!=a[W-1]); end
      4'h2: y = a & b;
      4'h3: y = a | b;
      4'h4: y = a ^ b;
      4'h5: y = ~a;
      4'h6: y = a << shamt;
      4'h7: y = a >> shamt;
      4'h8: y = $signed(a) >>> shamt;
      4'h9: y = ($signed(a)<$signed(b)) ? {{(W-1){1'b0}},1'b1}:{W{1'b0}};
      4'hA: y = a;
      4'hB: y = b;
      default: y = {W{1'b0}};
    endcase
    z = (y=={W{1'b0}}); n = y[W-1];
  end
endmodule
