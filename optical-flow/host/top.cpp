/**
* Copyright (C) 2019-2021 Xilinx, Inc
*
* Licensed under the Apache License, Version 2.0 (the "License"). You may
* not use this file except in compliance with the License. A copy of the
* License is located at
*
*     http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
* WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
* License for the specific language governing permissions and limitations
* under the License.
*/
#include <iostream>
#include <ap_axi_sdata.h>
#include <ap_int.h>
#include <hls_stream.h>
#include "typedefs.h"

#ifdef MONO
  #include "../mono/datamover.h"

#else

  #include "../operators/data_proc1.h"
  
  
  const int DEFAULT_DEPTH = 128;
  
  
  void top (
		  hls::stream<ap_uint<512> > & Input_1,
		  hls::stream<ap_uint<512> > & Output_1
		)
{
#pragma HLS INTERFACE axis register both port=Input_1
#pragma HLS INTERFACE axis register both port=Output_1
#pragma HLS DATAFLOW

  //hls::stream<ap_uint<512> > Output_da1("Output_da1");

  data_proc1(Input_1, Output_1);
 
}

#endif

extern "C" {
void increment(
    hls::stream<ap_axiu<64, 0, 0, 0> >& input1,
    hls::stream<ap_axiu<64, 0, 0, 0> >& output1,
    hls::stream<ap_axiu<512, 0, 0, 0> >& input2,
    hls::stream<ap_axiu<512, 0, 0, 0> >& output2,
    hls::stream<ap_axiu<32, 0, 0, 0> >& input3,
    hls::stream<ap_axiu<32, 0, 0, 0> >& output3
    ) {
// For free running kernel, user needs to specify ap_ctrl_none for return port.
// This will create the kernel without AXI lite interface. Kernel will always be
// in running states.
#pragma HLS interface ap_ctrl_none port = return
    ap_axiu<64,  0, 0, 0> v1;
    ap_axiu<32,  0, 0, 0> v3;
#pragma dataflow

    for(int i=0; i<CONFIG_SIZE; i++) {
        v1 = input1.read();
        // std::cout << "cofig_i=" << i << std::endl;
        // v1.data = v1.data + 1;
        output1.write(v1);
    }

   

 
#ifdef MONO
    // std::cout << "MONO CASE" << std::endl;
    datamover(input2, output2);
#else
    ap_axiu<512, 0, 0, 0> v2;
    hls::stream<ap_uint<512> > Input_1("Input_1_str");
    hls::stream<ap_uint<512> > Output_1("Output_str");
    for(int i=0; i<INPUT_SIZE; i++){
        v2 = input2.read();
        Input_1.write(v2.data);
        //std::cout << "Input:" << i << std::endl;
    }
    top(Input_1, Output_1);
    for(int i=0; i<OUTPUT_SIZE; i++){
        v2.data = Output_1.read();
        output2.write(v2);
        //std::cout << "Output:" << i << std::endl;
    }
#endif 

    for(int i=0; i<DEBUG_SIZE; i++) {
        v3 = input3.read();
        v3.data = v3.data + 1;
        output3.write(v3);
    }

}
}
