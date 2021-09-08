# Rosetta: A Realistic High-level Synthesis Benchmark Suite for Software Programmable FPGAs
## Modifications for Vitis 2020.2

We modify the orignal benchmarks and compile them with Vitis 2020.2 instead of SDSoC(2017.1-2019.1)
The target devide is [Alveo U50](https://www.xilinx.com/products/boards-and-kits/alveo/u50.html).

The main modifications includes:
1. Change the host.cpp for all the benchmarks. Use OpenCL interface as the DMA driver.
2. As <hls_video.h> has been deprecated from Vitis 2020.1, we use <multimediaIps/xf_video_mem.hpp>
as an alternative for **optical flow** benchmark.
3. Change the Makefile for Vitis compilation.

## Setup for Alveo U50

The tools you need to install includes:
1. [Vitis 2020.2](https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/vitis/2020-2.html)
2. [xrt 2020.2](https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/alveo/u50.html)
3. [u50 deployment](https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/alveo/u50.html)

## Compile and Run Benchmarks with Alveo U50
Set up the tools environments.

```c
source <Vitis installation dir>/Vitis/2020.2/settings64.sh
source <opt/xilinx/xrt/setup.sh
```

1. rendering

```c
cd $(REPO_ROOT)/3d-rendering/hw
make
./host.exe
```
 
2. BNN

```c
cd $(REPO_ROOT)/BNN
make
source ./setup.sh
cd ./accel
./host.exe
```

3. digit-recognition

```c
cd $(REPO_ROOT)/digit-recognition/hw
make
./host.exe
```

4. face-detection

```c
cd $(REPO_ROOT)/face-detection/hw
make
./host.exe
```

5. optical-flow

```c
cd $(REPO_ROOT)/optical-flow/hw
make
./host.exe
```

6. spam-filter

```c
cd $(REPO_ROOT)/spam-filter/hw
make
./host.exe
```

## Compile Time and Performance for Alveo U50
The compile time comes from quark with 4 jobs.

| Benchmark  | HLS   |Verilog2Bit|Kernel Frequency|Runtime (ms) |
|:----------:|:-----:|:---------:|:--------------:|:-----------:|
|3D Rendering|0h7m30s|1h21m3s|300MHz|1.6ms|
|Digit Recognition<sup>1</sup>|0h2m47s|1h48m11s|300MHz|10.5ms|
|Spam Filtering<sup>2</sup>|0h1m16s|1h27m47s|300MHz|3.5ms|
|Optical Flow|0h6m42s|1h52m59s|200MHz|13.6ms|
|BNN<sup>3</sup>|0h7m50s|1h42m20s|300MHz|5250ms|
|Face Detection|0h24m47s|1h54m6s|150MHz|24.1ms|

1: K=3, `PAR_FACTOR`=40.

2: Five epochs, `PAR_FACTOR`=32, `VDWIDTH`=512.

3: 1000 test images.


## Compile and Run Benchmarks with ZCU102

1. 3d-rendering

```c
cd root_dir
./setup
cd 3d-rendering/zcu102
open ./build.sh
change source /opt/Xilinx/Vitis/2020.2/settings64.sh to the right path
./build
```

## Compile Time and Performance for ZCU102
The compile time comes from quark with 4 jobs.

| Benchmark  | HLS   |Verilog2Bit|Kernel Frequency|Runtime (ms) |
|:----------:|:-----:|:---------:|:--------------:|:-----------:|
|3D Rendering|0h4m5s|0h15m37s|200MHz|2.3ms|
|Digit Recognition<sup>1</sup>|0h2m2s|0h28m32s|200MHz|15.8ms|
|Spam Filtering<sup>2</sup>|0h0m59s|0h27m39s|200MHz|6.9ms|
|Optical Flow|0h2m23s|0h22m15s|200MHz|13.5ms|
|BNN<sup>3</sup>|NA|NA|NA|NA|
|Face Detection|0h25m33s|0h37m33s|200MHz|20.99ms|

1: K=3, `PAR_FACTOR`=40.

2: Five epochs, `PAR_FACTOR`=32, `VDWIDTH`=512.

3: 1000 test images. SDSoC zlib and minizip lib are not compatible with Vitis flow.



## Publication
-------------------------------------------------------------------------------------------
If you use Rosetta in your research, please cite [our FPGA'18 paper][1]:
```
  @article{zhou-rosetta-fpga2018,
    title   = "{Rosetta: A Realistic High-Level Synthesis Benchmark Suite for
                Software-Programmable FPGAs}",
    author  = {Yuan Zhou and Udit Gupta and Steve Dai and Ritchie Zhao and 
               Nitish Srivastava and Hanchen Jin and Joseph Featherston and
               Yi-Hsiang Lai and Gai Liu and Gustavo Angarita Velasquez and
               Wenping Wang and Zhiru Zhang},
    journal = {Int'l Symp. on Field-Programmable Gate Arrays (FPGA)},
    month   = {Feb},
    year    = {2018},
  }
```
[1]: http://www.csl.cornell.edu/~zhiruz/pdfs/rosetta-fpga2018.pdf

## Introduction 
-------------------------------------------------------------------------------------------
Rosetta is a set of realistic benchmarks for software programmable FPGAs. 
It contains six fully-developed applications from machine learning and image/video processing domains, where each benchmark consists multiple compute kernels that expose diverse sources of parallelism. 
These applications are developed under realistic design constraints, and are optimized at both kernel-level and application-level with the advanced features of HLS tools to meet these constraints. 
As a result, Rosetta is not only a practical benchmark suite for the HLS community, but also a design tutorial on how to build application-specific FPGA accelerators with state-of-the-art HLS tools and optimizations. 
We will continue to include more applications and optimize existing benchmarks. 

For each Rosetta benchmark, we provide an unoptimized software version which does not use any HLS-specific optimization, and optimized versions targeting cloud and embedded FPGA platforms. 
Rosetta currently supports Xilinx SDx 2017.1, which combines the previous Xilinx SDAccel and Xilinx SDSoC development environments. 
SDAccel is used for cloud FPGA platforms, and SDSoC is used for embedded FPGA platforms. 
Our designs have been tested on the AWS f1.2xlarge instance and a local ZC706 evaluation kit. Major results are as follows. 
For more results please refer to [our FPGA'18 paper][1]. 

### Rosetta results on ZC706

| Benchmark | #LUTs | #FFs | #BRAMs | #DSPs | Runtime (ms) | Throughput |
|:---------:|:-----:|:----:|:-----:|:------:|:------------:|:----------:|
|3D Rendering|8893|12471|48|11|4.7|213 frames/s|
|Digit Recognition<sup>1</sup>|41238|26468|338|1|10.6|189k digits/s|
|Spam Filtering<sup>2</sup>|12678|22134|69|224|60.8|370k samples/s|
|Optical Flow|42878|61078|54|454|24.3|41.2 frames/s|
|BNN<sup>3</sup>|46899|46760|102|4|4995.2|200 images/s|
|Face Detection|62688|83804|121|79|33.0|30.3 frames/s|

1: K=3, `PAR_FACTOR`=40.

2: Five epochs, `PAR_FACTOR`=32, `VDWIDTH`=64.

3: Eight convolvers, 1000 test images.
 
### Rosetta results on AWS F1

| Benchmark | #LUTs | #FFs | #BRAMs | #DSPs | Runtime (ms) | Throughput | Performance-cost Ratio | 
|:---------:|:-----:|:----:|:-----:|:------:|:------------:|:----------:|:----------------------:|
|3D Rendering|6763|7916|36|11|4.4|227 frames/s|496k frames/$|
|Digit Recognition<sup>1</sup>|39971|33853|207|0|11.1|180k digits/s|393M digits/$|
|Spam Filtering<sup>2</sup>|7207|17434|90|224|25.1|728k samples/s|1.6G samples/$|
|Optical Flow|38094|63438|55|484|8.4|119 frames/s|260k frames/$|
|Face Detection|48217|54206|92|72|21.5|46.5 frames/s|101k frames/$|

1: K=3, `PAR_FACTOR`=40.

2: Five epochs, `PAR_FACTOR`=32, `VDWIDTH`=512.

## Applications
-------------------------------------------------------------------------------------------
1. 3D rendering;
2. Digit recognition;
3. Spam filtering;
4. Optical flow;
5. Binarized neural network, adopted from [our open-source BNN implementation][2];
6. Face detection, adopted from [our open-source Haar face detection implementation][3].

[2]: https://github.com/cornell-zhang/bnn-fpga
[3]: https://github.com/cornell-zhang/facedetect-fpga

## Code Structure
-------------------------------------------------------------------------------------------
The `harness` directory contains the wrapper code for OpenCL APIs, as well as the main makefile. 
The `src` directory contains the source code for CPU host function (`host`), software implementation (`sw`), sdsoc hardware function implementation (`sdsoc`), and sdaccel hardware function implementation (`ocl`).
Each benchmark has its own makefile specifying the paths to necessary source files. 
 
## Usage
-------------------------------------------------------------------------------------------
### BNN
The `BNN` folder is currently a copy of the original [BNN repo][2] by Zhao et.al. For instructions on how to simulate and compile the design please refer to the README file inside the folder. 

### SDAccel compilation steps:
1. Figure out your target platform. SDAccel only supports a limited number of platforms. 
The code for your target platform can be found from the SDAccel user guide, or any other materials provided by the platform vendor. 
SDAccel also supports using custom platforms which are not integrated yet. 
A platform specification file (usually has the extension `.xpfm`) is needed to describe the target platform. 
2. Go into any benchmark folder.
3. To compile for software emulation and get a quick latency estimate, do `make ocl OCL_TARGET=sw_emu`. 
The report `system_estimate.xtxt` shows latency and resource estimate after high-level synthesis. 
If only a software model is needed, comment out `--report estimate` from the local makefile. 
Compilation time will significantly decrease. 
4. To compile for hardware emulation, do `make ocl OCL_TARGET=hw_emu`.
5. To compile for bitstream and actually execute on the board, do `make ocl OCL_TARGET=hw`.
6. Target platform can be specified with the `OCL_DEVICE` variable. 
Default is Alpha Data 7v3 board. 
For example, to target the Alpha Data KU3 board and generate bitstream, do 
`make ocl OCL_TARGET=hw OCL_DEVICE=xilinx:adm-pcie-ku3:2ddr-xpr:4.0`. 
To use a custom platform, specify its path with the `OCL_PLATFORM` variable. 
For example, to generate bitstream for a custom platform, do 
`make ocl OCL_TARGET=hw OCL_PLATFORM=<path_to_custom_platform_xfpm_file>`. 
Also remember to change the target device string in `host/typedefs.h`. 
7. To run simulation, please run `make emu_setup OCL_PLATFORM=<path_to_custom_platform_xfpm_file>`
to create the `.json` file used by the Xilinx OpenCL runtime. Then, set the `XCL_EMULATION_MODE`
environment variable to `sw_emu` if you want to run software simulation, or `hw_emu` for hardware
simulation. More details can be found from the Xilinx SDx Command and Utility Reference Guide
(UG1279). 
8. For instructions on how to run the applications, please refer to the READMEs in the benchmark folders. 

### SDAccel on AWS
After finishing the required setup steps on AWS, follow above steps with following differences:
1. Use the option `OCL_PLATFORM=$AWS_PLATFORM`.
The environment variable `AWS_PLATFORM` specifies the location of the AWS platform file. 
2. In `host/typedefs.h` set `TARGET_DEVICE = "xilinx:aws-vu9p-f1:4ddr-xpr-2pr:4.0"`.
3. When running the application, choose the `.awsxclbin` bitstream file instead of `.xclbin`.

### SDSoC compilation steps:
1. Go into any benchmark folder. 
2. Do `make sdsoc`.
3. The target platform is now hard-coded in the makefiles. All benchmarks currently target the ZC706 platform. 

### Software compilation steps:
1. Go into any benchmark folder. 
2. Do `make sw`. 

### Run the applications:
Please refer to the README files in the corresponding application folder for instructions. 

## Find compatible AMI on AWS 
-------------------------------------------------------------------------------------------
Our repo now supports the latest version of the AWS FPGA AWI (version 1.7.0). Please try it out. Bug reports are
welcome. 
