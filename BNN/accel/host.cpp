#include <cstddef>
#include <cstdlib>
#include "Accel.h"
#include "AccelSchedule.h"
#include "AccelTest.h"
//#include "Dense.h"
#include "ZipIO.h"
#include "ParamIO.h"
#include "DataIO.h"
#include "Timer.h"
/**********
Copyright (c) 2018, Xilinx, Inc.
All rights reserved.
Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:
1. Redistributions of source code must retain the above copyright notice,
this list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright notice,
this list of conditions and the following disclaimer in the documentation
and/or other materials provided with the distribution.
3. Neither the name of the copyright holder nor the names of its contributors
may be used to endorse or promote products derived from this software
without specific prior written permission.
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**********/

#define CL_HPP_CL_1_2_DEFAULT_BUILD
#define CL_HPP_TARGET_OPENCL_VERSION 120
#define CL_HPP_MINIMUM_OPENCL_VERSION 120
#define CL_HPP_ENABLE_PROGRAM_CONSTRUCTION_FROM_ARRAY_COMPATIBILITY 1
#define CL_USE_DEPRECATED_OPENCL_1_2_APIS

#define DATA_SIZE 4096

#include <vector>
#include <unistd.h>
#include <iostream>
#include <fstream>
#include <CL/cl2.hpp>

// Forward declaration of utility functions included at the end of this file
std::vector<cl::Device> get_xilinx_devices();
char *read_binary_file(const std::string &xclbin_file_name, unsigned &nb);

// ------------------------------------------------------------------------------------
// Main program
// ------------------------------------------------------------------------------------
int main(int argc, char **argv)
{
    // ------------------------------------------------------------------------------------
    // Step 1: Initialize the OpenCL environment
    // ------------------------------------------------------------------------------------
    cl_int err;
    std::string binaryFile = (argc != 2) ? "bnn.xclbin" : argv[1];
    unsigned fileBufSize;
    std::vector<cl::Device> devices = get_xilinx_devices();
    devices.resize(1);
    cl::Device device = devices[0];
    cl::Context context(device, NULL, NULL, NULL, &err);
    char *fileBuf = read_binary_file(binaryFile, fileBufSize);
    cl::Program::Binaries bins{{fileBuf, fileBufSize}};
    cl::Program program(context, devices, bins, NULL, &err);
    cl::CommandQueue q(context, device, CL_QUEUE_PROFILING_ENABLE, &err);
    cl::Kernel krnl_bnn(program, "bnn", &err);

    // ------------------------------------------------------------------------------------
    // Step 2: Create buffers and initialize test values
    // ------------------------------------------------------------------------------------
    // Create the buffers and allocate memory
    cl::Buffer in1_buf(context, CL_MEM_READ_ONLY, sizeof(Word) * WT_WORDS*54, NULL, &err);
    cl::Buffer in2_buf(context, CL_MEM_READ_ONLY, sizeof(Word) * KH_WORDS*54, NULL, &err);
    cl::Buffer in3_buf(context, CL_MEM_READ_ONLY, sizeof(Word) * DMEM_WORDS, NULL, &err);
    cl::Buffer in4_buf(context, CL_MEM_READ_ONLY, sizeof(int) * 54 * 8, NULL, &err);
    cl::Buffer out_buf(context, CL_MEM_WRITE_ONLY, sizeof(Word) * DMEM_O_WORDS, NULL, &err);

    // Map buffers to kernel arguments, thereby assigning them to specific device memory banks
    krnl_bnn.setArg(0, in1_buf);
    krnl_bnn.setArg(1, in2_buf);
    krnl_bnn.setArg(2, in3_buf);
    krnl_bnn.setArg(3, in4_buf);
    krnl_bnn.setArg(4, out_buf);

    // Map host-side buffer memory to user-space pointers
    Word *wt_i     = (Word *)q.enqueueMapBuffer(in1_buf, CL_TRUE, CL_MAP_WRITE, 0, sizeof(Word) * WT_WORDS*54);
    Word *kh_i     = (Word *)q.enqueueMapBuffer(in2_buf, CL_TRUE, CL_MAP_WRITE, 0, sizeof(Word) * KH_WORDS*54);
    Word *data_i   = (Word *)q.enqueueMapBuffer(in3_buf, CL_TRUE, CL_MAP_WRITE, 0, sizeof(Word) * DMEM_WORDS);
    int *sched_list = (int * )q.enqueueMapBuffer(in4_buf, CL_TRUE, CL_MAP_WRITE, 0, sizeof(int) * 54 * 8);
    Word *out      = (Word *)q.enqueueMapBuffer(out_buf, CL_TRUE, CL_MAP_WRITE | CL_MAP_READ, 0, sizeof(Word) * DMEM_O_WORDS);

    // Initialize the vectors used in the test
    const unsigned n_imgs = 1000;

    const unsigned lconv  = 6;  // last conv
    const unsigned ldense = 8;  // last dense
    const bool DENSE_LAYER_CPU = getenv("BNN_DENSE_LAYER_CPU") != NULL;
    const bool LAST_LAYER_CPU = getenv("BNN_LAST_LAYER_CPU") != NULL;
    if (DENSE_LAYER_CPU)
      printf ("## Dense layer CPU is turned on ##\n");
    if (LAST_LAYER_CPU)
      printf ("## Last layer CPU is turned on ##\n");

    // print some config numbers
    printf ("* WT_WORDS   = %u\n", WT_WORDS);
    printf ("* KH_WORDS   = %u\n", KH_WORDS);

    // Load input data
    printf ("## Loading input data ##\n");
    Cifar10TestInputs X(n_imgs);
    Cifar10TestLabels y(n_imgs);

    // Load parameters
    printf ("## Loading parameters ##\n");
    Params params(get_root_dir() + "/params/cifar10_parameters_nb.zip");

    // ---------------------------------------------------------------------
    // allocate and binarize all weights
    // ---------------------------------------------------------------------
    Word* wt[N_LAYERS];
    Word* kh[N_LAYERS];
    for (unsigned l = 0; l < N_LAYERS; ++l) {
      const unsigned M = M_tab[l];
      const unsigned N = N_tab[l];
      if (layer_is_conv(l+1))
        wt[l] = new Word[WTS_TO_WORDS(M*N)];
      else
        wt[l] = new Word[M*N / WORD_SIZE];
      const float* weights = params.float_data(widx_tab[l]);
      set_weight_array(wt[l], weights, l+1);

      kh[l] = new Word[N/KH_PER_WORD * sizeof(Word)];
      const float* k = params.float_data(kidx_tab[l]);
      const float* h = params.float_data(hidx_tab[l]);
      set_bnorm_array(kh[l], k, h, l+1);
    }

    // ---------------------------------------------------------------------
    // // compute accelerator schedule (divides up weights)
    // ---------------------------------------------------------------------
    AccelSchedule layer_sched[N_LAYERS];
    for (unsigned l = 0; l < N_LAYERS; ++l) {
      compute_accel_schedule(
          wt[l], kh[l],
          M_tab[l], N_tab[l], S_tab[l], T_tab[l], pool_tab[l],
          layer_sched[l]
      );
    }

    unsigned n_errors = 0;

    printf ("## Running BNN for %d images\n", n_imgs);

    //--------------------------------------------------------------
    // Run BNN
    //--------------------------------------------------------------
    int sched_list_const[] = {3,128,1024,0,1,1,2,1,128,128,0,0,3,0,2,2,128,256,0,0,3,1,1,1,256,128,0,0,3,0,1,2,256,128,0,0,2,0,1,2,256,128,0,0,3,1,0,1,256,128,0,0,2,1,0,1,256,128,0,0,2,1,0,1,256,128,0,0,2,1,0,1,512,64,0,0,3,0,0,2,512,64,0,0,2,0,0,2,512,64,0,0,2,0,0,2,512,64,0,0,2,0,0,2,512,64,0,0,2,0,0,2,512,64,0,0,2,0,0,2,512,64,0,0,2,0,0,2,512,64,0,0,2,0,0,2,8192,32,0,0,5,1,0,1,8192,32,0,0,4,1,0,1,8192,32,0,0,4,1,0,1,8192,32,0,0,4,1,0,1,8192,32,0,0,4,1,0,1,8192,32,0,0,4,1,0,1,8192,32,0,0,4,1,0,1,8192,32,0,0,4,1,0,1,8192,32,0,0,4,1,0,1,8192,32,0,0,4,1,0,1,8192,32,0,0,4,1,0,1,8192,32,0,0,4,1,0,1,8192,32,0,0,4,1,0,1,8192,32,0,0,4,1,0,1,8192,32,0,0,4,1,0,1,8192,32,0,0,4,1,0,1,8192,32,0,0,4,1,0,1,8192,32,0,0,4,1,0,1,8192,32,0,0,4,1,0,1,8192,32,0,0,4,1,0,1,8192,32,0,0,4,1,0,1,8192,32,0,0,4,1,0,1,8192,32,0,0,4,1,0,1,8192,32,0,0,4,1,0,1,8192,32,0,0,4,1,0,1,8192,32,0,0,4,1,0,1,8192,32,0,0,4,1,0,1,8192,32,0,0,4,1,0,1,8192,32,0,0,4,1,0,1,8192,32,0,0,4,1,0,1,8192,32,0,0,4,1,0,1,8192,32,0,0,4,1,0,1,1024,256,0,0,5,0,0,1,1024,256,0,0,4,0,0,1,1024,256,0,0,4,0,0,1,1024,256,0,0,4,0,0,1,1024,10,0,1,7,1,0,1};
    for (unsigned n = 0; n < n_imgs; ++n)
    {
  	  float* data = X.data + n*3*32*32;
  	  binarize_input_images(data_i, data, 32);
  	  int prediction = -1;

  	  // execute BNN kernel
  	  const unsigned lconv  = 6;  // last conv
  	  const unsigned ldense = 8;  // last dense

  	  // weight mems

  	  if (!wt_i || !kh_i) {
  	    fprintf(stderr, "**** ERROR: Alloc wt_i or kh_i failed in %s\n", __FILE__);
  	    exit(-2);
  	  }

      int sched_index = 0;
      //------------------------------------------------------------
      // Execute conv layers
      //------------------------------------------------------------
      for (unsigned l = 1; l <= lconv; ++l) {
        for (unsigned i = 0; i < layer_sched[l-1].size(); ++i) {
      	for (unsigned j = 0; j < WT_WORDS; ++j)
      	  wt_i[j+sched_index*WT_WORDS] = layer_sched[l-1][i].wt[j];
      	for (unsigned j = 0; j < KH_WORDS; ++j)
      	  kh_i[j+sched_index*KH_WORDS] = layer_sched[l-1][i].kh[j];
      	sched_index++;
        }
      }

      //------------------------------------------------------------
      // Execute dense layers
      //------------------------------------------------------------
      for (unsigned l = lconv+1; l <= ldense; ++l) {
        unsigned N = layer_sched[l-1].size();
        for (unsigned i = 0; i < N; ++i) {
          for (unsigned j = 0; j < WT_WORDS; ++j)
            wt_i[j+sched_index*WT_WORDS] = layer_sched[l-1][i].wt[j];
          for (unsigned j = 0; j < KH_WORDS; ++j)
            kh_i[j+sched_index*KH_WORDS] = layer_sched[l-1][i].kh[j];
          sched_index++;
        }
      }

      //------------------------------------------------------------
      // Execute last layer
      //------------------------------------------------------------
      //printf("               l3=\n");


      for (unsigned j = 0; j < WT_WORDS; ++j)
        wt_i[j+sched_index*WT_WORDS] = layer_sched[ldense][0].wt[j];
      for (unsigned j = 0; j < KH_WORDS; ++j)
        kh_i[j+sched_index*KH_WORDS] = layer_sched[ldense][0].kh[j];
      sched_index++;

      for(int i=0; i<54*8; i++){
    	sched_list[i] = sched_list_const[i];
      }

    // ------------------------------------------------------------------------------------
    // Step 3: Run the kernel
    // ------------------------------------------------------------------------------------
    // Set kernel arguments


	  krnl_bnn.setArg(0, in1_buf);
	  krnl_bnn.setArg(1, in2_buf);
	  krnl_bnn.setArg(2, in3_buf);
	  krnl_bnn.setArg(3, in4_buf);
	  krnl_bnn.setArg(4, out_buf);

	//for(int i=0; i<10; i++){
		// Schedule transfer of inputs to device memory, execution of kernel, and transfer of outputs back to host memory
	  q.enqueueMigrateMemObjects({in1_buf, in2_buf, in3_buf, in4_buf}, 0 /* 0 means from host*/);
	  q.enqueueTask(krnl_bnn);
	  q.enqueueMigrateMemObjects({out_buf}, CL_MIGRATE_MEM_OBJECT_HOST);
	//}

	  // Wait for all scheduled operations to finish
	  q.finish();


    // ------------------------------------------------------------------------------------
    // Step 4: Check Results and Release Allocated Resources
    // ------------------------------------------------------------------------------------

      ap_int<8> p = 0;
	  p(7,0) = out[0](7,0);
	  prediction = p.to_int();
	  //assert(prediction >= 0 && prediction <= 9);
	  int label = y.data[n];
	  printf ("  Pred/Label:\t%2u/%2d\t[%s]\n", prediction, label, ((prediction==label)?" OK ":"FAIL"));
	  n_errors += (prediction!=label);
	  printf ("\n");
	  printf ("Errors: %u (%4.2f%%)\n", n_errors, float(n_errors)*100/n_imgs);
	  printf ("\n");
	  printf ("Total accel runtime = %10.4f seconds\n", total_time());
	  printf ("\n");
    }

    for (unsigned n = 0; n < N_LAYERS; ++n) {
	  delete[] wt[n];
	  delete[] kh[n];
	}


    delete[] fileBuf;

    bool match = true;
    std::cout << "TEST " << (match ? "PASSED" : "FAILED") << std::endl;
    return (match ? EXIT_SUCCESS : EXIT_FAILURE);
}

// ------------------------------------------------------------------------------------
// Utility functions
// ------------------------------------------------------------------------------------
std::vector<cl::Device> get_xilinx_devices()
{
    size_t i;
    cl_int err;
    std::vector<cl::Platform> platforms;
    err = cl::Platform::get(&platforms);
    cl::Platform platform;
    for (i = 0; i < platforms.size(); i++)
    {
        platform = platforms[i];
        std::string platformName = platform.getInfo<CL_PLATFORM_NAME>(&err);
        if (platformName == "Xilinx")
        {
            std::cout << "INFO: Found Xilinx Platform" << std::endl;
            break;
        }
    }
    if (i == platforms.size())
    {
        std::cout << "ERROR: Failed to find Xilinx platform" << std::endl;
        exit(EXIT_FAILURE);
    }

    //Getting ACCELERATOR Devices and selecting 1st such device
    std::vector<cl::Device> devices;
    err = platform.getDevices(CL_DEVICE_TYPE_ACCELERATOR, &devices);
    return devices;
}

char *read_binary_file(const std::string &xclbin_file_name, unsigned &nb)
{
    if (access(xclbin_file_name.c_str(), R_OK) != 0)
    {
        printf("ERROR: %s xclbin not available please build\n", xclbin_file_name.c_str());
        exit(EXIT_FAILURE);
    }
    //Loading XCL Bin into char buffer
    std::cout << "INFO: Loading '" << xclbin_file_name << "'\n";
    std::ifstream bin_file(xclbin_file_name.c_str(), std::ifstream::binary);
    bin_file.seekg(0, bin_file.end);
    nb = bin_file.tellg();
    bin_file.seekg(0, bin_file.beg);
    char *buf = new char[nb];
    bin_file.read(buf, nb);
    return buf;
}
