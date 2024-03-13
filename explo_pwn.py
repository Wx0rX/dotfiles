#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import pathlib

import pwn as w


w.context.update(
    encoding="utf-8",
    arch="amd64",
    terminal="tmux splitw -h -p 80".split(),
    # log_level="debug"
)
HOST, PORT = "127.0.0.1", 31337

ELF_FNAME = "./patched_chall"
elf = w.ELF(ELF_FNAME)

# LIBC_FNAME = "./libc.so.6"
# libc = w.ELF(LIBC_FNAME)


def start() -> w.tube:
    io = (
        w.process([ELF_FNAME])  # , env={"LD_PRELOAD": LIBC_FNAME}
        if w.args.LOCAL
        else w.remote(HOST, PORT)
    )
    if w.args.GDB:
        w.gdb.attach(io, gdbscript=gdbscript)
    return io


def sla(gr: bytes, data: bytes) -> None:
    io.sendlineafter(gr, data)


def slas(gr: bytes, data) -> None:
    io.sendlineafter(gr, str(data).encode())


#===========================================================
#                    WRAPPER GOES HERE
#===========================================================

#===========================================================
#                    EXPLOIT GOES HERE
#===========================================================
# pwn checksec ./patched_chall

# EXPLOITATION PLAN:
#

gdbscript = """
c
"""

with start() as io:
    # print(f"[+]: {leak=:#x}")
    io.interactive()

