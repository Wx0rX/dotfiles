#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import pathlib
import pwn as w
w.context.update(encoding="utf-8",bits=64,arch="amd64",terminal=["tmux","splitw","-h"])
w.tube.sla=w.tube.sendlineafter;w.tube.sa=w.tube.sendafter;w.tube.sl=w.tube.sendline;w.tube.ru=w.tube.recvuntil;w.tube.rl=w.tube.recvline;w.tube.rls=w.tube.recvlines;w.tube.rgx=w.tube.recvregex;w.tube.inter=w.tube.interactive
EP = "./patched_chall"
LP = "./libc.so.6"
elf = w.ELF(EP)  # if w.args.LOCAL else ...
libc = w.ELF(LP)  # if w.args.LOCAL else ...
# wrapper:
def ATTACH_GDB():
    if w.args.GDB: w.gdb.attach(io,gdbscript="""
    # # noaslr
    # b *main
    # b *(0x0000555555554000+0x1337)
    # b *(0x00007ffff7fb6000+0x1337)
    c
    """)
# exploit:
with (w.process(["./ld-linux-x86-64.so.2",EP],env={"LD_PRELOAD":LP}) if w.args.LOCAL else w.remote("127.0.0.1",5000)) as io:
    ATTACH_GDB()
    # print(f"[+]: {leak = :#x}")
    io.inter()
