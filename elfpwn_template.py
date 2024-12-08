#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import os
import pathlib
import pwn as w
w.context.update(encoding="utf-8",bits=64,arch="amd64",terminal=["tmux","splitw","-h"])
w.tube.sla=w.tube.sendlineafter;w.tube.sa=w.tube.sendafter;w.tube.sl=w.tube.sendline;w.tube.ru=w.tube.recvuntil;w.tube.rl=w.tube.recvline;w.tube.rls=w.tube.recvlines;w.tube.rgx=w.tube.recvregex;w.tube.inter=w.tube.interactive;w.ELF.base=w.ELF.addr=w.ELF.address
os.system("mkdir -p ./lib/ ; sudo docker compose up -d --build")
for _ in["ld-linux-x86-64.so.2","libc.so.6","libstdc++.so.6","libgcc_s.so.1","libm.so.6"]:os.system(f"mkdir -p ./lib/ && sudo docker compose cp -L task:/lib/x86_64-linux-gnu/{_} ./lib/")
os.system("mkdir -p ./lib/ ; cp ./ld-linux-x86-64.so.2 ./libc.so.6 ./lib/ ; patchelf --set-interpreter ./lib/ld-linux-x86-64.so.2 --force-rpath --set-rpath ./lib/ --output ./pchall ./chall")
elf = w.ELF("./pchall")
libc = w.ELF("./lib/libc.so.6")  # 2.??
# libstdcpp = w.ELF("./lib/libstdc++.so.6")
# ld = w.ELF("./lib/ld-linux-x86-64.so.2")
# launch:
HOST=w.args.HOST or "127.0.0.1"
PORT=w.args.PORT or 54321
SREMOTE=lambda:w.remote(HOST,PORT)
# SLOCAL=lambda:w.process([ld.file.name,elf.file.name],env={"LD_PRELOAD":libc.file.name})
SLOCAL=lambda:w.process([elf.file.name])
SGDB=lambda:w.gdb.debug([elf.file.name],gdbscript)
AGDB=lambda io:(w.gdb.attach(io,gdbscript)if w.args.LOCAL and not w.args.GDB else...)
START=lambda:(SGDB()if w.args.GDB else (SLOCAL()if w.args.LOCAL else SREMOTE()))
# AGDB=lambda io:...
def FAST(io):
    io.sa=lambda *a:io.send(*(a[1:]))
    io.sla=lambda *a:io.sl(*(a[1:]))
'''
checksec:
'''
gdbscript="""
# b *(0x0000555555554000+0x1337)
# b *(0x00007ffff7fb6000+0x1337)
# b *main
c
"""
LIBC,HEAP,STACK,ELF,LIBSTDCPP,LD=...,...,...,...,...,...
# if __name__ == "__main__":
with START() as io:
    io.inter()  # print(f"[+]: {leak = :#x}")
