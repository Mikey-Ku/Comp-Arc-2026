tools ?= $(HOME)/Tools/oss-cad-suite/bin/
filename = top
pcf_file = iceBlinkPico.pcf

build:
	$(tools)yosys -p "synth_ice40 -top top -json $(filename).json" $(filename).sv
	$(tools)nextpnr-ice40 --up5k --package sg48 --json $(filename).json --pcf $(pcf_file) --asc $(filename).asc
	$(tools)icepack $(filename).asc $(filename).bin

prog: #for sram
	$(tools)dfu-util --device 1d50:6146 --alt 0 -D $(filename).bin -R

sim:
	$(tools)iverilog -g2012 -o rgb_hsv_pwm_tb.vvp rgb_hsv_pwm_tb.sv
	$(tools)vvp rgb_hsv_pwm_tb.vvp
	$(tools)gtkwave rgb_hsv_pwm.vcd

clean:
	rm -rf $(filename).asc $(filename).json $(filename).bin *.vvp *.vcd
