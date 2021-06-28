#include "typedefs.h"


extern "C" {
	void ydma(
			bit64 * input1,
			bit32 * input2,
			bit64 * output1,
			bit32 * output2,
			int config_size,
			int input_size,
			int output_size
	        )
	{
#pragma HLS INTERFACE m_axi port=input1 bundle=aximm1
#pragma HLS INTERFACE m_axi port=input2 bundle=aximm2
#pragma HLS INTERFACE m_axi port=output1 bundle=aximm1
#pragma HLS INTERFACE m_axi port=output2 bundle=aximm2

	    bit64 v1_buffer[256];   // Local memory to store vector1
		//hls::stream< unsigned int > v1_buffer;
		#pragma HLS STREAM variable=v1_buffer depth=256

	    unsigned int v2_buffer[16384];   // Local memory to store vector2
		//hls::stream< unsigned int > v2_buffer;
		#pragma HLS STREAM variable=v2_buffer depth=16384


//#pragma HLS DATAFLOW

	    //if(config_size > 0){
	    	for(int i=0; i<config_size; i++){ v1_buffer[i] = input1[i]; }
	    	for(int i=0; i<config_size; i++){ output1[i] = v1_buffer[i]; }
	    //}else{
	    	for(int i=0; i<input_size;  i++){ v2_buffer[i] = input2[i]; }
	    	for(int i=0; i<output_size; i++){ output2[i] = v2_buffer[i]; }
	    //}

	}
}


