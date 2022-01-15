library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity clock_driver is
    port (
        clk:in std_logic;
        divided_clk_50hz: out std_logic;
        divided_clk_1000hz: out std_logic
    );
end entity clock_driver;

architecture rtl of clock_driver is
    signal count1:integer:=0;
    signal count2:integer:=0;
    signal Clock_50:std_logic:='0';
    signal clock_1000:std_logic:='0';
begin
    process(clk)
    begin
        if clk='1' and clk'event then
            count1<=count1+1;
            if (count1 = 1250000-1) then
                Clock_50 <= not(Clock_50);
                count1 <= 0;
            end if;
        end if;
    end process;
    
    process(clk)
    begin
        if clk='1' and clk'event then
            count2<=count2+1;
            if (count2 = 1250000-1) then --1250000
                clock_1000 <= not(clock_1000);
                count2 <= 0;
            end if;
        end if;
    end process;

    divided_clk_50hz <= Clock_50;
    divided_clk_1000hz <= clock_1000;
--    divided_clk_1000hz  <= clk;
    
end architecture rtl;