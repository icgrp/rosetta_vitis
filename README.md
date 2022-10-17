# Rosetta Benchmark on ZCU102
The code here is verified in ZCU102 with Vitis 2021.1. 
Original Rosetta benchmark repo is [here](https://github.com/cornell-zhang/rosetta).

## About benchmarks
- **Optical Flow, 64**: In [./optical-flow_64/src/typedefs.h](./optical-flow_64/src/typedefs.h)
  ```c
	typedef ap_fixed<32,27> outer_pixel_t;
	typedef ap_fixed<64,56> calc_pixel_t;
  ```
  And in [flow_cal](https://github.com/icgrp/rosetta_vitis/blob/f6ac4436a7f7e9701b675bc8ea88dce248961f10/optical-flow_64/src/optical_flow.cpp#L347) function,
  ```c
  static outer_pixel_t buf[2];
  ```

- **Optical Flow, 96**, float: In [./optical-flow_96/src/typedefs.h](./optical-flow_96_float/src/typedefs.h)
  ```c
	typedef ap_fixed<48,27> outer_pixel_t;
	typedef ap_fixed<96,56> calc_pixel_t;
  ```
  And in [flow_cal](https://github.com/icgrp/rosetta_vitis/blob/f6ac4436a7f7e9701b675bc8ea88dce248961f10/optical-flow_96_float/src/optical_flow.cpp#L352) function,
  ```c
  // static outer_pixel_t buf[2];
  static float buf[2];
  ```
- `PAR_FACTOR` in `typedefs.h` are different for **Digit Recognition, PAR_FACTOR==\*** and **Spam Filter, PAR_FACTOR==\***.

## Compile Benchmarks for ZCU102
Adjust the `PLATFORM_REPO_PATHS`, `ROOTFS`, etc in [./3d-rendering/zcu102/build.sh](./3d-rendering/zcu102/build.sh). 

cd to [./3d-rendering/zcu102](./3d-rendering/zcu102) and do below:
```bash
./build.sh
```
The command is the same for other benchmarks.

If you do 
```bash
python report.py
```
it will parse compile time for the benchmarks that have been built.

## Run Benchmarks on ZCU102
Write the `<BENCHMARK_DIR>/package/sd_card.img` to the SD card and boot the board.

ssh to ZCU102 and do below:
```bash
cd /media/sd-mmcblk0p1/
./run_app.sh
```

Below are the application latencies for the current version of the code.
| Benchmark  |Kernel Frequency|Application Latency|
|:----------:|:--------------:|:-----------:|
|Optlical Flow, 64|200MHz|19.1ms|
|Optlical Flow, 96, float|200MHz|19.4ms|
|3D Rendering|200MHz|2.3ms|
|Digit Recognition, PAR_FACTOR==40|200MHz|12.2ms|
|Digit Recognition, PAR_FACTOR==80|200MHz|11.5ms|
|Spam Filter, PAR_FACTOR==32|200MHz|35.7ms|
|Spam Filter, PAR_FACTOR==64|200MHz|30.4ms|

