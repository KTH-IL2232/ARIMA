-- -------------------------------------------------------------
-- 
-- File Name: hdlsrc\HDLAWGNGenerator\FunctionEvaluation_block.vhd
-- Created: 2021-11-25 00:36:10
-- 
-- Generated by MATLAB 9.11 and HDL Coder 3.19
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: FunctionEvaluation_block
-- Source Path: HDLAWGNGenerator/AWGNGenerator/GaussianNoiseWithUnitVar/logImplementation/log/FunctionEvaluation
-- Hierarchy Level: 4
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.AWGNGenerator_pkg.ALL;

ENTITY FunctionEvaluation_block IS
  PORT( x_e                               :   IN    std_logic_vector(48 DOWNTO 0);  -- ufix49_En48
        exp_eIn                           :   IN    std_logic_vector(7 DOWNTO 0);  -- uint8
        y_e                               :   OUT   std_logic_vector(30 DOWNTO 0);  -- sfix31_En27
        exp_eOut                          :   OUT   std_logic_vector(7 DOWNTO 0)  -- uint8
        );
END FunctionEvaluation_block;


ARCHITECTURE rtl OF FunctionEvaluation_block IS

  -- Constants
  CONSTANT alpha1_D_Lookup_Table_table_data : vector_of_signed16(0 TO 255) := 
    (to_signed(-16#3FC0#, 16), to_signed(-16#3F42#, 16), to_signed(-16#3EC5#, 16), to_signed(-16#3E49#, 16),
     to_signed(-16#3DCF#, 16), to_signed(-16#3D56#, 16), to_signed(-16#3CDF#, 16), to_signed(-16#3C69#, 16),
     to_signed(-16#3BF4#, 16), to_signed(-16#3B81#, 16), to_signed(-16#3B0E#, 16), to_signed(-16#3A9E#, 16),
     to_signed(-16#3A2E#, 16), to_signed(-16#39C0#, 16), to_signed(-16#3953#, 16), to_signed(-16#38E7#, 16),
     to_signed(-16#387C#, 16), to_signed(-16#3812#, 16), to_signed(-16#37AA#, 16), to_signed(-16#3743#, 16),
     to_signed(-16#36DD#, 16), to_signed(-16#3678#, 16), to_signed(-16#3614#, 16), to_signed(-16#35B1#, 16),
     to_signed(-16#354F#, 16), to_signed(-16#34EE#, 16), to_signed(-16#348E#, 16), to_signed(-16#3430#, 16),
     to_signed(-16#33D2#, 16), to_signed(-16#3375#, 16), to_signed(-16#3319#, 16), to_signed(-16#32BE#, 16),
     to_signed(-16#3265#, 16), to_signed(-16#320C#, 16), to_signed(-16#31B4#, 16), to_signed(-16#315C#, 16),
     to_signed(-16#3106#, 16), to_signed(-16#30B1#, 16), to_signed(-16#305C#, 16), to_signed(-16#3009#, 16),
     to_signed(-16#2FB6#, 16), to_signed(-16#2F64#, 16), to_signed(-16#2F13#, 16), to_signed(-16#2EC2#, 16),
     to_signed(-16#2E73#, 16), to_signed(-16#2E24#, 16), to_signed(-16#2DD6#, 16), to_signed(-16#2D89#, 16),
     to_signed(-16#2D3C#, 16), to_signed(-16#2CF1#, 16), to_signed(-16#2CA6#, 16), to_signed(-16#2C5C#, 16),
     to_signed(-16#2C12#, 16), to_signed(-16#2BC9#, 16), to_signed(-16#2B81#, 16), to_signed(-16#2B3A#, 16),
     to_signed(-16#2AF3#, 16), to_signed(-16#2AAD#, 16), to_signed(-16#2A68#, 16), to_signed(-16#2A23#, 16),
     to_signed(-16#29DF#, 16), to_signed(-16#299C#, 16), to_signed(-16#2959#, 16), to_signed(-16#2917#, 16),
     to_signed(-16#28D5#, 16), to_signed(-16#2894#, 16), to_signed(-16#2854#, 16), to_signed(-16#2814#, 16),
     to_signed(-16#27D5#, 16), to_signed(-16#2796#, 16), to_signed(-16#2758#, 16), to_signed(-16#271B#, 16),
     to_signed(-16#26DE#, 16), to_signed(-16#26A2#, 16), to_signed(-16#2666#, 16), to_signed(-16#262B#, 16),
     to_signed(-16#25F0#, 16), to_signed(-16#25B6#, 16), to_signed(-16#257C#, 16), to_signed(-16#2543#, 16),
     to_signed(-16#250B#, 16), to_signed(-16#24D3#, 16), to_signed(-16#249B#, 16), to_signed(-16#2464#, 16),
     to_signed(-16#242D#, 16), to_signed(-16#23F7#, 16), to_signed(-16#23C1#, 16), to_signed(-16#238C#, 16),
     to_signed(-16#2357#, 16), to_signed(-16#2323#, 16), to_signed(-16#22EF#, 16), to_signed(-16#22BC#, 16),
     to_signed(-16#2289#, 16), to_signed(-16#2256#, 16), to_signed(-16#2224#, 16), to_signed(-16#21F3#, 16),
     to_signed(-16#21C1#, 16), to_signed(-16#2191#, 16), to_signed(-16#2160#, 16), to_signed(-16#2130#, 16),
     to_signed(-16#2101#, 16), to_signed(-16#20D1#, 16), to_signed(-16#20A3#, 16), to_signed(-16#2074#, 16),
     to_signed(-16#2046#, 16), to_signed(-16#2018#, 16), to_signed(-16#1FEB#, 16), to_signed(-16#1FBE#, 16),
     to_signed(-16#1F92#, 16), to_signed(-16#1F66#, 16), to_signed(-16#1F3A#, 16), to_signed(-16#1F0E#, 16),
     to_signed(-16#1EE3#, 16), to_signed(-16#1EB9#, 16), to_signed(-16#1E8E#, 16), to_signed(-16#1E64#, 16),
     to_signed(-16#1E3A#, 16), to_signed(-16#1E11#, 16), to_signed(-16#1DE8#, 16), to_signed(-16#1DBF#, 16),
     to_signed(-16#1D97#, 16), to_signed(-16#1D6F#, 16), to_signed(-16#1D47#, 16), to_signed(-16#1D1F#, 16),
     to_signed(-16#1CF8#, 16), to_signed(-16#1CD2#, 16), to_signed(-16#1CAB#, 16), to_signed(-16#1C85#, 16),
     to_signed(-16#1C5F#, 16), to_signed(-16#1C39#, 16), to_signed(-16#1C14#, 16), to_signed(-16#1BEF#, 16),
     to_signed(-16#1BCA#, 16), to_signed(-16#1BA6#, 16), to_signed(-16#1B81#, 16), to_signed(-16#1B5D#, 16),
     to_signed(-16#1B3A#, 16), to_signed(-16#1B16#, 16), to_signed(-16#1AF3#, 16), to_signed(-16#1AD0#, 16),
     to_signed(-16#1AAE#, 16), to_signed(-16#1A8C#, 16), to_signed(-16#1A6A#, 16), to_signed(-16#1A48#, 16),
     to_signed(-16#1A26#, 16), to_signed(-16#1A05#, 16), to_signed(-16#19E4#, 16), to_signed(-16#19C3#, 16),
     to_signed(-16#19A2#, 16), to_signed(-16#1982#, 16), to_signed(-16#1962#, 16), to_signed(-16#1942#, 16),
     to_signed(-16#1923#, 16), to_signed(-16#1903#, 16), to_signed(-16#18E4#, 16), to_signed(-16#18C5#, 16),
     to_signed(-16#18A6#, 16), to_signed(-16#1888#, 16), to_signed(-16#186A#, 16), to_signed(-16#184C#, 16),
     to_signed(-16#182E#, 16), to_signed(-16#1810#, 16), to_signed(-16#17F3#, 16), to_signed(-16#17D5#, 16),
     to_signed(-16#17B9#, 16), to_signed(-16#179C#, 16), to_signed(-16#177F#, 16), to_signed(-16#1763#, 16),
     to_signed(-16#1747#, 16), to_signed(-16#172B#, 16), to_signed(-16#170F#, 16), to_signed(-16#16F3#, 16),
     to_signed(-16#16D8#, 16), to_signed(-16#16BD#, 16), to_signed(-16#16A2#, 16), to_signed(-16#1687#, 16),
     to_signed(-16#166C#, 16), to_signed(-16#1652#, 16), to_signed(-16#1637#, 16), to_signed(-16#161D#, 16),
     to_signed(-16#1603#, 16), to_signed(-16#15EA#, 16), to_signed(-16#15D0#, 16), to_signed(-16#15B7#, 16),
     to_signed(-16#159E#, 16), to_signed(-16#1585#, 16), to_signed(-16#156C#, 16), to_signed(-16#1553#, 16),
     to_signed(-16#153A#, 16), to_signed(-16#1522#, 16), to_signed(-16#150A#, 16), to_signed(-16#14F2#, 16),
     to_signed(-16#14DA#, 16), to_signed(-16#14C2#, 16), to_signed(-16#14AB#, 16), to_signed(-16#1493#, 16),
     to_signed(-16#147C#, 16), to_signed(-16#1465#, 16), to_signed(-16#144E#, 16), to_signed(-16#1437#, 16),
     to_signed(-16#1421#, 16), to_signed(-16#140A#, 16), to_signed(-16#13F4#, 16), to_signed(-16#13DD#, 16),
     to_signed(-16#13C7#, 16), to_signed(-16#13B1#, 16), to_signed(-16#139C#, 16), to_signed(-16#1386#, 16),
     to_signed(-16#1371#, 16), to_signed(-16#135B#, 16), to_signed(-16#1346#, 16), to_signed(-16#1331#, 16),
     to_signed(-16#131C#, 16), to_signed(-16#1307#, 16), to_signed(-16#12F2#, 16), to_signed(-16#12DE#, 16),
     to_signed(-16#12C9#, 16), to_signed(-16#12B5#, 16), to_signed(-16#12A1#, 16), to_signed(-16#128D#, 16),
     to_signed(-16#1279#, 16), to_signed(-16#1265#, 16), to_signed(-16#1252#, 16), to_signed(-16#123E#, 16),
     to_signed(-16#122B#, 16), to_signed(-16#1217#, 16), to_signed(-16#1204#, 16), to_signed(-16#11F1#, 16),
     to_signed(-16#11DE#, 16), to_signed(-16#11CB#, 16), to_signed(-16#11B9#, 16), to_signed(-16#11A6#, 16),
     to_signed(-16#1194#, 16), to_signed(-16#1181#, 16), to_signed(-16#116F#, 16), to_signed(-16#115D#, 16),
     to_signed(-16#114B#, 16), to_signed(-16#1139#, 16), to_signed(-16#1127#, 16), to_signed(-16#1115#, 16),
     to_signed(-16#1104#, 16), to_signed(-16#10F2#, 16), to_signed(-16#10E1#, 16), to_signed(-16#10D0#, 16),
     to_signed(-16#10BE#, 16), to_signed(-16#10AD#, 16), to_signed(-16#109C#, 16), to_signed(-16#108B#, 16),
     to_signed(-16#107B#, 16), to_signed(-16#106A#, 16), to_signed(-16#1059#, 16), to_signed(-16#1049#, 16),
     to_signed(-16#1039#, 16), to_signed(-16#1028#, 16), to_signed(-16#1018#, 16), to_signed(-16#1008#, 16));  -- sfix16 [256]
  CONSTANT alpha1_D_Lookup_Table1_table_data : vector_of_signed16(0 TO 255) := 
    (to_signed(16#7FC0#, 16), to_signed(16#7F41#, 16), to_signed(16#7EC3#, 16), to_signed(16#7E46#, 16),
     to_signed(16#7DCA#, 16), to_signed(16#7D4F#, 16), to_signed(16#7CD5#, 16), to_signed(16#7C5B#, 16),
     to_signed(16#7BE3#, 16), to_signed(16#7B6C#, 16), to_signed(16#7AF5#, 16), to_signed(16#7A7F#, 16),
     to_signed(16#7A0B#, 16), to_signed(16#7997#, 16), to_signed(16#7924#, 16), to_signed(16#78B1#, 16),
     to_signed(16#7840#, 16), to_signed(16#77CF#, 16), to_signed(16#7760#, 16), to_signed(16#76F1#, 16),
     to_signed(16#7683#, 16), to_signed(16#7615#, 16), to_signed(16#75A9#, 16), to_signed(16#753D#, 16),
     to_signed(16#74D2#, 16), to_signed(16#7468#, 16), to_signed(16#73FE#, 16), to_signed(16#7395#, 16),
     to_signed(16#732D#, 16), to_signed(16#72C6#, 16), to_signed(16#7260#, 16), to_signed(16#71FA#, 16),
     to_signed(16#7195#, 16), to_signed(16#7130#, 16), to_signed(16#70CC#, 16), to_signed(16#7069#, 16),
     to_signed(16#7007#, 16), to_signed(16#6FA5#, 16), to_signed(16#6F44#, 16), to_signed(16#6EE4#, 16),
     to_signed(16#6E84#, 16), to_signed(16#6E25#, 16), to_signed(16#6DC7#, 16), to_signed(16#6D69#, 16),
     to_signed(16#6D0C#, 16), to_signed(16#6CAF#, 16), to_signed(16#6C53#, 16), to_signed(16#6BF8#, 16),
     to_signed(16#6B9D#, 16), to_signed(16#6B43#, 16), to_signed(16#6AE9#, 16), to_signed(16#6A90#, 16),
     to_signed(16#6A38#, 16), to_signed(16#69E0#, 16), to_signed(16#6988#, 16), to_signed(16#6932#, 16),
     to_signed(16#68DC#, 16), to_signed(16#6886#, 16), to_signed(16#6831#, 16), to_signed(16#67DC#, 16),
     to_signed(16#6788#, 16), to_signed(16#6735#, 16), to_signed(16#66E2#, 16), to_signed(16#668F#, 16),
     to_signed(16#663E#, 16), to_signed(16#65EC#, 16), to_signed(16#659B#, 16), to_signed(16#654B#, 16),
     to_signed(16#64FB#, 16), to_signed(16#64AB#, 16), to_signed(16#645D#, 16), to_signed(16#640E#, 16),
     to_signed(16#63C0#, 16), to_signed(16#6373#, 16), to_signed(16#6326#, 16), to_signed(16#62D9#, 16),
     to_signed(16#628D#, 16), to_signed(16#6241#, 16), to_signed(16#61F6#, 16), to_signed(16#61AB#, 16),
     to_signed(16#6161#, 16), to_signed(16#6117#, 16), to_signed(16#60CE#, 16), to_signed(16#6085#, 16),
     to_signed(16#603C#, 16), to_signed(16#5FF4#, 16), to_signed(16#5FAC#, 16), to_signed(16#5F65#, 16),
     to_signed(16#5F1E#, 16), to_signed(16#5ED8#, 16), to_signed(16#5E92#, 16), to_signed(16#5E4C#, 16),
     to_signed(16#5E07#, 16), to_signed(16#5DC2#, 16), to_signed(16#5D7D#, 16), to_signed(16#5D39#, 16),
     to_signed(16#5CF5#, 16), to_signed(16#5CB2#, 16), to_signed(16#5C6F#, 16), to_signed(16#5C2D#, 16),
     to_signed(16#5BEA#, 16), to_signed(16#5BA9#, 16), to_signed(16#5B67#, 16), to_signed(16#5B26#, 16),
     to_signed(16#5AE5#, 16), to_signed(16#5AA5#, 16), to_signed(16#5A65#, 16), to_signed(16#5A25#, 16),
     to_signed(16#59E6#, 16), to_signed(16#59A7#, 16), to_signed(16#5968#, 16), to_signed(16#592A#, 16),
     to_signed(16#58EC#, 16), to_signed(16#58AF#, 16), to_signed(16#5871#, 16), to_signed(16#5834#, 16),
     to_signed(16#57F8#, 16), to_signed(16#57BB#, 16), to_signed(16#577F#, 16), to_signed(16#5744#, 16),
     to_signed(16#5709#, 16), to_signed(16#56CD#, 16), to_signed(16#5693#, 16), to_signed(16#5658#, 16),
     to_signed(16#561E#, 16), to_signed(16#55E4#, 16), to_signed(16#55AB#, 16), to_signed(16#5572#, 16),
     to_signed(16#5539#, 16), to_signed(16#5500#, 16), to_signed(16#54C8#, 16), to_signed(16#5490#, 16),
     to_signed(16#5458#, 16), to_signed(16#5421#, 16), to_signed(16#53EA#, 16), to_signed(16#53B3#, 16),
     to_signed(16#537C#, 16), to_signed(16#5346#, 16), to_signed(16#5310#, 16), to_signed(16#52DA#, 16),
     to_signed(16#52A5#, 16), to_signed(16#526F#, 16), to_signed(16#523A#, 16), to_signed(16#5206#, 16),
     to_signed(16#51D1#, 16), to_signed(16#519D#, 16), to_signed(16#5169#, 16), to_signed(16#5136#, 16),
     to_signed(16#5102#, 16), to_signed(16#50CF#, 16), to_signed(16#509C#, 16), to_signed(16#506A#, 16),
     to_signed(16#5037#, 16), to_signed(16#5005#, 16), to_signed(16#4FD3#, 16), to_signed(16#4FA1#, 16),
     to_signed(16#4F70#, 16), to_signed(16#4F3F#, 16), to_signed(16#4F0E#, 16), to_signed(16#4EDD#, 16),
     to_signed(16#4EAD#, 16), to_signed(16#4E7C#, 16), to_signed(16#4E4C#, 16), to_signed(16#4E1D#, 16),
     to_signed(16#4DED#, 16), to_signed(16#4DBE#, 16), to_signed(16#4D8F#, 16), to_signed(16#4D60#, 16),
     to_signed(16#4D31#, 16), to_signed(16#4D03#, 16), to_signed(16#4CD4#, 16), to_signed(16#4CA6#, 16),
     to_signed(16#4C79#, 16), to_signed(16#4C4B#, 16), to_signed(16#4C1E#, 16), to_signed(16#4BF1#, 16),
     to_signed(16#4BC4#, 16), to_signed(16#4B97#, 16), to_signed(16#4B6A#, 16), to_signed(16#4B3E#, 16),
     to_signed(16#4B12#, 16), to_signed(16#4AE6#, 16), to_signed(16#4ABA#, 16), to_signed(16#4A8F#, 16),
     to_signed(16#4A63#, 16), to_signed(16#4A38#, 16), to_signed(16#4A0D#, 16), to_signed(16#49E3#, 16),
     to_signed(16#49B8#, 16), to_signed(16#498E#, 16), to_signed(16#4963#, 16), to_signed(16#493A#, 16),
     to_signed(16#4910#, 16), to_signed(16#48E6#, 16), to_signed(16#48BD#, 16), to_signed(16#4893#, 16),
     to_signed(16#486A#, 16), to_signed(16#4841#, 16), to_signed(16#4819#, 16), to_signed(16#47F0#, 16),
     to_signed(16#47C8#, 16), to_signed(16#47A0#, 16), to_signed(16#4778#, 16), to_signed(16#4750#, 16),
     to_signed(16#4728#, 16), to_signed(16#4701#, 16), to_signed(16#46DA#, 16), to_signed(16#46B2#, 16),
     to_signed(16#468B#, 16), to_signed(16#4665#, 16), to_signed(16#463E#, 16), to_signed(16#4618#, 16),
     to_signed(16#45F1#, 16), to_signed(16#45CB#, 16), to_signed(16#45A5#, 16), to_signed(16#457F#, 16),
     to_signed(16#455A#, 16), to_signed(16#4534#, 16), to_signed(16#450F#, 16), to_signed(16#44EA#, 16),
     to_signed(16#44C5#, 16), to_signed(16#44A0#, 16), to_signed(16#447B#, 16), to_signed(16#4456#, 16),
     to_signed(16#4432#, 16), to_signed(16#440E#, 16), to_signed(16#43EA#, 16), to_signed(16#43C6#, 16),
     to_signed(16#43A2#, 16), to_signed(16#437E#, 16), to_signed(16#435B#, 16), to_signed(16#4337#, 16),
     to_signed(16#4314#, 16), to_signed(16#42F1#, 16), to_signed(16#42CE#, 16), to_signed(16#42AB#, 16),
     to_signed(16#4289#, 16), to_signed(16#4266#, 16), to_signed(16#4244#, 16), to_signed(16#4222#, 16),
     to_signed(16#41FF#, 16), to_signed(16#41DE#, 16), to_signed(16#41BC#, 16), to_signed(16#419A#, 16),
     to_signed(16#4178#, 16), to_signed(16#4157#, 16), to_signed(16#4136#, 16), to_signed(16#4115#, 16),
     to_signed(16#40F4#, 16), to_signed(16#40D3#, 16), to_signed(16#40B2#, 16), to_signed(16#4091#, 16),
     to_signed(16#4071#, 16), to_signed(16#4050#, 16), to_signed(16#4030#, 16), to_signed(16#4010#, 16));  -- sfix16 [256]
  CONSTANT alpha1_D_Lookup_Table2_table_data : vector_of_signed32(0 TO 255) := 
    (to_signed(-1608519320, 32), to_signed(-1604341318, 32), to_signed(-1600179509, 32),
     to_signed(-1596033770, 32), to_signed(-1591903976, 32), to_signed(-1587790005, 32),
     to_signed(-1583691737, 32), to_signed(-1579609051, 32), to_signed(-1575541830, 32),
     to_signed(-1571489957, 32), to_signed(-1567453317, 32), to_signed(-1563431796, 32),
     to_signed(-1559425281, 32), to_signed(-1555433659, 32), to_signed(-1551456822, 32),
     to_signed(-1547494659, 32), to_signed(-1543547063, 32), to_signed(-1539613928, 32),
     to_signed(-1535695147, 32), to_signed(-1531790616, 32), to_signed(-1527900232, 32),
     to_signed(-1524023893, 32), to_signed(-1520161498, 32), to_signed(-1516312947, 32),
     to_signed(-1512478141, 32), to_signed(-1508656981, 32), to_signed(-1504849372, 32),
     to_signed(-1501055218, 32), to_signed(-1497274423, 32), to_signed(-1493506894, 32),
     to_signed(-1489752539, 32), to_signed(-1486011265, 32), to_signed(-1482282982, 32),
     to_signed(-1478567599, 32), to_signed(-1474865028, 32), to_signed(-1471175181, 32),
     to_signed(-1467497971, 32), to_signed(-1463833311, 32), to_signed(-1460181115, 32),
     to_signed(-1456541300, 32), to_signed(-1452913782, 32), to_signed(-1449298478, 32),
     to_signed(-1445695306, 32), to_signed(-1442104184, 32), to_signed(-1438525033, 32),
     to_signed(-1434957773, 32), to_signed(-1431402325, 32), to_signed(-1427858612, 32),
     to_signed(-1424326555, 32), to_signed(-1420806079, 32), to_signed(-1417297108, 32),
     to_signed(-1413799567, 32), to_signed(-1410313381, 32), to_signed(-1406838478, 32),
     to_signed(-1403374784, 32), to_signed(-1399922228, 32), to_signed(-1396480738, 32),
     to_signed(-1393050242, 32), to_signed(-1389630672, 32), to_signed(-1386221958, 32),
     to_signed(-1382824031, 32), to_signed(-1379436823, 32), to_signed(-1376060267, 32),
     to_signed(-1372694295, 32), to_signed(-1369338843, 32), to_signed(-1365993843, 32),
     to_signed(-1362659232, 32), to_signed(-1359334944, 32), to_signed(-1356020917, 32),
     to_signed(-1352717087, 32), to_signed(-1349423392, 32), to_signed(-1346139769, 32),
     to_signed(-1342866157, 32), to_signed(-1339602495, 32), to_signed(-1336348723, 32),
     to_signed(-1333104782, 32), to_signed(-1329870611, 32), to_signed(-1326646153, 32),
     to_signed(-1323431348, 32), to_signed(-1320226140, 32), to_signed(-1317030472, 32),
     to_signed(-1313844286, 32), to_signed(-1310667527, 32), to_signed(-1307500139, 32),
     to_signed(-1304342067, 32), to_signed(-1301193256, 32), to_signed(-1298053653, 32),
     to_signed(-1294923202, 32), to_signed(-1291801852, 32), to_signed(-1288689549, 32),
     to_signed(-1285586242, 32), to_signed(-1282491877, 32), to_signed(-1279406405, 32),
     to_signed(-1276329774, 32), to_signed(-1273261932, 32), to_signed(-1270202832, 32),
     to_signed(-1267152422, 32), to_signed(-1264110653, 32), to_signed(-1261077477, 32),
     to_signed(-1258052845, 32), to_signed(-1255036710, 32), to_signed(-1252029022, 32),
     to_signed(-1249029737, 32), to_signed(-1246038806, 32), to_signed(-1243056183, 32),
     to_signed(-1240081822, 32), to_signed(-1237115678, 32), to_signed(-1234157705, 32),
     to_signed(-1231207858, 32), to_signed(-1228266094, 32), to_signed(-1225332366, 32),
     to_signed(-1222406633, 32), to_signed(-1219488850, 32), to_signed(-1216578974, 32),
     to_signed(-1213676963, 32), to_signed(-1210782774, 32), to_signed(-1207896366, 32),
     to_signed(-1205017695, 32), to_signed(-1202146722, 32), to_signed(-1199283404, 32),
     to_signed(-1196427702, 32), to_signed(-1193579575, 32), to_signed(-1190738982, 32),
     to_signed(-1187905885, 32), to_signed(-1185080242, 32), to_signed(-1182262017, 32),
     to_signed(-1179451169, 32), to_signed(-1176647660, 32), to_signed(-1173851452, 32),
     to_signed(-1171062506, 32), to_signed(-1168280786, 32), to_signed(-1165506254, 32),
     to_signed(-1162738873, 32), to_signed(-1159978606, 32), to_signed(-1157225417, 32),
     to_signed(-1154479269, 32), to_signed(-1151740126, 32), to_signed(-1149007954, 32),
     to_signed(-1146282715, 32), to_signed(-1143564377, 32), to_signed(-1140852902, 32),
     to_signed(-1138148258, 32), to_signed(-1135450409, 32), to_signed(-1132759322, 32),
     to_signed(-1130074963, 32), to_signed(-1127397297, 32), to_signed(-1124726293, 32),
     to_signed(-1122061916, 32), to_signed(-1119404135, 32), to_signed(-1116752916, 32),
     to_signed(-1114108227, 32), to_signed(-1111470036, 32), to_signed(-1108838311, 32),
     to_signed(-1106213021, 32), to_signed(-1103594134, 32), to_signed(-1100981619, 32),
     to_signed(-1098375445, 32), to_signed(-1095775582, 32), to_signed(-1093181998, 32),
     to_signed(-1090594664, 32), to_signed(-1088013549, 32), to_signed(-1085438625, 32),
     to_signed(-1082869860, 32), to_signed(-1080307226, 32), to_signed(-1077750694, 32),
     to_signed(-1075200234, 32), to_signed(-1072655818, 32), to_signed(-1070117417, 32),
     to_signed(-1067585003, 32), to_signed(-1065058547, 32), to_signed(-1062538023, 32),
     to_signed(-1060023401, 32), to_signed(-1057514654, 32), to_signed(-1055011756, 32),
     to_signed(-1052514678, 32), to_signed(-1050023393, 32), to_signed(-1047537876, 32),
     to_signed(-1045058099, 32), to_signed(-1042584036, 32), to_signed(-1040115660, 32),
     to_signed(-1037652946, 32), to_signed(-1035195867, 32), to_signed(-1032744398, 32),
     to_signed(-1030298513, 32), to_signed(-1027858187, 32), to_signed(-1025423394, 32),
     to_signed(-1022994111, 32), to_signed(-1020570311, 32), to_signed(-1018151970, 32),
     to_signed(-1015739063, 32), to_signed(-1013331567, 32), to_signed(-1010929456, 32),
     to_signed(-1008532708, 32), to_signed(-1006141297, 32), to_signed(-1003755201, 32),
     to_signed(-1001374395, 32), to_signed(-998998857, 32), to_signed(-996628562, 32), to_signed(-994263489, 32),
     to_signed(-991903613, 32), to_signed(-989548913, 32), to_signed(-987199365, 32), to_signed(-984854948, 32),
     to_signed(-982515638, 32), to_signed(-980181413, 32), to_signed(-977852252, 32), to_signed(-975528132, 32),
     to_signed(-973209032, 32), to_signed(-970894930, 32), to_signed(-968585805, 32), to_signed(-966281635, 32),
     to_signed(-963982399, 32), to_signed(-961688076, 32), to_signed(-959398644, 32), to_signed(-957114084, 32),
     to_signed(-954834375, 32), to_signed(-952559495, 32), to_signed(-950289425, 32), to_signed(-948024144, 32),
     to_signed(-945763632, 32), to_signed(-943507869, 32), to_signed(-941256835, 32), to_signed(-939010510, 32),
     to_signed(-936768875, 32), to_signed(-934531910, 32), to_signed(-932299596, 32), to_signed(-930071913, 32),
     to_signed(-927848842, 32), to_signed(-925630365, 32), to_signed(-923416461, 32), to_signed(-921207113, 32),
     to_signed(-919002302, 32), to_signed(-916802009, 32), to_signed(-914606215, 32), to_signed(-912414902, 32),
     to_signed(-910228053, 32), to_signed(-908045648, 32), to_signed(-905867670, 32), to_signed(-903694101, 32),
     to_signed(-901524923, 32), to_signed(-899360119, 32), to_signed(-897199670, 32), to_signed(-895043559, 32),
     to_signed(-892891769, 32), to_signed(-890744283, 32), to_signed(-888601084, 32), to_signed(-886462153, 32),
     to_signed(-884327475, 32), to_signed(-882197033, 32), to_signed(-880070809, 32), to_signed(-877948787, 32),
     to_signed(-875830950, 32), to_signed(-873717283, 32), to_signed(-871607768, 32), to_signed(-869502390, 32),
     to_signed(-867401131, 32));  -- sfix32 [256]

  -- Signals
  SIGNAL x_e_unsigned                     : unsigned(48 DOWNTO 0);  -- ufix49_En48
  SIGNAL Data_Type_Conversion1_out1       : unsigned(15 DOWNTO 0);  -- ufix16_En15
  SIGNAL x_e_1                            : unsigned(48 DOWNTO 0);  -- ufix49_En40
  SIGNAL u016                             : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL alpha1_D_Lookup_Table_k          : unsigned(7 DOWNTO 0);  -- ufix8
  SIGNAL c2                               : signed(15 DOWNTO 0);  -- sfix16_En15
  SIGNAL Product_cast                     : signed(16 DOWNTO 0);  -- sfix17_En15
  SIGNAL Product_mul_temp                 : signed(32 DOWNTO 0);  -- sfix33_En30
  SIGNAL Product_out1                     : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL Product_out1_1                   : signed(15 DOWNTO 0);  -- sfix16_En15
  SIGNAL alpha1_D_Lookup_Table1_k         : unsigned(7 DOWNTO 0);  -- ufix8
  SIGNAL c1                               : signed(15 DOWNTO 0);  -- sfix16_En14
  SIGNAL Add_add_cast                     : signed(17 DOWNTO 0);  -- sfix18_En15
  SIGNAL Add_add_cast_1                   : signed(17 DOWNTO 0);  -- sfix18_En15
  SIGNAL Add_add_temp                     : signed(17 DOWNTO 0);  -- sfix18_En15
  SIGNAL Add_out1                         : signed(15 DOWNTO 0);  -- sfix16_En14
  SIGNAL Product1_cast                    : signed(16 DOWNTO 0);  -- sfix17_En15
  SIGNAL Product1_mul_temp                : signed(32 DOWNTO 0);  -- sfix33_En29
  SIGNAL Product1_out1                    : signed(31 DOWNTO 0);  -- sfix32_En29
  SIGNAL Product1_out1_1                  : signed(30 DOWNTO 0);  -- sfix31_En27
  SIGNAL alpha1_D_Lookup_Table2_k         : unsigned(7 DOWNTO 0);  -- ufix8
  SIGNAL c0                               : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL Add1_add_cast                    : signed(34 DOWNTO 0);  -- sfix35_En30
  SIGNAL Add1_add_cast_1                  : signed(34 DOWNTO 0);  -- sfix35_En30
  SIGNAL Add1_add_temp                    : signed(34 DOWNTO 0);  -- sfix35_En30
  SIGNAL Add1_out1                        : signed(30 DOWNTO 0);  -- sfix31_En27

BEGIN
  x_e_unsigned <= unsigned(x_e);

  Data_Type_Conversion1_out1 <= x_e_unsigned(48 DOWNTO 33);

  x_e_1 <= x_e_unsigned;

  u016 <= x_e_1(47 DOWNTO 40);

  
  alpha1_D_Lookup_Table_k <= to_unsigned(16#00#, 8) WHEN u016 = to_unsigned(16#00#, 8) ELSE
      to_unsigned(16#FF#, 8) WHEN u016 = to_unsigned(16#FF#, 8) ELSE
      u016;
  c2 <= alpha1_D_Lookup_Table_table_data(to_integer(alpha1_D_Lookup_Table_k));

  Product_cast <= signed(resize(Data_Type_Conversion1_out1, 17));
  Product_mul_temp <= Product_cast * c2;
  Product_out1 <= Product_mul_temp(31 DOWNTO 0);

  Product_out1_1 <= Product_out1(30 DOWNTO 15);

  
  alpha1_D_Lookup_Table1_k <= to_unsigned(16#00#, 8) WHEN u016 = to_unsigned(16#00#, 8) ELSE
      to_unsigned(16#FF#, 8) WHEN u016 = to_unsigned(16#FF#, 8) ELSE
      u016;
  c1 <= alpha1_D_Lookup_Table1_table_data(to_integer(alpha1_D_Lookup_Table1_k));

  Add_add_cast <= resize(Product_out1_1, 18);
  Add_add_cast_1 <= resize(c1 & '0', 18);
  Add_add_temp <= Add_add_cast + Add_add_cast_1;
  Add_out1 <= Add_add_temp(16 DOWNTO 1);

  Product1_cast <= signed(resize(Data_Type_Conversion1_out1, 17));
  Product1_mul_temp <= Product1_cast * Add_out1;
  Product1_out1 <= Product1_mul_temp(31 DOWNTO 0);

  Product1_out1_1 <= resize(Product1_out1(31 DOWNTO 2), 31);

  
  alpha1_D_Lookup_Table2_k <= to_unsigned(16#00#, 8) WHEN u016 = to_unsigned(16#00#, 8) ELSE
      to_unsigned(16#FF#, 8) WHEN u016 = to_unsigned(16#FF#, 8) ELSE
      u016;
  c0 <= alpha1_D_Lookup_Table2_table_data(to_integer(alpha1_D_Lookup_Table2_k));

  Add1_add_cast <= resize(Product1_out1_1 & '0' & '0' & '0', 35);
  Add1_add_cast_1 <= resize(c0, 35);
  Add1_add_temp <= Add1_add_cast + Add1_add_cast_1;
  Add1_out1 <= Add1_add_temp(33 DOWNTO 3);

  y_e <= std_logic_vector(Add1_out1);

  exp_eOut <= exp_eIn;

END rtl;

