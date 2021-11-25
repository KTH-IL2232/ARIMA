-- -------------------------------------------------------------
-- 
-- File Name: hdlsrc\HDLAWGNGenerator\SqrtImplementation.vhd
-- Created: 2021-11-25 00:36:10
-- 
-- Generated by MATLAB 9.11 and HDL Coder 3.19
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: SqrtImplementation
-- Source Path: HDLAWGNGenerator/AWGNGenerator/GaussianNoiseWithUnitVar/SqrtImplementation
-- Hierarchy Level: 2
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.AWGNGenerator_pkg.ALL;

ENTITY SqrtImplementation IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        u                                 :   IN    std_logic_vector(30 DOWNTO 0);  -- ufix31_En24
        f                                 :   OUT   std_logic_vector(16 DOWNTO 0)  -- ufix17_En13
        );
END SqrtImplementation;


ARCHITECTURE rtl OF SqrtImplementation IS

  -- Component Declarations
  COMPONENT SqrtEval
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          u                               :   IN    std_logic_vector(30 DOWNTO 0);  -- ufix31_En24
          f                               :   OUT   std_logic_vector(16 DOWNTO 0)  -- ufix17_En13
          );
  END COMPONENT;

  -- Component Configuration Statements
  FOR ALL : SqrtEval
    USE ENTITY work.SqrtEval(rtl);

  -- Signals
  SIGNAL u_unsigned                       : unsigned(30 DOWNTO 0);  -- ufix31_En24
  SIGNAL Delay_reg                        : vector_of_unsigned31(0 TO 1);  -- ufix31 [2]
  SIGNAL Delay_out1                       : unsigned(30 DOWNTO 0);  -- ufix31_En24
  SIGNAL Constant_out1                    : unsigned(16 DOWNTO 0);  -- ufix17_En13
  SIGNAL Delay1_reg                       : vector_of_unsigned17(0 TO 1);  -- ufix17 [2]
  SIGNAL Delay1_out1                      : unsigned(16 DOWNTO 0);  -- ufix17_En13
  SIGNAL SqrtEval_out1                    : std_logic_vector(16 DOWNTO 0);  -- ufix17
  SIGNAL SqrtEval_out1_unsigned           : unsigned(16 DOWNTO 0);  -- ufix17_En13
  SIGNAL Switch_out1                      : unsigned(16 DOWNTO 0);  -- ufix17_En13

BEGIN
  u_SqrtEval : SqrtEval
    PORT MAP( clk => clk,
              reset => reset,
              u => u,  -- ufix31_En24
              f => SqrtEval_out1  -- ufix17_En13
              );

  u_unsigned <= unsigned(u);

  Delay_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Delay_reg <= (OTHERS => to_unsigned(16#00000000#, 31));
    ELSIF clk'EVENT AND clk = '1' THEN
      Delay_reg(0) <= u_unsigned;
      Delay_reg(1) <= Delay_reg(0);
    END IF;
  END PROCESS Delay_process;

  Delay_out1 <= Delay_reg(1);

  Constant_out1 <= to_unsigned(16#00000#, 17);

  Delay1_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Delay1_reg <= (OTHERS => to_unsigned(16#00000#, 17));
    ELSIF clk'EVENT AND clk = '1' THEN
      Delay1_reg(0) <= Constant_out1;
      Delay1_reg(1) <= Delay1_reg(0);
    END IF;
  END PROCESS Delay1_process;

  Delay1_out1 <= Delay1_reg(1);

  SqrtEval_out1_unsigned <= unsigned(SqrtEval_out1);

  
  Switch_out1 <= Delay1_out1 WHEN Delay_out1 = to_unsigned(16#00000000#, 31) ELSE
      SqrtEval_out1_unsigned;

  f <= std_logic_vector(Switch_out1);

END rtl;
