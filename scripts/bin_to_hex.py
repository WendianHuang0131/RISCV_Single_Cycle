#!/usr/bin/env python3
import sys

if len(sys.argv) != 3:
    print("Usage: bin_to_hex.py input.bin output.hex")
    sys.exit(1)

bin_file = sys.argv[1]
hex_file = sys.argv[2]

with open(bin_file, "rb") as f:
    data = f.read()

# Pad to multiple of 4 bytes
if len(data) % 4 != 0:
    data += b"\x00" * (4 - len(data) % 4)

with open(hex_file, "w") as f:
    for i in range(0, len(data), 4):
        word_bytes = data[i:i+4]

        # RISC-V binary is little-endian.
        # program.hex 每一行要寫成 32-bit instruction value.
        word = int.from_bytes(word_bytes, byteorder="little")

        f.write(f"{word:08x}\n")