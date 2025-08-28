vlib work
vlog model.v DSP48A1_tb.v
vsim -voptargs=+acc work.DSP48A1_tb
add wave *
add wave -position insertpoint  \
sim:/DSP48A1_tb/dut/D_OUT \
sim:/DSP48A1_tb/dut/B_OUT \
sim:/DSP48A1_tb/dut/A_OUT \
sim:/DSP48A1_tb/dut/C_OUT \
sim:/DSP48A1_tb/dut/OPMODE_OUT \
sim:/DSP48A1_tb/dut/b_out \
sim:/DSP48A1_tb/dut/PRE_ADD_SUB_OUT \
sim:/DSP48A1_tb/dut/SEL1 \
sim:/DSP48A1_tb/dut/b1_reg_out \
sim:/DSP48A1_tb/dut/a1_reg_out \
sim:/DSP48A1_tb/dut/MUL_OUT \
sim:/DSP48A1_tb/dut/M_OUT \
sim:/DSP48A1_tb/dut/CARRYCASCADE \
sim:/DSP48A1_tb/dut/CIN_OUT \
sim:/DSP48A1_tb/dut/CARRYOUT_IN \
sim:/DSP48A1_tb/dut/POST_ADD_SUB_OUT \
sim:/DSP48A1_tb/dut/X_OUT \
sim:/DSP48A1_tb/dut/Z_OUT
run -all
#quit -sim