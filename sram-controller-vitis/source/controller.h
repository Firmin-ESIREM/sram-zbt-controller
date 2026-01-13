#pragma once

#include "hls_stream.h"
#include "ap_int.h"

#define DATA_WIDTH 36
#define ADDRESS_WIDTH 19

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
    bool& Zz
);
