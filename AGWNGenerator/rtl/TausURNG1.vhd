-- -------------------------------------------------------------
-- 
-- File Name: hdlsrc\HDLAWGNGenerator\TausURNG1.vhd
-- Created: 2021-11-25 00:36:10
-- 
-- Generated by MATLAB 9.11 and HDL Coder 3.19
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: TausURNG1
-- Source Path: HDLAWGNGenerator/AWGNGenerator/GaussianNoiseWithUnitVar/TausUniformRandGen/TausURNG1
-- Hierarchy Level: 3
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY TausURNG1 IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        a                                 :   OUT   std_logic_vector(31 DOWNTO 0)  -- uint32
        );
END TausURNG1;


ARCHITECTURE rtl OF TausURNG1 IS

  -- Signals
  SIGNAL bitMask_for_Bitwise_Operator1    : unsigned(31 DOWNTO 0);  -- uint32
  SIGNAL Delay_out1                       : unsigned(31 DOWNTO 0);  -- uint32
  SIGNAL Bitwise_Operator1_out1           : unsigned(31 DOWNTO 0);  -- uint32
  SIGNAL Bit_Shift2_out1                  : unsigned(31 DOWNTO 0);  -- uint32
  SIGNAL Bitwise_Operator2_out1           : unsigned(31 DOWNTO 0);  -- uint32
  SIGNAL Bit_Shift_out1                   : unsigned(31 DOWNTO 0);  -- uint32
  SIGNAL Bitwise_Operator_out1            : unsigned(31 DOWNTO 0);  -- uint32
  SIGNAL Bit_Shift1_out1                  : unsigned(31 DOWNTO 0);  -- uint32
  SIGNAL bitMask_for_Bitwise_Operator4    : unsigned(31 DOWNTO 0);  -- uint32
  SIGNAL Delay1_out1                      : unsigned(31 DOWNTO 0);  -- uint32
  SIGNAL Bitwise_Operator4_out1           : unsigned(31 DOWNTO 0);  -- uint32
  SIGNAL Bit_Shift4_out1                  : unsigned(31 DOWNTO 0);  -- uint32
  SIGNAL Bitwise_Operator5_out1           : unsigned(31 DOWNTO 0);  -- uint32
  SIGNAL Bit_Shift3_out1                  : unsigned(31 DOWNTO 0);  -- uint32
  SIGNAL Bitwise_Operator3_out1           : unsigned(31 DOWNTO 0);  -- uint32
  SIGNAL Bit_Shift5_out1                  : unsigned(31 DOWNTO 0);  -- uint32
  SIGNAL bitMask_for_Bitwise_Operator7    : unsigned(31 DOWNTO 0);  -- uint32
  SIGNAL Delay2_out1                      : unsigned(31 DOWNTO 0);  -- uint32
  SIGNAL Bitwise_Operator7_out1           : unsigned(31 DOWNTO 0);  -- uint32
  SIGNAL Bit_Shift7_out1                  : unsigned(31 DOWNTO 0);  -- uint32
  SIGNAL Bitwise_Operator8_out1           : unsigned(31 DOWNTO 0);  -- uint32
  SIGNAL Bit_Shift6_out1                  : unsigned(31 DOWNTO 0);  -- uint32
  SIGNAL Bitwise_Operator6_out1           : unsigned(31 DOWNTO 0);  -- uint32
  SIGNAL Bit_Shift8_out1                  : unsigned(31 DOWNTO 0);  -- uint32
  SIGNAL Bitwise_Operator9_out1           : unsigned(31 DOWNTO 0);  -- uint32

BEGIN
  -- S0
  -- 
  -- S1
  -- 
  -- S1

  bitMask_for_Bitwise_Operator1 <= unsigned'(X"FFFFFFFE");

  Bitwise_Operator1_out1 <= Delay_out1 AND bitMask_for_Bitwise_Operator1;

  Bit_Shift2_out1 <= Bitwise_Operator1_out1 sll 12;

  Delay_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Delay_out1 <= to_unsigned(121, 32);
    ELSIF clk'EVENT AND clk = '1' THEN
      Delay_out1 <= Bitwise_Operator2_out1;
    END IF;
  END PROCESS Delay_process;


  Bit_Shift_out1 <= Delay_out1 sll 13;

  Bitwise_Operator_out1 <= Bit_Shift_out1 XOR Delay_out1;

  Bit_Shift1_out1 <= Bitwise_Operator_out1 srl 19;

  Bitwise_Operator2_out1 <= Bit_Shift1_out1 XOR Bit_Shift2_out1;

  bitMask_for_Bitwise_Operator4 <= unsigned'(X"FFFFFFF8");

  Bitwise_Operator4_out1 <= Delay1_out1 AND bitMask_for_Bitwise_Operator4;

  Bit_Shift4_out1 <= Bitwise_Operator4_out1 sll 4;

  Delay1_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Delay1_out1 <= to_unsigned(719, 32);
    ELSIF clk'EVENT AND clk = '1' THEN
      Delay1_out1 <= Bitwise_Operator5_out1;
    END IF;
  END PROCESS Delay1_process;


  Bit_Shift3_out1 <= Delay1_out1 sll 2;

  Bitwise_Operator3_out1 <= Bit_Shift3_out1 XOR Delay1_out1;

  Bit_Shift5_out1 <= Bitwise_Operator3_out1 srl 25;

  Bitwise_Operator5_out1 <= Bit_Shift5_out1 XOR Bit_Shift4_out1;

  bitMask_for_Bitwise_Operator7 <= unsigned'(X"FFFFFFF0");

  Bitwise_Operator7_out1 <= Delay2_out1 AND bitMask_for_Bitwise_Operator7;

  Bit_Shift7_out1 <= Bitwise_Operator7_out1 sll 17;

  Delay2_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Delay2_out1 <= to_unsigned(511, 32);
    ELSIF clk'EVENT AND clk = '1' THEN
      Delay2_out1 <= Bitwise_Operator8_out1;
    END IF;
  END PROCESS Delay2_process;


  Bit_Shift6_out1 <= Delay2_out1 sll 3;

  Bitwise_Operator6_out1 <= Bit_Shift6_out1 XOR Delay2_out1;

  Bit_Shift8_out1 <= Bitwise_Operator6_out1 srl 11;

  Bitwise_Operator8_out1 <= Bit_Shift8_out1 XOR Bit_Shift7_out1;

  Bitwise_Operator9_out1 <= Bitwise_Operator8_out1 XOR (Bitwise_Operator2_out1 XOR Bitwise_Operator5_out1);

  a <= std_logic_vector(Bitwise_Operator9_out1);

END rtl;
