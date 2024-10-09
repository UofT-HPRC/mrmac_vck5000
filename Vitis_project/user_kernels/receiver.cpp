#include <ap_axi_sdata.h>
#include <ap_int.h>
#include <hls_stream.h>
#include <cstdint>
#include <stdint.h>

extern "C" {
void receiver(hls::stream<ap_axiu<384, 0, 0, 0> >& stream_in) {
#pragma HLS INTERFACE axis port=stream_in
	ap_axiu<384, 0, 0, 0> v = stream_in.read();

}
}

