----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.09.2025 14:48:14
-- Design Name: 
-- Module Name: tb1 - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb1 is
--  Port ( );
end tb1;

architecture Behavioral of tb1 is


    component mt55l512y36f
        port (
            Dq        : inout std_logic_vector (35 downto 0);  -- Data I/O
            Addr      : in    std_logic_vector (18 DOWNTO 0);  -- Address
            Lbo_n     : in    std_logic;                       -- Burst Mode
            Clk       : in    std_logic;                       -- Clk
            Cke_n     : in    std_logic;                       -- Cke#
            Ld_n      : in    std_logic;                       -- Adv/Ld#
            Bwa_n     : in    std_logic;                       -- Bwa#
            Bwb_n     : in    std_logic;                       -- BWb#
            Bwc_n     : in    std_logic;                       -- Bwc#
            Bwd_n     : in    std_logic;                       -- BWd#
            Rw_n      : in    std_logic;                       -- RW#
            Oe_n      : in    std_logic;                       -- OE#
            Ce_n      : in    std_logic;                       -- CE#
            Ce2_n     : in    std_logic;                       -- CE2#
            Ce2       : in    std_logic;                       -- CE2
            Zz        : in    std_logic                        -- Snooze Mode
        );
    end component;
    
    component controller
    
        port (
            -- user side --
            U_data_i  : in    std_logic_vector(35 downto 0);
            U_data_o  : out   std_logic_vector(35 downto 0);
            Read      : in    std_logic;
            Write     : in    std_logic;
            Burst     : in    std_logic;
            U_address : in    std_logic_vector(18 downto 0);
            Reset     : in    std_logic;
            Clock     : in    std_logic;
            ---------------
        
            -- external SRAM side --
            Data    : inout std_logic_vector (35 downto 0);  -- Data I/O
            Address : out   std_logic_vector (18 downto 0);  -- Address
            Lbo_n   : out   std_logic;                       -- Burst Mode
            Clk     : out   std_logic;                       -- Clk
            Cke_n   : out   std_logic;                       -- Cke#
            Ld_n    : out   std_logic;                       -- Adv/Ld#
            Bwa_n   : out   std_logic;                       -- Bwa#
            Bwb_n   : out   std_logic;                       -- BWb#
            Bwc_n   : out   std_logic;                       -- Bwc#
            Bwd_n   : out   std_logic;                       -- BWd#
            Rw_n    : out   std_logic;                       -- RW#
            Oe_n    : out   std_logic;                       -- OE#
            Ce_n    : out   std_logic;                       -- CE#
            Ce2_n   : out   std_logic;                       -- CE2#
            Ce2     : out   std_logic;                       -- CE2
            Zz      : out   std_logic                        -- Snooze Mode
            ------------------------
        );

    end component;

    constant clock_period: time := 10 ns;
    signal clock_init: STD_LOGIC;
    
    signal s_U_data_i  : std_logic_vector(35 downto 0);
    signal s_U_data_o  : std_logic_vector(35 downto 0);
    signal s_Read      : std_logic;
    signal s_Write     : std_logic;
    signal s_Burst     : std_logic;
    signal s_U_address : std_logic_vector(18 downto 0);
    signal s_Reset     : std_logic;
    signal s_Clock     : std_logic;
    
    signal s_Data    : std_logic_vector (35 downto 0);  -- Data I/O
    signal s_Address : std_logic_vector (18 downto 0);  -- Address
    signal s_Lbo_n   : std_logic;                       -- Burst Mode
    signal s_Clk     : std_logic;                       -- Clk
    signal s_Cke_n   : std_logic;                       -- Cke#
    signal s_Ld_n    : std_logic;                       -- Adv/Ld#
    signal s_Bwa_n   : std_logic;                       -- Bwa#
    signal s_Bwb_n   : std_logic;                       -- BWb#
    signal s_Bwc_n   : std_logic;                       -- Bwc#
    signal s_Bwd_n   : std_logic;                       -- BWd#
    signal s_Rw_n    : std_logic;                       -- RW#
    signal s_Oe_n    : std_logic;                       -- OE#
    signal s_Ce_n    : std_logic;                       -- CE#
    signal s_Ce2_n   : std_logic;                       -- CE2#
    signal s_Ce2     : std_logic;                       -- CE2
    signal s_Zz      : std_logic;                       -- Snooze Mode


    begin
    
    controller_port_map: controller
        port map (
            U_data_i  => s_U_data_i,
            U_data_o  => s_U_data_o,
            Read      => s_Read,
            Write     => s_Write,
            Burst     => s_Burst,
            U_address => s_U_address,
            Reset     => s_Reset,
            Clock     => s_Clock,
                    
            Data    => s_Data,
            Address => s_Address,
            Lbo_n   => s_Lbo_n,
            Clk     => s_Clk,
            Cke_n   => s_Cke_n,
            Ld_n    => s_Ld_n,
            Bwa_n   => s_Bwa_n,
            Bwb_n   => s_Bwb_n,
            Bwc_n   => s_Bwc_n,
            Bwd_n   => s_Bwd_n,
            Rw_n    => s_Rw_n,
            Oe_n    => s_Oe_n,
            Ce_n    => s_Ce_n,
            Ce2_n   => s_Ce2_n,
            Ce2     => s_Ce2,
            Zz      => s_Zz
        );
        
    mt55l512y36f_port_map: mt55l512y36f
        port map (
            Dq      => s_Data,
            Addr    => s_Address,
            Lbo_n   => s_Lbo_n,
            Clk     => s_Clk,
            Cke_n   => s_Cke_n,
            Ld_n    => s_Ld_n,
            Bwa_n   => s_Bwa_n,
            Bwb_n   => s_Bwb_n,
            Bwc_n   => s_Bwc_n,
            Bwd_n   => s_Bwd_n,
            Rw_n    => s_Rw_n,
            Oe_n    => s_Oe_n,
            Ce_n    => s_Ce_n,
            Ce2_n   => s_Ce2_n,
            Ce2     => s_Ce2,
            Zz      => s_Zz
        );


    clocking: process
    begin
        s_Clock <= '0'; 
        wait for clock_period/2;
        s_Clock <= clock_init;
        wait for clock_period/2;
    end process;
    
    
    stimulus: process
    begin
        clock_init <= '1';
        s_Reset <= '1';
        wait for 50 ns;
        
        wait until (s_Clock'event and S_clock = '1');
        wait for clock_period/4;
    
        s_U_data_i <= x"ABCDE1234";
        s_U_address <= std_logic_vector(to_unsigned(16#6A93C#, 19));
        s_Read <= '0';
        s_Write <= '0';
        s_Burst <= '0';
        s_Reset <= '0';
        
        
        wait for 10 * clock_period;
        
        wait until (s_Clock'event and S_clock = '1');
        wait for clock_period/4;
        
        s_Write <= '1';
        
        wait for 2 * clock_period;
        
        wait until (s_Clock'event and S_clock = '1');
        wait for clock_period/4;
        
        s_U_address <= std_logic_vector(to_unsigned(16#5F21A#, 19));
        
        wait for 2 * clock_period;
        
        wait until (s_Clock'event and S_clock = '1');
        wait for clock_period/4;
        
        s_Write <= '0';
        s_Read <= '1';
        s_U_address <= std_logic_vector(to_unsigned(16#6A93C#, 19));
        
        wait for 2 * clock_period;
        
        wait until (s_Clock'event and S_clock = '1');
        wait for clock_period/4;
        
        s_U_address <= std_logic_vector(to_unsigned(16#5F21A#, 19));
        
        wait for 2 * clock_period;
        
        wait until (s_Clock'event and S_clock = '1');
        wait for clock_period/4;
        
        s_U_address <= std_logic_vector(to_unsigned(16#6A93C#, 19));
        s_U_data_i <= x"001ACE42E";
        s_Read <= '0';
        s_Write <= '1';
        s_Burst <= '1';
        wait for clock_period;
        
        s_U_data_i <= x"001ACE42D";
        wait for clock_period;
        
        s_U_data_i <= x"001ACE42C";
        wait for clock_period;
        
        s_U_data_i <= x"001ACE42B";
        wait for clock_period;
        
        wait until (s_Clock'event and S_clock = '1');
        wait for clock_period/4;
        
        s_Write <= '0';
        s_Read <= '1';
        s_U_address <= std_logic_vector(to_unsigned(16#6A93C#, 19));
        
        wait for 4 * clock_period;
             
        wait until (s_Clock'event and S_clock = '1');
        wait for clock_period/4;
        
        clock_init <= '0';
        s_Reset <= '1';

    end process;

end Behavioral;
