#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import pathlib
import pwn as w
w.context.update(encoding="utf-8", arch="amd64", terminal=["tmux", "splitw", "-h"])  # , log_level="debug")
elf = w.ELF("./patched_chall")  # if w.args.LOCAL else ...
# libc = w.ELF("./libc.so.6")
with (elf.process([], env={}) if w.args.LOCAL else w.remote("127.0.0.1", 31337)) as io:
    sla = io.sendlineafter; sl = io.sendline; ru = io.recvuntil; rl = io.recvline; inter = io.interactive
    if w.args.GDB: w.gdb.attach(io, gdbscript="""
    c
    """)
    # print(f"[+]: {leak = :#x}")
    inter()
