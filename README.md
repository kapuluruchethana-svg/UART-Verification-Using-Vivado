# UART Verification Using Vivado

## Overview
This project implements UART Transmitter and Receiver modules using Verilog HDL and verifies serial communication through loopback simulation in Vivado.

## Features
- UART Transmitter (FSM Based)
- UART Receiver (FSM Based)
- Baud Rate Generator
- Loopback Verification
- Behavioral Simulation

## Tools Used
- Verilog HDL
- Xilinx Vivado

## Verification Flow
The transmitter output is connected directly to the receiver input to perform UART loopback verification.

## Simulation Result
- Transmitted Data = AA
- Received Data = AA
- rx_done pulse generated successfully

## Files
- uart_tx.v
- uart_rx.v
- baud_gen.v
- uart_tb.v

## Author
Kapuluru Chethana
