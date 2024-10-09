#include <ap_axi_sdata.h>
#include <ap_int.h>
#include <hls_stream.h>
#include <cstdint>
#include <stdint.h>

typedef ap_axiu<384, 0, 0, 0> AXI_STREAM_DATA;

extern "C" {
void sender(hls::stream<ap_axiu<384, 0, 0, 0> >& stream_out) {
#pragma HLS INTERFACE axis port=stream_out

	AXI_STREAM_DATA packet0;

	stream_out.write(packet0);

}
}

