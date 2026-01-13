#include "controller.h"

#include "hls_stream.h"
#include "ap_int.h"


typedef enum {
    S_RESET,
    S_IDLE,
    S_READ_SRAM_NO_BURST,
    S_WRITE_SRAM_NO_BURST,
    S_READ_SRAM_BURST,
    S_WRITE_SRAM_BURST
} state_t;

bool lastClock = 0;
bool inoutMode = false;
bool inoutModeBefore = false;


// Define the controller function
void controller(
    ap_int<DATA_WIDTH> U_data_i,
    ap_int<DATA_WIDTH>& U_data_o,
    bool Read,
    bool Write,
    bool Burst,
    ap_int<ADDRESS_WIDTH> U_address,
    bool Reset,
    bool Clock,
    hls::stream<ap_int<DATA_WIDTH>>& Data,  // data inout
    ap_int<ADDRESS_WIDTH>& Address,
    bool& Lbo_n,
    bool& Clk,
    bool& Cke_n,
    bool& Ld_n,
    bool& Bwa_n,
    bool& Bwb_n,
    bool& Bwc_n,
    bool& Bwd_n,
    bool& Rw_n,
    bool& Oe_n,
    bool& Ce_n,
    bool& Ce2_n,
    bool& Ce2,
    bool& Zz) {

    // Internal signals (you can use ap_int for fixed-width signals)
    static state_t state = S_RESET;

    inoutModeBefore = inoutMode;

    static ap_int<DATA_WIDTH> U_data_i_1 = 0;

    // Sync reset and clocking
    if (Reset) {
        state = S_RESET;
    } else {
        // FSM logic
        if (!lastClock && clock) {
            switch (state) {
                case S_RESET:
                    state = S_IDLE;
                    break;
                case S_IDLE:
                    if (Read) state = S_READ_SRAM_NO_BURST;
                    else if (Write) state = S_WRITE_SRAM_NO_BURST;
                    break;
                case S_READ_SRAM_NO_BURST:
                case S_READ_SRAM_BURST:
                    if (Read) {
                        if (Burst) state = S_READ_SRAM_BURST;
                        else state = S_READ_SRAM_NO_BURST;
                    } else if (Write) {
                        state = S_WRITE_SRAM_NO_BURST;
                    } else {
                        state = S_IDLE;
                    }
                    break;
                case S_WRITE_SRAM_NO_BURST:
                case S_WRITE_SRAM_BURST:
                    if (Read) state = S_READ_SRAM_NO_BURST;
                    else if (Write) {
                        if (Burst) state = S_WRITE_SRAM_BURST;
                        else state = S_WRITE_SRAM_NO_BURST;
                    } else {
                        state = S_IDLE;
                    }
                    break;
            }
        }
    }

    // Signal assignments based on state
    switch (state) {
        case S_RESET:
            inoutMode = false;
            enable_iob = false;
            Lbo_n = false;
            Cke_n = false;
            Ld_n = false;
            Bwa_n = false;
            Bwb_n = false;
            Bwc_n = false;
            Bwd_n = false;
            Rw_n = false;
            Oe_n = false;
            Ce_n = true;
            Ce2_n = false;
            Ce2 = true;
            Zz = false;
            break;

        case S_IDLE:
            inoutMode = false;
            enable_iob = false;
            Lbo_n = false;
            Cke_n = false;
            Ld_n = false;
            Bwa_n = false;
            Bwb_n = false;
            Bwc_n = false;
            Bwd_n = false;
            Rw_n = false;
            Oe_n = false;
            Ce_n = false;
            Ce2_n = false;
            Ce2 = true;
            Zz = true;  // Snooze mode in idle state
            break;

        case S_READ_SRAM_NO_BURST:
            inoutMode = true;
            enable_iob = true;
            Lbo_n = false;
            Cke_n = false;
            Ld_n = false;
            Bwa_n = false;
            Bwb_n = false;
            Bwc_n = false;
            Bwd_n = false;
            Rw_n = true;
            Oe_n = false;
            Ce_n = false;
            Ce2_n = false;
            Ce2 = true;
            Zz = false;
            break;

        case S_WRITE_SRAM_NO_BURST:
            inoutMode = false;
            enable_iob = true;
            Lbo_n = false;
            Cke_n = false;
            Ld_n = false;
            Bwa_n = false;
            Bwb_n = false;
            Bwc_n = false;
            Bwd_n = false;
            Rw_n = false;
            Oe_n = false;
            Ce_n = false;
            Ce2_n = false;
            Ce2 = true;
            Zz = false;
            break;

        case S_READ_SRAM_BURST:
            inoutMode = true;
            enable_iob = true;
            Lbo_n = false;
            Cke_n = false;
            Ld_n = true;  // Burst mode
            Bwa_n = false;
            Bwb_n = false;
            Bwc_n = false;
            Bwd_n = false;
            Rw_n = true;
            Oe_n = false;
            Ce_n = false;
            Ce2_n = false;
            Ce2 = true;
            Zz = false;
            break;

        case S_WRITE_SRAM_BURST:
            inoutMode = false;
            enable_iob = true;
            Lbo_n = false;
            Cke_n = false;
            Ld_n = true;  // Burst mode
            Bwa_n = false;
            Bwb_n = false;
            Bwc_n = false;
            Bwd_n = false;
            Rw_n = false;
            Oe_n = false;
            Ce_n = false;
            Ce2_n = false;
            Ce2 = true;
            Zz = false;
            break;
    }

    // Handle I/O buffer and data shifting
    if (inoutMode) {
        U_data_o = U_data_i_1;
    } else {
        U_data_i_1 = U_data_i;
    }

    // Output Address (directly mapped from U_address)
    Address = U_address;

    // Simulating the SRAM inout (read or write)
    if (inoutModeBefore) {
        Data.write(U_data_o);  // Writing out to SRAM
    } else {
        Data.read();  // Reading from SRAM
    }

    lastClock = clock;
    inoutModeBefore = inoutMode;
}

