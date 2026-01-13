# SRAM ZBT FPGA-based controller

This projects aims at creating a FPGA-based controller for a ZBT-type SRAM (MT55L512Y36F).

## Implementations

Two implementations are meant to be offered for comparison:
* a direct native VHDL implementation on Vivado, in `sram-controller-vivado`;
* a C++ implementation, which can be synthethized into VHDL/Verilog using Vitis HLS, in `sram-controller-vitis` (it is incomplete).

## ___________________

This software has been designed by [Firmin Launay](mailto:Firmin_Launay@etu.u-bourgogne.fr), in 2025-2026, as part of the *Processings and Interfaces on Embedded Systems* course at [Polytech Dijon](https://polytech.ube.fr).
