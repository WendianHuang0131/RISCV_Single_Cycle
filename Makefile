# ============================================================
# Project Settings
# ============================================================

TOP          = tb_top
TEST        ?= alu_basic
SIM_CYCLES  ?= 50

BUILD_DIR   = build
OBJ_DIR     = obj_dir
PROGRAM_DIR = program

# ============================================================
# Directories
# ============================================================

RTL_DIR     = rtl
TB_DIR      = tb
TEST_DIR    = tests
SCRIPT_DIR  = scripts

PRELOAD_DIR = $(TEST_DIR)/preload_data
EXPECT_DIR  = $(TEST_DIR)/expected_result

# ============================================================
# Files
# ============================================================

ASM_FILE     = $(TEST_DIR)/$(TEST).S
ELF_FILE     = $(BUILD_DIR)/$(TEST).elf
BIN_FILE     = $(BUILD_DIR)/$(TEST).bin
HEX_FILE     = $(PROGRAM_DIR)/$(TEST).hex
VCD_FILE     = wave_$(TEST).vcd

PRELOAD_FILE = $(PRELOAD_DIR)/$(TEST).hex
EXPECT_FILE  = $(EXPECT_DIR)/$(TEST).hex

# ============================================================
# Tools
# ============================================================

VERILATOR = verilator
GTKWAVE   = gtkwave

RISCV_GCC     = riscv64-elf-gcc
RISCV_OBJCOPY = riscv64-elf-objcopy
RISCV_OBJDUMP = riscv64-elf-objdump

# ============================================================
# Source Files
# ============================================================

RTL_SRCS = \
	$(RTL_DIR)/define.v \
	$(RTL_DIR)/pc.v \
	$(RTL_DIR)/inst_mem.v \
	$(RTL_DIR)/decoder.v \
	$(RTL_DIR)/regfile.v \
	$(RTL_DIR)/alu_control.v \
	$(RTL_DIR)/alu.v \
	$(RTL_DIR)/imm_gen.v \
	$(RTL_DIR)/data_mem.v \
	$(RTL_DIR)/wb_mux.v \
	$(RTL_DIR)/cpu.v

TB_SRCS = \
	$(TB_DIR)/tb_top.sv

SRCS = $(RTL_SRCS) $(TB_SRCS)

# ============================================================
# RISC-V Compile Flags
# ============================================================

ASM_FLAGS = \
	-march=rv32i \
	-mabi=ilp32 \
	-nostdlib \
	-nostartfiles \
	-ffreestanding \
	-Wl,-Ttext=0x0

# ============================================================
# Verilator Flags
# ============================================================

VERILATOR_FLAGS = \
	-Wall \
	-Wno-UNUSEDSIGNAL \
	-Wno-DECLFILENAME \
	-Wno-CASEINCOMPLETE \
	--timing \
	--trace \
	--binary \
	-I$(RTL_DIR) \
	--top-module $(TOP)

# ============================================================
# Targets
# ============================================================

.PHONY: all run wave lint asm dump clean list \
	check-toolchain check-test-files check-dirs info

all: run

# ------------------------------------------------------------
# Show current config
# ------------------------------------------------------------

info:
	@echo "============================================================"
	@echo "TEST         = $(TEST)"
	@echo "SIM_CYCLES   = $(SIM_CYCLES)"
	@echo "ASM_FILE     = $(ASM_FILE)"
	@echo "ELF_FILE     = $(ELF_FILE)"
	@echo "BIN_FILE     = $(BIN_FILE)"
	@echo "HEX_FILE     = $(HEX_FILE)"
	@echo "PRELOAD_FILE = $(PRELOAD_FILE)"
	@echo "EXPECT_FILE  = $(EXPECT_FILE)"
	@echo "VCD_FILE     = $(VCD_FILE)"
	@echo "============================================================"

# ------------------------------------------------------------
# List available tests
# ------------------------------------------------------------

list:
	@echo "Available tests:"
	@ls $(TEST_DIR)/*.S 2>/dev/null | xargs -n1 basename | sed 's/.S//' || true

# ------------------------------------------------------------
# Toolchain check
# ------------------------------------------------------------

check-toolchain:
	@command -v $(RISCV_GCC) >/dev/null 2>&1 || { \
		echo "Error: $(RISCV_GCC) not found."; \
		echo "Please check your RISC-V toolchain installation."; \
		exit 1; \
	}
	@command -v $(RISCV_OBJCOPY) >/dev/null 2>&1 || { \
		echo "Error: $(RISCV_OBJCOPY) not found."; \
		echo "Please check your RISC-V toolchain installation."; \
		exit 1; \
	}
	@command -v $(RISCV_OBJDUMP) >/dev/null 2>&1 || { \
		echo "Error: $(RISCV_OBJDUMP) not found."; \
		echo "Please check your RISC-V toolchain installation."; \
		exit 1; \
	}

# ------------------------------------------------------------
# Test file check
# ------------------------------------------------------------

check-test-files:
	@test -f $(ASM_FILE) || { \
		echo "Error: missing assembly file: $(ASM_FILE)"; \
		exit 1; \
	}
	@test -f $(PRELOAD_FILE) || { \
		echo "Error: missing preload file: $(PRELOAD_FILE)"; \
		echo "Please create: $(PRELOAD_FILE)"; \
		exit 1; \
	}
	@test -f $(EXPECT_FILE) || { \
		echo "Error: missing expected result file: $(EXPECT_FILE)"; \
		echo "Please create: $(EXPECT_FILE)"; \
		exit 1; \
	}

# ------------------------------------------------------------
# Directory creation
# ------------------------------------------------------------

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(PROGRAM_DIR):
	mkdir -p $(PROGRAM_DIR)

check-dirs: $(BUILD_DIR) $(PROGRAM_DIR)

# ------------------------------------------------------------
# Build assembly to hex
# ------------------------------------------------------------

asm: $(HEX_FILE)

$(ELF_FILE): $(ASM_FILE) | $(BUILD_DIR) check-toolchain
	$(RISCV_GCC) $(ASM_FLAGS) $< -o $@

$(BIN_FILE): $(ELF_FILE)
	$(RISCV_OBJCOPY) -O binary $< $@

$(HEX_FILE): $(BIN_FILE) | $(PROGRAM_DIR)
	python3 $(SCRIPT_DIR)/bin_to_hex.py $< $@

# ------------------------------------------------------------
# Objdump
# ------------------------------------------------------------

dump: $(ELF_FILE)
	$(RISCV_OBJDUMP) -d $<

# ------------------------------------------------------------
# Run simulation
# ------------------------------------------------------------

run: check-test-files $(HEX_FILE)
	$(VERILATOR) $(VERILATOR_FLAGS) $(SRCS)
	./$(OBJ_DIR)/V$(TOP) \
		+TEST=$(TEST) \
		+HEX=$(HEX_FILE) \
		+PRELOAD=$(PRELOAD_FILE) \
		+EXPECT=$(EXPECT_FILE) \
		+VCD=$(VCD_FILE) \
		+SIM_CYCLES=$(SIM_CYCLES)

# ------------------------------------------------------------
# Run simulation and open GTKWave
# ------------------------------------------------------------

wave: run
	$(GTKWAVE) $(VCD_FILE) &

# ------------------------------------------------------------
# Lint only
# ------------------------------------------------------------

lint:
	$(VERILATOR) \
		--lint-only \
		-Wall \
		-Wno-UNUSEDSIGNAL \
		-Wno-DECLFILENAME \
		-Wno-CASEINCOMPLETE \
		-I$(RTL_DIR) \
		$(SRCS)

# ------------------------------------------------------------
# Clean generated files
# ------------------------------------------------------------

clean:
	rm -rf $(BUILD_DIR)
	rm -rf $(OBJ_DIR)
	rm -f $(PROGRAM_DIR)/*.hex
	rm -f *.vcd
	rm -f *.fst
	rm -f *.log