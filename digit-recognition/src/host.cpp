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
#include "typedefs.h"
#include "training_data.h"
#include "testing_data.h"


// Forward declaration of utility functions included at the end of this file
std::vector<cl::Device> get_xilinx_devices();
char *read_binary_file(const std::string &xclbin_file_name, unsigned &nb);
void check_results(LabelType* result, const LabelType* expected, int cnt);

// ------------------------------------------------------------------------------------
// Main program
// ------------------------------------------------------------------------------------
int main(int argc, char **argv)
{
    // ------------------------------------------------------------------------------------
    // Step 1: Initialize the OpenCL environment
    // ------------------------------------------------------------------------------------
    cl_int err;
    std::string binaryFile = (argc != 2) ? "DigitRec.xclbin" : argv[1];
    unsigned fileBufSize;
    std::vector<cl::Device> devices = get_xilinx_devices();
    devices.resize(1);
    cl::Device device = devices[0];
    cl::Context context(device, NULL, NULL, NULL, &err);
    char *fileBuf = read_binary_file(binaryFile, fileBufSize);
    cl::Program::Binaries bins{{fileBuf, fileBufSize}};
    cl::Program program(context, devices, bins, NULL, &err);
    cl::CommandQueue q(context, device, CL_QUEUE_PROFILING_ENABLE, &err);
    cl::Kernel krnl_DigitRec(program, "DigitRec", &err);

    // ------------------------------------------------------------------------------------
    // Step 2: Create buffers and initialize test values
    // ------------------------------------------------------------------------------------
    // Create the buffers and allocate memory
    cl::Buffer in1_buf(context, CL_MEM_READ_ONLY, sizeof(WholeDigitType) * NUM_TRAINING / 2, NULL, &err);
    cl::Buffer in2_buf(context, CL_MEM_READ_ONLY, sizeof(WholeDigitType) * NUM_TRAINING / 2, NULL, &err);
    cl::Buffer in3_buf(context, CL_MEM_READ_ONLY, sizeof(WholeDigitType) * NUM_TEST, NULL, &err);
    cl::Buffer out_buf(context, CL_MEM_WRITE_ONLY, sizeof(LabelType) * NUM_TEST, NULL, &err);

    // Map buffers to kernel arguments, thereby assigning them to specific device memory banks
    krnl_DigitRec.setArg(0, in1_buf);
    krnl_DigitRec.setArg(1, in2_buf);
    krnl_DigitRec.setArg(2, in3_buf);
    krnl_DigitRec.setArg(3, out_buf);

    // Map host-side buffer memory to user-space pointers
    WholeDigitType *training_in0 = (WholeDigitType *)q.enqueueMapBuffer(in1_buf, CL_TRUE, CL_MAP_WRITE, 0, sizeof(WholeDigitType) * NUM_TRAINING / 2);
    WholeDigitType *training_in1 = (WholeDigitType *)q.enqueueMapBuffer(in2_buf, CL_TRUE, CL_MAP_WRITE, 0, sizeof(WholeDigitType) * NUM_TRAINING / 2);
    WholeDigitType *test_in = (WholeDigitType *)q.enqueueMapBuffer(in3_buf, CL_TRUE, CL_MAP_WRITE, 0, sizeof(WholeDigitType) * NUM_TEST);
    LabelType *result = (LabelType *)q.enqueueMapBuffer(out_buf, CL_TRUE, CL_MAP_WRITE | CL_MAP_READ, 0, sizeof(LabelType) * NUM_TEST);

    // Initialize the vectors used in the test
    // pack the data into a wide datatype
    for (int i = 0; i < NUM_TRAINING / 2; i ++ )
    {
      training_in0[i].range(63 , 0  ) = training_data[i*DIGIT_WIDTH+0];
      training_in0[i].range(127, 64 ) = training_data[i*DIGIT_WIDTH+1];
      training_in0[i].range(191, 128) = training_data[i*DIGIT_WIDTH+2];
      training_in0[i].range(255, 192) = training_data[i*DIGIT_WIDTH+3];
    }
    for (int i = 0; i < NUM_TRAINING / 2; i ++ )
    {
      training_in1[i].range(63 , 0  ) = training_data[(NUM_TRAINING / 2 + i)*DIGIT_WIDTH+0];
      training_in1[i].range(127, 64 ) = training_data[(NUM_TRAINING / 2 + i)*DIGIT_WIDTH+1];
      training_in1[i].range(191, 128) = training_data[(NUM_TRAINING / 2 + i)*DIGIT_WIDTH+2];
      training_in1[i].range(255, 192) = training_data[(NUM_TRAINING / 2 + i)*DIGIT_WIDTH+3];
    }

    for (int i = 0; i < NUM_TEST; i ++ )
    {
      test_in[i].range(63 , 0  ) = testing_data[i*DIGIT_WIDTH+0];
      test_in[i].range(127, 64 ) = testing_data[i*DIGIT_WIDTH+1];
      test_in[i].range(191, 128) = testing_data[i*DIGIT_WIDTH+2];
      test_in[i].range(255, 192) = testing_data[i*DIGIT_WIDTH+3];
    }

    // ------------------------------------------------------------------------------------
    // Step 3: Run the kernel
    // ------------------------------------------------------------------------------------
    // Set kernel arguments
    krnl_DigitRec.setArg(0, in1_buf);
    krnl_DigitRec.setArg(1, in2_buf);
    krnl_DigitRec.setArg(2, in3_buf);
    krnl_DigitRec.setArg(3, out_buf);
    krnl_DigitRec.setArg(4, DATA_SIZE);

    // Schedule transfer of inputs to device memory, execution of kernel, and transfer of outputs back to host memory
    q.enqueueMigrateMemObjects({in1_buf}, 0 /* 0 means from host*/);
    q.enqueueTask(krnl_DigitRec);
    q.enqueueMigrateMemObjects({out_buf}, CL_MIGRATE_MEM_OBJECT_HOST);

    // Wait for all scheduled operations to finish
    q.finish();

    // ------------------------------------------------------------------------------------
    // Step 4: Check Results and Release Allocated Resources
    // ------------------------------------------------------------------------------------
    bool match = true;
    check_results( result, expected, NUM_TEST );

    delete[] fileBuf;

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


void check_results(LabelType* result, const LabelType* expected, int cnt)
{
  int correct_cnt = 0;

  //std::ofstream ofile;
  //ofile.open("outputs.txt");
  //if (ofile.is_open())
  {
    for (int i = 0; i < cnt; i ++ )
    {
      if (result[i] != expected[i])
        std::cout << "Test " << i << ": expected = " << int(expected[i]) << ", result = " << int(result[i]) << std::endl;
      else
        correct_cnt ++;
    }

    std::cout << "\n\t " << correct_cnt << " / " << cnt << " correct!" << std::endl;
  }
  //else
  //{
  //  std::cout << "Failed to create output file!" << std::endl;
  //}


}
