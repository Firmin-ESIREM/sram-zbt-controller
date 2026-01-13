#include "hls_stream.h"
#include "ap_int.h"
#include "../source/controller.h"
#include <iostream>
#include <cstdlib>


int main() {
    // Create a stream for data
    hls::stream<ap_int<DATA_WIDTH>> DataStream;

    // Signals
    ap_int<DATA_WIDTH> U_data_i = 0xABCDE1234;  // Example input data
    ap_int<DATA_WIDTH> U_data_o;
    ap_int<ADDRESS_WIDTH> U_address = 0x6A93C;  // Example address
    bool Read = false;
    bool Write = false;
    bool Burst = false;
    bool Reset = true;  // Start with reset
    bool Clock = false;  // Will toggle this in simulation

    bool Lbo_n, Clk, Cke_n, Ld_n, Bwa_n, Bwb_n, Bwc_n, Bwd_n, Rw_n, Oe_n, Ce_n, Ce2_n, Ce2, Zz;

    // Clocking simulation loop
    int cycle_count = 0;
    bool clock_toggle = false;

    // Simulate clock and stimulus
    while (cycle_count < 1000) {
        // Toggle the clock every cycle
        Clock = clock_toggle;
        clock_toggle = !clock_toggle;

        // Call the controller (simulation of the logic)
#ifdef HW_COSIM
        controller(U_data_i, U_data_o, Read, Write, Burst, U_address, Reset, Clock, DataStream, U_address, Lbo_n, Clk, Cke_n, Ld_n, Bwa_n, Bwb_n, Bwc_n, Bwd_n, Rw_n, Oe_n, Ce_n, Ce2_n, Ce2, Zz);
#endif
        // Generate stimulus similar to your VHDL testbench
        if (cycle_count == 5) {
            // Reset the controller
            Reset = false;
        }
        if (cycle_count == 50) {
            // Change address and trigger write
            Write = true;
            U_address = 0x5F21A;
        }
        if (cycle_count == 100) {
            // Change to read mode
            Write = false;
            Read = true;
        }
        if (cycle_count == 150) {
            // Switch address for read
            U_address = 0x5F21A;
        }
        if (cycle_count == 200) {
            // Switch back to write with burst mode
            Write = true;
            U_data_i = 0x001ACE42E;
            Burst = true;
        }
        if (cycle_count == 210) {
            U_data_i = 0x001ACE42D;
        }
        if (cycle_count == 220) {
            U_data_i = 0x001ACE42C;
        }
        if (cycle_count == 230) {
            U_data_i = 0x001ACE42B;
        }
        if (cycle_count == 300) {
            // Switch back to read mode
            Write = false;
            Read = true;
        }

        // Output the values to check
        if (cycle_count % 50 == 0) {
            std::cout << "Cycle " << cycle_count << ": Address = " << U_address.to_int() << ", Data Out = " << U_data_o.to_int() << std::endl;
        }

        // Increment cycle count and simulate a small delay for each cycle
        cycle_count++;
    }

    std::cout << "Testbench finished!" << std::endl;
    return 0;
}
