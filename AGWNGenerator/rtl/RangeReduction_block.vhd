-- -------------------------------------------------------------
-- 
-- File Name: hdlsrc\HDLAWGNGenerator\RangeReduction_block.vhd
-- Created: 2021-11-25 00:36:10
-- 
-- Generated by MATLAB 9.11 and HDL Coder 3.19
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: RangeReduction_block
-- Source Path: HDLAWGNGenerator/AWGNGenerator/GaussianNoiseWithUnitVar/logImplementation/log/RangeReduction
-- Hierarchy Level: 4
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.AWGNGenerator_pkg.ALL;

ENTITY RangeReduction_block IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        x                                 :   IN    std_logic_vector(47 DOWNTO 0);  -- ufix48_En48
        x_e                               :   OUT   std_logic_vector(48 DOWNTO 0);  -- ufix49_En48
        exp_e                             :   OUT   std_logic_vector(7 DOWNTO 0)  -- uint8
        );
END RangeReduction_block;


ARCHITECTURE rtl OF RangeReduction_block IS

  -- Component Declarations
  COMPONENT leadingZeroDetector_block
    PORT( x                               :   IN    std_logic_vector(47 DOWNTO 0);  -- ufix48_En48
          exp_e                           :   OUT   std_logic_vector(7 DOWNTO 0)  -- uint8
          );
  END COMPONENT;

  -- Component Configuration Statements
  FOR ALL : leadingZeroDetector_block
    USE ENTITY work.leadingZeroDetector_block(rtl);

  -- Signals
  SIGNAL x_unsigned                       : unsigned(47 DOWNTO 0);  -- ufix48_En48
  SIGNAL Delay_reg                        : vector_of_unsigned48(0 TO 2);  -- ufix48 [3]
  SIGNAL Delay_out1                       : unsigned(47 DOWNTO 0);  -- ufix48_En48
  SIGNAL Delay1_out1                      : unsigned(47 DOWNTO 0);  -- ufix48_En48
  SIGNAL exp_e_1                          : std_logic_vector(7 DOWNTO 0);  -- ufix8
  SIGNAL exp_e_unsigned                   : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL Delay2_reg                       : vector_of_unsigned8(0 TO 1);  -- ufix8 [2]
  SIGNAL Delay2_out1                      : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL x_e_1                            : unsigned(47 DOWNTO 0);  -- ufix48_En48
  SIGNAL Constant_out1                    : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL Add_add_cast                     : unsigned(55 DOWNTO 0);  -- ufix56_En48
  SIGNAL Add_add_cast_1                   : unsigned(55 DOWNTO 0);  -- ufix56_En48
  SIGNAL Add_add_temp                     : unsigned(55 DOWNTO 0);  -- ufix56_En48
  SIGNAL Add_out1                         : unsigned(48 DOWNTO 0);  -- ufix49_En48

BEGIN
  -- Range of x_e=[1,2)

  u_leadingZeroDetector : leadingZeroDetector_block
    PORT MAP( x => std_logic_vector(Delay1_out1),  -- ufix48_En48
              exp_e => exp_e_1  -- uint8
              );

  x_unsigned <= unsigned(x);

  Delay_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Delay_reg <= (OTHERS => to_unsigned(0, 48));
    ELSIF clk'EVENT AND clk = '1' THEN
      Delay_reg(0) <= x_unsigned;
      Delay_reg(1 TO 2) <= Delay_reg(0 TO 1);
    END IF;
  END PROCESS Delay_process;

  Delay_out1 <= Delay_reg(2);

  Delay1_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Delay1_out1 <= to_unsigned(0, 48);
    ELSIF clk'EVENT AND clk = '1' THEN
      Delay1_out1 <= x_unsigned;
    END IF;
  END PROCESS Delay1_process;


  exp_e_unsigned <= unsigned(exp_e_1);

  Delay2_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Delay2_reg <= (OTHERS => to_unsigned(16#00#, 8));
    ELSIF clk'EVENT AND clk = '1' THEN
      Delay2_reg(0) <= exp_e_unsigned;
      Delay2_reg(1) <= Delay2_reg(0);
    END IF;
  END PROCESS Delay2_process;

  Delay2_out1 <= Delay2_reg(1);

  x_e_1 <= Delay_out1 sll to_integer(Delay2_out1);

  Constant_out1 <= to_unsigned(16#01#, 8);

  Add_add_cast <= resize(x_e_1, 56);
  Add_add_cast_1 <= Constant_out1 & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0';
  Add_add_temp <= Add_add_cast + Add_add_cast_1;
  Add_out1 <= Add_add_temp(48 DOWNTO 0);

  x_e <= std_logic_vector(Add_out1);

  exp_e <= std_logic_vector(Delay2_out1);

END rtl;
