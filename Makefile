# ============================================================
# Project Settings
# ============================================================

TOP       = tb_top
BUILD_DIR = obj_dir
WAVE      = wave.vcd

# ============================================================
# Tools
# ============================================================

VERILATOR = verilator
GTKWAVE   = gtkwave

# ============================================================
# Source Files
# ============================================================

RTL_DIR = rtl
TB_DIR  = tb

SRCS = \
	$(RTL_DIR)/define.v \
	$(RTL_DIR)/pc.v \
	$(RTL_DIR)/inst_mem.v \
	$(RTL_DIR)/decoder.v \
	$(RTL_DIR)/regfile.v \
	$(RTL_DIR)/alu_control.v \
	$(RTL_DIR)/alu.v \
	$(RTL_DIR)/cpu.v \
	$(TB_DIR)/tb_top.sv

# ============================================================
# Verilator Flags
# ============================================================

VERILATOR_FLAGS = \
	-Wall \
	-Wno-UNUSEDSIGNAL \
	--timing \
	--trace \
	--binary \
	-I$(RTL_DIR) \
	--top-module $(TOP)

# ============================================================
# Targets
# ============================================================

.PHONY: all run wave lint clean

all: run

run:
	$(VERILATOR) $(VERILATOR_FLAGS) $(SRCS)
	./$(BUILD_DIR)/V$(TOP)

wave: run
	$(GTKWAVE) $(WAVE) &

lint:
	$(VERILATOR) --lint-only -Wall -I$(RTL_DIR) $(SRCS)

clean:
	rm -rf $(BUILD_DIR)
	rm -f *.vcd
	rm -f *.fst
	rm -f *.log