-- -------------------------------------------------------------
-- 
-- File Name: hdlsrc\HDLAWGNGenerator\logImplementation.vhd
-- Created: 2021-11-25 00:36:10
-- 
-- Generated by MATLAB 9.11 and HDL Coder 3.19
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: logImplementation
-- Source Path: HDLAWGNGenerator/AWGNGenerator/GaussianNoiseWithUnitVar/logImplementation
-- Hierarchy Level: 2
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.AWGNGenerator_pkg.ALL;

ENTITY logImplementation IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        u0_48_48                          :   IN    std_logic_vector(47 DOWNTO 0);  -- ufix48_En48
        e                                 :   OUT   std_logic_vector(30 DOWNTO 0)  -- ufix31_En24
        );
END logImplementation;


ARCHITECTURE rtl OF logImplementation IS

  -- Component Declarations
  COMPONENT log
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          u0_48_48                        :   IN    std_logic_vector(47 DOWNTO 0);  -- ufix48_En48
          e                               :   OUT   std_logic_vector(30 DOWNTO 0)  -- ufix31_En24
          );
  END COMPONENT;

  -- Component Configuration Statements
  FOR ALL : log
    USE ENTITY work.log(rtl);

  -- Signals
  SIGNAL u0_48_48_unsigned                : unsigned(47 DOWNTO 0);  -- ufix48_En48
  SIGNAL Delay_reg                        : vector_of_unsigned48(0 TO 2);  -- ufix48 [3]
  SIGNAL Delay_out1                       : unsigned(47 DOWNTO 0);  -- ufix48_En48
  SIGNAL Constant_out1                    : unsigned(15 DOWNTO 0);  -- ufix16_En9
  SIGNAL Constant_out1_dtc                : unsigned(30 DOWNTO 0);  -- ufix31_En24
  SIGNAL y                                : std_logic_vector(30 DOWNTO 0);  -- ufix31
  SIGNAL y_unsigned                       : unsigned(30 DOWNTO 0);  -- ufix31_En24
  SIGNAL Switch_out1                      : unsigned(30 DOWNTO 0);  -- ufix31_En24

BEGIN
  u_log : log
    PORT MAP( clk => clk,
              reset => reset,
              u0_48_48 => u0_48_48,  -- ufix48_En48
              e => y  -- ufix31_En24
              );

  u0_48_48_unsigned <= unsigned(u0_48_48);

  Delay_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Delay_reg <= (OTHERS => to_unsigned(0, 48));
    ELSIF clk'EVENT AND clk = '1' THEN
      Delay_reg(0) <= u0_48_48_unsigned;
      Delay_reg(1 TO 2) <= Delay_reg(0 TO 1);
    END IF;
  END PROCESS Delay_process;

  Delay_out1 <= Delay_reg(2);

  Constant_out1 <= to_unsigned(16#0000#, 16);

  Constant_out1_dtc <= Constant_out1 & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0';

  y_unsigned <= unsigned(y);

  
  Switch_out1 <= Constant_out1_dtc WHEN Delay_out1 = to_unsigned(0, 48) ELSE
      y_unsigned;

  e <= std_logic_vector(Switch_out1);

END rtl;
