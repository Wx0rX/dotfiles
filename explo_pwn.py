#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import pathlib
import pwn as w
w.context.update(encoding="utf-8",bits=64,arch="amd64",terminal=["tmux","splitw","-h"])
w.tube.sla=w.tube.sendlineafter;w.tube.sa=w.tube.sendafter;w.tube.sl=w.tube.sendline;w.tube.ru=w.tube.recvuntil;w.tube.rl=w.tube.recvline;w.tube.rls=w.tube.recvlines;w.tube.rgx=w.tube.recvregex;w.tube.inter=w.tube.interactive
w.ELF.base=w.ELF.addr=w.ELF.address
ELF = w.ELF("./patched_chall")
LIBC = w.ELF("./lib/libc.so.6")  # 2.3?
# LIBSTDC = w.ELF("./lib/libstdc++.so.6")
LD = w.ELF("./lib/ld-linux-x86-64.so.2")
# wrapper:

# launch:
SREMOTE=lambda:w.remote("127.0.0.1",54321)
# SLOCAL=lambda:w.process([LD.file.name,ELF.file.name],env={"LD_PRELOAD":LIBC.file.name})
SLOCAL=lambda:w.process([ELF.file.name])
SGDB=lambda:w.gdb.debug([ELF.file.name],gdbscript)
AGDB=lambda io:(w.gdb.attach(io,gdbscript) if not w.args.GDB else ...)
# AGDB=lambda io:...
'''
checksec:
'''
gdbscript="""
# b *(0x0000555555554000+0x1337)
# b *(0x00007ffff7fb6000+0x1337)
# b *main
c
"""
# exploit:
with (SGDB()if w.args.GDB else (SLOCAL()if w.args.LOCAL else SREMOTE())) as io:
    # print(f"[+]: {leak = :#x}")
    io.inter()
