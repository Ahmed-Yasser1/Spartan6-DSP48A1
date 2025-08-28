module DSP48A1_tb ();
parameter A0REG = 0, A1REG = 1, B0REG = 0, B1REG = 1;
parameter CREG = 1, DREG = 1, MREG = 1, PREG = 1, CARRYINREG = 1, CARRYOUTREG = 1, OPMODEREG = 1;
parameter CARRYINSEL = "OPMODE5";
parameter B_INPUT = "DIRECT";
parameter RSTTYPE = "SYNC";

reg [17 : 0] A, B, D, BCIN;
reg [47 : 0] C;
reg CARRYIN, CLK;
reg [7 : 0] OPMODE;
reg CEA, CEB, CEM, CEP, CEC, CED, CECARRYIN, CEOPMODE;
reg RSTA, RSTB, RSTM, RSTP, RSTC, RSTD, RSTCARRYIN, RSTOPMODE;
reg [47 : 0] PCIN;
wire [17 : 0] BCOUT;
wire [47 : 0] PCOUT, P;
wire [35 : 0] M;
wire CARRYOUT, CARRYOUTF;

MY_DSP48A1 # (.A0REG(A0REG), .A1REG(A1REG), .B0REG(B0REG), .B1REG(B1REG), .CREG(CREG), .DREG(DREG), .MREG(MREG), .PREG(PREG),
              .CARRYINREG(CARRYINREG), .CARRYOUTREG(CARRYOUTREG), .OPMODEREG(OPMODEREG), .B_INPUT(B_INPUT), .RSTTYPE(RSTTYPE)) dut (.*);

initial begin
  CLK =0;
  forever
#1 CLK = ~ CLK;
end


initial begin
               //////////////////////////////// reset check /////////////////////////////////////
  RSTA = 1'b1; RSTB = 1'b1; RSTM = 1'b1; RSTP = 1'b1; RSTC = 1'b1; RSTD = 1'b1; RSTCARRYIN = 1'b1; RSTOPMODE = 1'b1;
  CEA = 1'b1; CEB = 1'b1; CEM = 1'b1; CEP = 1'b1; CEC = 1'b1; CED = 1'b1; CECARRYIN = 1'b1; CEOPMODE = 1'b1;
  PCIN = 48'b1; BCIN = 18'b1; OPMODE = 8'b1; CARRYIN = 1'b1;
  A = 18'b1; B = 18'b1; D = 18'b1; C = 48'b1;
@ (negedge CLK)
  RSTA = 1'b0; RSTB = 1'b0; RSTM = 1'b0; RSTP = 1'b0; RSTC = 1'b0; RSTD = 1'b0; RSTCARRYIN = 1'b0; RSTOPMODE = 1'b0;
  if ((BCOUT !== 0) || (PCOUT !== 0) || (P !== 0) || (M !== 0) || (CARRYOUT !== 0) || (CARRYOUTF !== 0))
    begin
      $display ("Error - Incorrect output");
      $stop;
    end
               ////////////////////// opmode 8'b00000000 ////////////////////////////////
  OPMODE = 8'b00000000;
  A = 18'h5; B = 18'h7; D = 18'h9; C = 48'h11;
@ (negedge CLK);
  if ((PCOUT !== 0) || (P !== 0) || (M !== 0) || (CARRYOUT !== 0) || (CARRYOUTF !== 0) || (BCOUT !== B))
    begin
      $display ("Error - Incorrect output");
      $stop;
    end
             /////////////////////// opmode 8'b00000001 ////////////////////////////////
  OPMODE = 8'b00000001; 
repeat (3) @ (negedge CLK);
  if ((PCOUT !== (B * A)) || (P !== (B * A)) || (M !== (B * A)) || (CARRYOUT !== 0) || (CARRYOUTF !== 0) || (BCOUT !== B))
    begin
      $display ("Error - Incorrect output");
      $stop;
    end
             ///////////////////////  opmode 8'b00000010 ///////////////////////////////
  OPMODE = 8'b00000010;
  A = 18'h4; B = 18'h0; D = 18'h3; C = 48'h5;
repeat (3) @ (negedge CLK);
  if ((PCOUT !== P) || (P !== P) || (M !== (B * A)) || (CARRYOUT !== 0) || (CARRYOUTF !== 0) || (BCOUT !== B))
    begin
      $display ("Error - Incorrect output");
      $stop;
    end
             /////////////////////// opmode 8'b00000100 ////////////////////////////////
  OPMODE = 8'b00000100;
  A = 18'h8; B = 18'ha; D = 18'hF; C = 48'hAC; PCIN = 48'h13;
repeat (3) @ (negedge CLK);
  if ((PCOUT !== PCIN) || (P !== PCIN) || (M !== (B * A)) || (CARRYOUT !== 0) || (CARRYOUTF !== 0) || (BCOUT !== B))
    begin
      $display ("Error - Incorrect output");
      $stop;
    end
             /////////////////////// opmode 8'b00001000 /////////////////////////////////
  OPMODE = 8'b00001000;
  A = 18'hA; B = 18'hC1; D = 18'hAA; C = 48'hC;
repeat (3) @ (negedge CLK);
  if ((PCOUT !== P) || (P !== P) || (M !== (B * A)) || (CARRYOUT !== 0) || (CARRYOUTF !== 0) || (BCOUT !== B))
    begin
      $display ("Error - Incorrect output");
      $stop;
    end
             /////////////////////// opmode 8'b00010000 ////////////////////////////////
  OPMODE = 8'b00010000;
  A = 18'h32; B = 18'hB; D = 18'h10; C = 48'hE;
repeat (3) @ (negedge CLK);
  if ((PCOUT !== 0) || (P !== 0) || (M !== ((B + D) * A)) || (CARRYOUT !== 0) || (CARRYOUTF !== 0) || (BCOUT !== (B + D)))
    begin
      $display ("Error - Incorrect output");
      $stop;
    end
              ////////////////////// opmode 8'b00100000 ////////////////////////////////
  OPMODE = 8'b00100000;
  A = 18'h6; B = 18'h34; D = 18'h56; C = 48'h24;
repeat (3) @ (negedge CLK);
  if ((PCOUT !== 1) || (P !== 1) || (M !== (B * A)) || (CARRYOUT !== 0) || (CARRYOUTF !== 0) || (BCOUT !== B))
    begin
      $display ("Error - Incorrect output");
      $stop;
    end
              ///////////////////// opmode 8'b01000000 ////////////////////////////////
  OPMODE = 8'b01000000;
  A = 18'h55; B = 18'hB; D = 18'hC; C = 48'hB5;
repeat (3) @ (negedge CLK);
  if ((PCOUT !== 0) || (P !== 0) || (M !== (B * A)) || (CARRYOUT !== 0) || (CARRYOUTF !== 0) || (BCOUT !== B))
    begin
      $display ("Error - Incorrect output");
      $stop;
    end
             ////////////////////// opmode 8'b10000000 ////////////////////////////////
  OPMODE = 8'b10000000;
  A = 18'h41; B = 18'hAD; D = 18'hCB; C = 48'hAB;
repeat (3) @ (negedge CLK);
  if ((PCOUT !== 0) || (P !== 0) || (M !== (B * A)) || (CARRYOUT !== 0) || (CARRYOUTF !== 0) || (BCOUT !== B))
    begin
      $display ("Error - Incorrect output");
      $stop;
    end
             ///////////////////// opmode 8'b11110101 /////////////////////////////////
  OPMODE = 8'b11110101;
  A = 18'h1; B = 18'h1; D = 18'h1; C = 48'hC; PCIN = 48'hF;
repeat (4) @ (negedge CLK);
  if ((PCOUT !== (PCIN-(((D - B) * A) + OPMODE[5]))) || (P !== (PCIN-(((D - B) * A) + OPMODE[5]))) || (M !== ((D - B) * A)) || (CARRYOUT !== 0) || (CARRYOUTF !== 0) || (BCOUT !== (D - B)))
    begin
      $display ("Error - Incorrect output");
      $stop;
    end
$display ("All test cases passed successfully");
$stop;
end

initial begin
  $monitor ("%t :OPMODE = %0d , A = %0d , B = %0d , C = %0d , D = %0d , P = %0d , 
                 PCOUT = %0d , M = %0d , BCOUT = %0d , CARRYOUT = %0d , CARRYOUTF = %0d",
                  $time, OPMODE, A, B, C, D, P , PCOUT, M, BCOUT, CARRYOUT, CARRYOUTF);
end
endmodule 
