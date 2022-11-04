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

/*******************************************************************************
Description:
    Kernel to kernel streaming example consisting of three compute
    uints in a linear hardware pipeline.

    1) Memory read
        This Kernel reads the input vector from Global Memory and streams its
output.

    2) Increment
        This Kernel reads stream input, increments the value and streams to
output.

    3) Memory write
        This Kernel reads from its input stream and writes into Global Memory.

                     _____________
                    |             |<----- Global Memory
                    |  mem_read   |
                    |_____________|------+
                     _____________       | AXI4 Stream
                    |             |<-----+
                    |  increment  |
                    |_____________|----->+
                     ______________      | AXI4 Stream
                    |              |<----+
                    |  mem_write   |
                    |______________|-----> Global Memory


*******************************************************************************/

#include <cstdio>
#include <cstring>
#include <iostream>
#include <vector>
#include <xcl2.hpp>
#include "typedefs.h"
#include <sys/time.h>
#include "imageLib/imageLib.h"


void event_cb(cl_event event1, cl_int cmd_status, void* data) {
    cl_int err;
    cl_command_type command;
    cl::Event event(event1, true);
    OCL_CHECK(err, err = event.getInfo<cl_command_type>(CL_EVENT_COMMAND_TYPE, &command));
    cl_int status;
    OCL_CHECK(err, err = event.getInfo<cl_int>(CL_EVENT_COMMAND_EXECUTION_STATUS, &status));

    const char* command_str;
    const char* status_str;
    switch (command) {
        case CL_COMMAND_READ_BUFFER:
            command_str = "buffer read";
            break;
        case CL_COMMAND_WRITE_BUFFER:
            command_str = "buffer write";
            break;
        case CL_COMMAND_NDRANGE_KERNEL:
            command_str = "kernel";
            break;
    }
    switch (status) {
        case CL_QUEUED:
            status_str = "Queued";
            break;
        case CL_SUBMITTED:
            status_str = "Submitted";
            break;
        case CL_RUNNING:
            status_str = "Executing";
            break;
        case CL_COMPLETE:
            status_str = "Completed";
            break;
    }
    printf("%s %s %s\n", status_str, reinterpret_cast<char*>(data), command_str);
    fflush(stdout);
}


// Sets the callback for a particular event
void set_callback(cl::Event event, const char* queue_name) {
    cl_int err;
    OCL_CHECK(err, err = event.setCallback(CL_COMPLETE, event_cb, (void*)queue_name));
}

// Check the output data
void check_results(velocity_t output[MAX_HEIGHT*MAX_WIDTH], CFloatImage refFlow);


int main(int argc, char** argv) {
    //if (argc != 2) {
    //    std::cout << "Usage: " << argv[0] << " <XCLBIN File>" << std::endl;
    //    return EXIT_FAILURE;
    //}

    // Variables for time measurement
    struct timeval start, end;


    std::string binaryFile = argv[argc-1];
    std::vector<cl::Event> kernel_wait_events;
    cl_int err;
    cl::CommandQueue q;
    cl::Context context;
    cl::Kernel krnl_mem_read1, krnl_mem_write1;
    cl::Kernel krnl_mem_read2, krnl_mem_write2;
    cl::Kernel krnl_mem_read3, krnl_mem_write3;


    // Reducing the data size for emulation mode
    char* xcl_mode = getenv("XCL_EMULATION_MODE");
    if (xcl_mode != nullptr) {
        std::cout << "We are performing Emulation" << std::endl;
    }

    // Allocate Memory in Host Memory
    size_t vector_size_bytes1 = sizeof(ap_uint<64>)  * CONFIG_SIZE;
    size_t vector_size_bytes2 = sizeof(ap_uint<512>) * INPUT_SIZE;
    size_t vector_size_bytes3 = sizeof(ap_uint<64>)  * CONFIG_SIZE;
    size_t vector_size_bytes4 = sizeof(ap_uint<512>) * OUTPUT_SIZE;
    size_t vector_size_bytes5 = sizeof(ap_uint<32> ) * CONFIG_SIZE;


    std::vector<ap_uint<64>,  aligned_allocator<ap_uint<64>>  > source_input1     (CONFIG_SIZE);
    std::vector<ap_uint<512>, aligned_allocator<ap_uint<512>> > source_input2     (INPUT_SIZE );
    std::vector<ap_uint<32>,  aligned_allocator<ap_uint<32>>  > source_input3     (CONFIG_SIZE);
    std::vector<ap_uint<64>,  aligned_allocator<ap_uint<64>>  > source_hw_results1(CONFIG_SIZE);
    std::vector<ap_uint<512>, aligned_allocator<ap_uint<512>> > source_hw_results2(OUTPUT_SIZE);
    std::vector<ap_uint<32>,  aligned_allocator<ap_uint<32>>  > source_hw_results3(CONFIG_SIZE);
    std::vector<ap_uint<64>,  aligned_allocator<ap_uint<64>>  > source_sw_results (CONFIG_SIZE);

    // Create the test data and Software Result
    // configure packets
    // source_input1[0] = 1;
    // source_input1[1] = 2;
    // source_input1[2] = 3;
    // source_input1[3] = 4;
    // source_input1[4] = 5;
    // end of configure packets
    source_input1[0].range(63, 32) = 0x00000000;
    source_input1[0].range(31,  0) = 0x00000002;

    source_input1[1].range(63, 32) = 0x00000000;
    source_input1[1].range(31,  0) = INPUT_SIZE;

    source_input1[2].range(63, 32) = 0xffffffff;
    source_input1[2].range(31,  0) = 0xffffffff;

    source_input1[3].range(63, 32) = 0xffffffff;
    source_input1[3].range(31,  0) = 0xffffffff;




    std::string dataPath("./current");
    //std::string outFile("/home/ylxiao/eclipse-workspace/optical_flow/datasets/current/out.flo");

    // for sw and sdsoc versions
    //parse_sdsoc_command_line_args(argc, argv, dataPath, outFile);

    // create actual file names according to the datapath
    std::string frame_files[5];
    std::string reference_file;
    frame_files[0] = dataPath + "/frame1.ppm";
    frame_files[1] = dataPath + "/frame2.ppm";
    frame_files[2] = dataPath + "/frame3.ppm";
    frame_files[3] = dataPath + "/frame4.ppm";
    frame_files[4] = dataPath + "/frame5.ppm";
    reference_file = dataPath + "/ref.flo";

    // read in images and convert to grayscale
    printf("Reading input files ... \n");

    CByteImage imgs[5];
    for (int i = 0; i < 5; i++)
    {
    CByteImage tmpImg;
    ReadImage(tmpImg, frame_files[i].c_str());
    imgs[i] = ConvertToGray(tmpImg);
    }

    // read in reference flow file
    printf("Reading reference output flow... \n");

    CFloatImage refFlow;
    ReadFlowFile(refFlow, reference_file.c_str());


    // pack the values
    for (int i = 0; i < MAX_HEIGHT; i++)
    {
        for (int j = 0; j < MAX_WIDTH/8; j++)
        {
            for(int k=0; k<8; k++){
                source_input2[i*MAX_WIDTH/8+j](k*64+7 , k*64+0)  = imgs[0].Pixel(j*8+k, i, 0);
                source_input2[i*MAX_WIDTH/8+j](k*64+15, k*64+8)  = imgs[1].Pixel(j*8+k, i, 0);
                source_input2[i*MAX_WIDTH/8+j](k*64+23, k*64+16) = imgs[2].Pixel(j*8+k, i, 0);
                source_input2[i*MAX_WIDTH/8+j](k*64+31, k*64+24) = imgs[3].Pixel(j*8+k, i, 0);
                source_input2[i*MAX_WIDTH/8+j](k*64+39, k*64+32) = imgs[4].Pixel(j*8+k, i, 0);
                source_input2[i*MAX_WIDTH/8+j](k*64+63, k*64+40) = 0;
            }
        }
    }


    for (size_t i = 0; i < CONFIG_SIZE; i++) {
        source_input3[i].range(31, 0) = i;
        for(int j=0; j<2; j++){source_sw_results[i].range(j*32+31, j*32) = i;}
        source_sw_results[i] = source_sw_results[i] + 1;
    }

    // OPENCL HOST CODE AREA START
    // get_xil_devices() is a utility API which will find the Xilinx
    // platforms and will return list of devices connected to Xilinx platform
    std::vector<cl::Device> devices = xcl::get_xil_devices();

    // read_binary_file() is a utility API which will load the binaryFile
    // and will return pointer to file buffer.
    auto fileBuf = xcl::read_binary_file(binaryFile);
    cl::Program::Binaries bins{{fileBuf.data(), fileBuf.size()}};
    bool valid_device = false;
    for (unsigned int i = 0; i < devices.size(); i++) {
        auto device = devices[i];
        // Creating Context and Command Queue for selected Device
        OCL_CHECK(err, context = cl::Context(device, nullptr, nullptr, nullptr, &err));
        OCL_CHECK(err, q = cl::CommandQueue(context, device,
                                            CL_QUEUE_OUT_OF_ORDER_EXEC_MODE_ENABLE | CL_QUEUE_PROFILING_ENABLE, &err));

        std::cout << "Trying to program device[" << i << "]: " << device.getInfo<CL_DEVICE_NAME>() << std::endl;




        // Load xclbin
        for (int i = 1; i < argc-1; i++)
        {
            char *xclbinFilename = argv[i];
            std::cout << "Loading: '" << xclbinFilename << "'\n";
            std::ifstream bin_file(xclbinFilename, std::ifstream::binary);
            bin_file.seekg(0, bin_file.end);
            unsigned nb = bin_file.tellg();
            bin_file.seekg(0, bin_file.beg);
            char *buf = new char[nb];
            bin_file.read(buf, nb);

            // Creating Program from Binary File
            cl::Program::Binaries bins;
            bins.push_back({buf, nb});
            devices.resize(1);
            cl::Program program(context, devices, bins);
        }
        std::cout << "Done!" << std::endl;




        cl::Program program(context, {device}, bins, nullptr, &err);
        if (err != CL_SUCCESS) {
            std::cout << "Failed to program device[" << i << "] with xclbin file!\n";
        } else {
            std::cout << "Device[" << i << "]: program successful!\n";
            OCL_CHECK(err, krnl_mem_read1 = cl::Kernel(program, "mem_read1", &err));
            OCL_CHECK(err, krnl_mem_read2 = cl::Kernel(program, "mem_read2", &err));
            OCL_CHECK(err, krnl_mem_read3 = cl::Kernel(program, "mem_read3", &err));
            OCL_CHECK(err, krnl_mem_write1 = cl::Kernel(program, "mem_write1", &err));
            OCL_CHECK(err, krnl_mem_write2 = cl::Kernel(program, "mem_write2", &err));
            OCL_CHECK(err, krnl_mem_write3 = cl::Kernel(program, "mem_write3", &err));
            valid_device = true;
            break; // we break because we found a valid device
        }
    }
    if (!valid_device) {
        std::cout << "Failed to program any device found, exit!\n";
        exit(EXIT_FAILURE);
    }

    // Allocate Buffer in Global Memory
    // Buffers are allocated using CL_MEM_USE_HOST_PTR for efficient memory and
    // Device-to-host communication
    std::cout << "Creating Buffers..." << std::endl;
    OCL_CHECK(err, cl::Buffer buffer_input1(context,
                                           CL_MEM_USE_HOST_PTR, // | CL_INCREMENT_ONLY,
                                           vector_size_bytes1, source_input1.data(), &err));
    OCL_CHECK(err, cl::Buffer buffer_input2(context,
                                           CL_MEM_USE_HOST_PTR, // | CL_INCREMENT_ONLY,
                                           vector_size_bytes2, source_input2.data(), &err));
    OCL_CHECK(err, cl::Buffer buffer_input3(context,
                                           CL_MEM_USE_HOST_PTR, // | CL_INCREMENT_ONLY,
                                           vector_size_bytes5, source_input3.data(), &err));
    OCL_CHECK(err, cl::Buffer buffer_output1(context,
                                            CL_MEM_USE_HOST_PTR, // | CL_MEM_WRITE_ONLY,
                                            vector_size_bytes1, source_hw_results1.data(), &err));
    OCL_CHECK(err, cl::Buffer buffer_output2(context,
                                            CL_MEM_USE_HOST_PTR, // | CL_MEM_WRITE_ONLY,
                                            vector_size_bytes4, source_hw_results2.data(), &err));
    OCL_CHECK(err, cl::Buffer buffer_output3(context,
                                            CL_MEM_USE_HOST_PTR, // | CL_MEM_WRITE_ONLY,
                                            vector_size_bytes5, source_hw_results3.data(), &err));




    // Set the Kernel Arguments
    
    OCL_CHECK(err, err = krnl_mem_read1.setArg(0, buffer_input1));
    OCL_CHECK(err, err = krnl_mem_read1.setArg(2, CONFIG_SIZE));
    OCL_CHECK(err, err = krnl_mem_read2.setArg(0, buffer_input2));
    OCL_CHECK(err, err = krnl_mem_read2.setArg(2, INPUT_SIZE));
    OCL_CHECK(err, err = krnl_mem_read3.setArg(0, buffer_input3));
    OCL_CHECK(err, err = krnl_mem_read3.setArg(2, CONFIG_SIZE));
 
    OCL_CHECK(err, err = krnl_mem_write1.setArg(1, buffer_output1));
    OCL_CHECK(err, err = krnl_mem_write1.setArg(2, CONFIG_SIZE));
    OCL_CHECK(err, err = krnl_mem_write2.setArg(1, buffer_output2));
    OCL_CHECK(err, err = krnl_mem_write2.setArg(2, OUTPUT_SIZE));
    OCL_CHECK(err, err = krnl_mem_write3.setArg(1, buffer_output3));
    OCL_CHECK(err, err = krnl_mem_write3.setArg(2, CONFIG_SIZE));
    
    std::vector<cl::Event> kernel_events(6);
    bool match = true;

    // Launch the Kernel
    std::cout << "Launching Kernel..." << std::endl;


    // Kernel 1 related
    OCL_CHECK(err, err = q.enqueueMigrateMemObjects({buffer_input1}, 0 /*0 means from host*/));
    OCL_CHECK(err, err = q.enqueueTask(krnl_mem_read1,  nullptr, &kernel_events[0]));
    set_callback(kernel_events[0], "memread1");
    OCL_CHECK(err, err = q.enqueueTask(krnl_mem_write1, nullptr, &kernel_events[3]));
    set_callback(kernel_events[3], "memwrite1");
    OCL_CHECK(err, err = q.finish()); ///////////////////////////////////////////////////////
    OCL_CHECK(err, err = q.enqueueMigrateMemObjects({buffer_output1}, CL_MIGRATE_MEM_OBJECT_HOST));
    OCL_CHECK(err, err = q.finish()); ///////////////////////////////////////////////////////
    int max_config = CONFIG_SIZE > 20 ? 20: CONFIG_SIZE;
    for(int i=0; i<max_config; i++){
        printf("%d: %08x_%08x\n", i, (unsigned int)source_hw_results1[i].range(63, 32), (unsigned int) source_hw_results1[i].range(31, 0));
    }


    // Kernel 2 related
    OCL_CHECK(err, err = q.enqueueMigrateMemObjects({buffer_input2}, 0 /*0 means from host*/));
    OCL_CHECK(err, err = q.finish()); ///////////////////////////////////////////////////////
    gettimeofday(&start, NULL);
    OCL_CHECK(err, err = q.enqueueTask(krnl_mem_read2,  nullptr, &kernel_events[1]));
    set_callback(kernel_events[1], "memwread2");
    OCL_CHECK(err, err = q.enqueueTask(krnl_mem_write2, nullptr, &kernel_events[4]));
    set_callback(kernel_events[4], "memwrite2");
    OCL_CHECK(err, err = q.finish()); ///////////////////////////////////////////////////////
    gettimeofday(&end, NULL);
    OCL_CHECK(err, err = q.enqueueMigrateMemObjects({buffer_output2}, CL_MIGRATE_MEM_OBJECT_HOST));
    OCL_CHECK(err, err = q.finish()); ///////////////////////////////////////////////////////

    // Kernel 3 related
    // OCL_CHECK(err, err = q.enqueueMigrateMemObjects({buffer_input3}, 0 /*0 means from host*/));
    // OCL_CHECK(err, err = q.enqueueTask(krnl_mem_read3,  nullptr, &kernel_events[2]));
    // set_callback(kernel_events[2], "memread3");
    // OCL_CHECK(err, err = q.enqueueTask(krnl_mem_write3, nullptr, &kernel_events[5]));
    // set_callback(kernel_events[5], "memwrite3");
    // OCL_CHECK(err, err = q.finish()); /////////////////////////////////////////////////////////////
    // OCL_CHECK(err, err = q.enqueueMigrateMemObjects({buffer_output3}, CL_MIGRATE_MEM_OBJECT_HOST));
    // OCL_CHECK(err, err = q.finish()); /////////////////////////////////////////////////////////////
    // for(int i=0; i<max_config; i++){
    //     printf("-%d: %08x\n", i, (unsigned int) source_hw_results3[i].range(31, 0));
    // }


    // kernel_wait_events.resize(0);
    // kernel_wait_events.push_back(kernel_events[3]);
    
    
    
    velocity_t outputs[MAX_HEIGHT*MAX_WIDTH];

    for (int i = 0; i < MAX_HEIGHT; i++)
    {
      for (int j = 0; j < MAX_WIDTH/8; j++)
      {
    	  for (int k=0; k<8; k++){
    		  outputs[i*MAX_WIDTH+j*8+k].x(31,0)   = source_hw_results2[i*MAX_WIDTH/8+j](k*64+31, k*64);
    	  	  outputs[i*MAX_WIDTH+j*8+k].y(31,0)   = source_hw_results2[i*MAX_WIDTH/8+j](k*64+63, k*64+32);
    	  }
      }
    }

    // check results
    printf("Checking results:\n");
    printf("The right Average error should be 32.058417\n");
    check_results(outputs, refFlow);

    // print time
    long long elapsed = (end.tv_sec - start.tv_sec) * 1000000LL + end.tv_usec - start.tv_usec;   
    printf("elapsed time: %lld us\n", elapsed);

    std::cout << "Getting Results..." << std::endl;
    std::cout << "TEST " << (match ? "PASSED" : "FAILED") << std::endl;
    return (match ? EXIT_SUCCESS : EXIT_FAILURE);
}

void check_results(velocity_t output[MAX_HEIGHT*MAX_WIDTH], CFloatImage refFlow)
{
  // copy the output into the float image
  CFloatImage outFlow(MAX_WIDTH, MAX_HEIGHT, 2);
  for (int i = 0; i < MAX_HEIGHT; i++)
  {
    for (int j = 0; j < MAX_WIDTH; j++)
    {
      #ifdef OCL
        double out_x = output[i * MAX_WIDTH + j].x;
        double out_y = output[i * MAX_WIDTH + j].y;
      #else
        double out_x = output[i*MAX_WIDTH+j].x;
        double out_y = output[i*MAX_WIDTH+j].y;
      #endif

      if (out_x*out_x + out_y*out_y > 25.0)
      {
        outFlow.Pixel(j, i, 0) = 1e10;
        outFlow.Pixel(j, i, 1) = 1e10;
      }
      else
      {
        outFlow.Pixel(j, i, 0) = out_x;
        outFlow.Pixel(j, i, 1) = out_y;
      }
    }
  }

  //WriteFlowFile(outFlow, outFile.c_str());

  double accum_error = 0;
  int num_pix = 0;
  for (int i = 0; i < MAX_HEIGHT; i++)
  {
    for (int j = 0; j < MAX_WIDTH; j++)
    {
      double out_x = outFlow.Pixel(j, i, 0);
      double out_y = outFlow.Pixel(j, i, 1);

      if (unknown_flow(out_x, out_y)) continue;

      double out_deg = atan2(-out_y, -out_x) * 180.0 / M_PI;
      double ref_x = refFlow.Pixel(j, i, 0);
      double ref_y = refFlow.Pixel(j, i, 1);
      double ref_deg = atan2(-ref_y, -ref_x) * 180.0 / M_PI;

      // Normalize error to [-180, 180]
      double error = out_deg - ref_deg;
      while (error < -180) error += 360;
      while (error > 180) error -= 360;

      accum_error += fabs(error);
      num_pix++;
    }
  }

  double avg_error = accum_error / num_pix;
  printf("Average error: %lf degrees\n", avg_error);

}

