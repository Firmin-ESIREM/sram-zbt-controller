----------------------------------------------------------------------------------
-- Company: Polytech Dijon - Universite Bourgogne Europe
-- Engineer: Firmin Launay <Firmin_Launay@etu.ube.fr>
-- 
-- Create Date: 23.09.2025
-- Design Name: SRAM ZBT Controller - Vivado VHDL implementation
-- Module Name: controller - Behavioral
-- Project Name: SRAM ZBT Controller
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- 
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

end controller;

architecture Behavioral of controller is

    component trigger_io
        port (
            SORTIE      : out   std_logic;
            CLK, nRESET : in    std_logic;
            TRIG        : in    std_logic;
            E_S         : inout std_logic;
            ENTREE      : in    std_logic
        );
    end component;
    
    component d_latch
        generic (
            bus_width : integer := 8
        );
        Port (
            D     : in std_logic_vector (bus_width - 1 downto 0);
            Q     : out std_logic_vector (bus_width - 1 downto 0);
            CLK   : in std_logic;
            EN    : in std_logic;
            RESET : in std_logic
        );
    end component;

    type t_state is (S_RESET, S_IDLE, S_READ_SRAM_NO_BURST, S_WRITE_SRAM_NO_BURST, S_READ_SRAM_BURST, S_WRITE_SRAM_BURST);
    
    signal state: t_state;
    signal inout_mode: std_logic;  -- '0' = in mode // '1' = out mode
    signal inout_mode_1: std_logic;  -- inout_mode shifted by one clock cycle
    signal enable_iob: std_logic;
    signal U_data_i_1: std_logic_vector(35 downto 0);  -- U_data_i shifted by one clock cycle

begin

    io_buffers:
        for i in 0 to 35 generate
            io_buffer: trigger_io
                port map (
                    SORTIE => U_data_o(i),
                    CLK    => Clock,
                    nRESET => Reset,
                    TRIG   => inout_mode_1,
                    E_S    => Data(i),
                    ENTREE => U_data_i_1(i)
                );
    end generate io_buffers;
    
    inout_mode_latch: d_latch
        generic map (
            bus_width => 1
        )
        port map (
            D(0)  => inout_mode,
            Q(0)  => inout_mode_1,
            CLK   => Clock,
            EN    => enable_iob,
            RESET => Reset
        );
    
    U_data_i_latch: d_latch
        generic map (
            bus_width => 36
        )
        port map (
            D     => U_data_i,
            Q     => U_data_i_1,
            CLK   => Clock,
            EN    => enable_iob and not(inout_mode),
            RESET => Reset
        );

    -- Hardwiring --
    Clk <= Clock;
    Address <= U_Address;
    ----------------

    switch_between_states: process(Clock, Reset)
    begin
        if (Reset = '1') then
            state <= S_RESET;
        else
            if ((clock'event) and (clock = '0')) then
                case state is
                    when S_RESET =>
                        state <= S_IDLE;
                    when S_IDLE =>
                        if (Read = '1') then
                            state <= S_READ_SRAM_NO_BURST;
                        elsif (Write = '1') then
                            state <= S_WRITE_SRAM_NO_BURST;
                        else
                            state <= S_IDLE;
                        end if;
                    when S_READ_SRAM_NO_BURST | S_READ_SRAM_BURST =>
                        if (Read = '1') then
                            if (Burst = '1') then
                                state <= S_READ_SRAM_BURST;
                            else
                                state <= S_READ_SRAM_NO_BURST;
                            end if;
                        elsif (Write = '1') then
                            state <= S_WRITE_SRAM_NO_BURST;
                        else
                            state <= S_IDLE;
                        end if;
                    when S_WRITE_SRAM_NO_BURST | S_WRITE_SRAM_BURST =>
                        if (Read = '1') then
                            state <= S_READ_SRAM_NO_BURST;
                        elsif (Write = '1') then
                            if (Burst = '1') then
                                state <= S_WRITE_SRAM_BURST;
                            else
                                state <= S_WRITE_SRAM_NO_BURST;
                            end if;
                        else
                            state <= S_IDLE;
                        end if;
                end case;
            end if ;
        end if;
    end process;
    
    
    sram_control: process(state)
    begin
        case state is
            when S_RESET =>
                ------------------- S_RESET State -------------------
                -- In this state, the chip is completely disabled. --
                -----------------------------------------------------
                inout_mode <= '0';
                enable_iob <= '0';
                Lbo_n <= '0';
                Cke_n <= '0';
                Ld_n <= '0';
                Bwa_n <= '0';
                Bwb_n <= '0';
                Bwc_n <= '0';
                Bwd_n <= '0';
                Rw_n <= '0';
                Oe_n <= '0';
                Ce_n <= '1';
                Ce2_n <= '0';
                Ce2 <= '1';
                Zz <= '0';
            when S_IDLE =>
                ------------------- S_IDLE  State -------------------
                -- In this state, the chip is in light sleep mode. --
                -----------------------------------------------------
                inout_mode <= '0';
                enable_iob <= '0';
                Lbo_n <= '0';
                Cke_n <= '0';
                Ld_n <= '0';
                Bwa_n <= '0';
                Bwb_n <= '0';
                Bwc_n <= '0';
                Bwd_n <= '0';
                Rw_n <= '0';
                Oe_n <= '0';
                Ce_n <= '0';
                Ce2_n <= '0';
                Ce2 <= '1';
                Zz <= '1';  -- In idle mode, using snooze mode allows for a quicker wake-up cycle.
            when S_READ_SRAM_NO_BURST =>
                ------------ S_READ_SRAM_NO_BURST  State ------------
                -- In this state, the chip is in "read" mode, and  --
                -- the IO buffer is set to "out" mode.             --
                -----------------------------------------------------
                inout_mode <= '1';
                enable_iob <= '1';
                Lbo_n <= '0';
                Cke_n <= '0';
                Ld_n <= '0';
                Bwa_n <= '0';
                Bwb_n <= '0';
                Bwc_n <= '0';
                Bwd_n <= '0';
                Rw_n <= '1';
                Oe_n <= '0';
                Ce_n <= '0';
                Ce2_n <= '0';
                Ce2 <= '1';
                Zz <= '0';
            when S_WRITE_SRAM_NO_BURST =>
                ------------ S_WRITE_SRAM_NO_BURST State ------------
                -- In this state, the chip is in "write" mode, and --
                -- the IO buffer is set to "in" mode.              --
                -----------------------------------------------------
                inout_mode <= '0';
                enable_iob <= '1';
                Lbo_n <= '0';
                Cke_n <= '0';
                Ld_n <= '0';
                Bwa_n <= '0';
                Bwb_n <= '0';
                Bwc_n <= '0';
                Bwd_n <= '0';
                Rw_n <= '0';
                Oe_n <= '0';
                Ce_n <= '0';
                Ce2_n <= '0';
                Ce2 <= '1';
                Zz <= '0';
            when S_READ_SRAM_BURST =>
                -------------- S_READ_SRAM_BURST State --------------
                -- In this state, the chip is in "write" mode, the --
                -- IO buffer is set to "in" mode, and the address  --
                -- increments automatically.                       --
                -----------------------------------------------------
                inout_mode <= '1';
                enable_iob <= '1';
                Lbo_n <= '0';
                Cke_n <= '0';
                Ld_n <= '1';
                Bwa_n <= '0';
                Bwb_n <= '0';
                Bwc_n <= '0';
                Bwd_n <= '0';
                Rw_n <= '1';
                Oe_n <= '0';
                Ce_n <= '0';
                Ce2_n <= '0';
                Ce2 <= '1';
                Zz <= '0';
            when S_WRITE_SRAM_BURST =>
                ------------- S_WRITE_SRAM_BURST  State -------------
                -- In this state, the chip is in "read" mode, the  --
                -- IO buffer is set to "out" mode, and the address --
                -- increments automatically.                       --
                -----------------------------------------------------
                inout_mode <= '0';
                enable_iob <= '1';
                Lbo_n <= '0';
                Cke_n <= '0';
                Ld_n <= '1';
                Bwa_n <= '0';
                Bwb_n <= '0';
                Bwc_n <= '0';
                Bwd_n <= '0';
                Rw_n <= '0';
                Oe_n <= '0';
                Ce_n <= '0';
                Ce2_n <= '0';
                Ce2 <= '1';
                Zz <= '0';
        end case;
    end process;
    
end Behavioral;
