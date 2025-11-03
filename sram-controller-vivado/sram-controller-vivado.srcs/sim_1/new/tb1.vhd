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
            U_address : in    std_logic_vector(1 downto 0);
            Reset     : in    std_logic;
            Clock     : in    std_logic;
            ---------------
        
            -- external SRAM side --
            Data      : inout std_logic_vector (35 downto 0);  -- Data I/O
            Address   : out   std_logic_vector (18 downto 0);  -- Address
            Lbo_n     : out   std_logic;                       -- Burst Mode
            Clk       : out   std_logic;                       -- Clk
            Cke_n     : out   std_logic;                       -- Cke#
            Ld_n      : out   std_logic;                       -- Adv/Ld#
            Bwa_n     : out   std_logic;                       -- Bwa#
            Bwb_n     : out   std_logic;                       -- BWb#
            Bwc_n     : out   std_logic;                       -- Bwc#
            Bwd_n     : out   std_logic;                       -- BWd#
            Rw_n      : out   std_logic;                       -- RW#
            Oe_n      : out   std_logic;                       -- OE#
            Ce_n      : out   std_logic;                       -- CE#
            Ce2_n     : out   std_logic;                       -- CE2#
            Ce2       : out   std_logic;                       -- CE2
            Zz        : out   std_logic                        -- Snooze Mode
            ------------------------
        );

    end component;

    constant clock_period: time := 10 ns;
    signal clock_init: STD_LOGIC;

    begin


end Behavioral;
