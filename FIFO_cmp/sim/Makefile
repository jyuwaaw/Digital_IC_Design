all: clean compile simulate

compile:
	vcs \
	-sverilog \
	-debug_all \
	+notimingcheck \
	+nospecify \
	-l com.log \
	-full64		\
	-f file.l 

simulate:
	./simv -l sim.log +notimingcheck +nospecify 

clean:
	@rm -rf csrc DVEfiles simv simv.daidir ucli.key VCS*
	@rm -rf *.log *.vpd *.ddc *.svf *.SDF *Synth *Netlist* work vsim* transcript

