extern "C" {
	void datmover(
	        const unsigned int *in1, // Read-Only Vector 1
	        const unsigned int *in2, // Read-Only Vector 2
	        unsigned int *out1,       // Output Result
	        unsigned int *out2,       // Output Result
	        int size                 // Size in integer
	        )
	{
#pragma HLS INTERFACE m_axi port=in1 bundle=aximm1
#pragma HLS INTERFACE m_axi port=in2 bundle=aximm2
#pragma HLS INTERFACE m_axi port=out1 bundle=aximm1
#pragma HLS INTERFACE m_axi port=out2 bundle=aximm2

	    for(int i = 0; i < size; ++i)
	    {
	        out1[i] = in1[i];
	        out2[i] = in2[i];
	    }
	}
}

