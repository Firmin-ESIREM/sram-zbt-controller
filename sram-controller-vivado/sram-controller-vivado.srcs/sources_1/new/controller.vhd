----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.09.2025 14:08:59
-- Design Name: 
-- Module Name: controller - Behavioral
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

entity controller is

    generic (
        addr_bits : integer := 19;
        data_bits : integer := 36
    );
    
    port (
        -- user side
        U_data_i  : in    std_logic_vector(data_bits - 1 downto 0);
        U_data_o  : out   std_logic_vector(data_bits - 1 downto 0);
        Read      : in    std_logic;
        Write     : in    std_logic;
        U_address : in    std_logic_vector(addr_bits - 1 downto 0);
        
        
        -- external SRAM side
        Data      : inout std_logic_vector (data_bits - 1 downto 0);   -- Data I/O
        Address   : out   std_logic_vector (addr_bits - 1 downto 0);   -- Address
        Lbo_n     : out   std_logic;                                   -- Burst Mode
        Clk       : out   std_logic;                                   -- Clk
        Cke_n     : out   std_logic;                                   -- Cke#
        Ld_n      : out   std_logic;                                   -- Adv/Ld#
        Bwa_n     : out   std_logic;                                   -- Bwa#
        Bwb_n     : out   std_logic;                                   -- BWb#
        Bwc_n     : out   std_logic;                                   -- Bwc#
        Bwd_n     : out   std_logic;                                   -- BWd#
        Rw_n      : out   std_logic;                                   -- RW#
        Oe_n      : out   std_logic;                                   -- OE#
        Ce_n      : out   std_logic;                                   -- CE#
        Ce2_n     : out   std_logic;                                   -- CE2#
        Ce2       : out   std_logic;                                   -- CE2
        Zz        : out   std_logic                                    -- Snooze Mode
    );

end controller;

architecture Behavioral of controller is







begin

end Behavioral;
