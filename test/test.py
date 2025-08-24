# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.triggers import RisingEdge, Timer
import random


@cocotb.test()
async def basic_test(dut):
    dut.rst_n.value = 0
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0

    await Timer(20, units="ns")
    dut.rst_n.value = 1
    await RisingEdge(dut.clk)

    for _ in range(5):
        dut.ui_in.value = random.randint(0, 255)
        dut.uio_in.value = random.randint(0, 255)
        await RisingEdge(dut.clk)

        dut._log.info(f"ui_in={dut.ui_in.value} "
                      f"uio_in={dut.uio_in.value} "
                      f"uo_out={dut.uo_out.value} "
                      f"uio_out={dut.uio_out.value} "
                      f"uio_oe={dut.uio_oe.value}")

    dut.ui_in.value = 0xA5
    dut.uio_in.value = 0x3C
    await RisingEdge(dut.clk)
    dut._log.info(f"Specific pattern outputs: "
                  f"uo_out={dut.uo_out.value} "
                  f"uio_out={dut.uio_out.value}")

    for _ in range(10):
        await RisingEdge(dut.clk)
