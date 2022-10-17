from datetime import datetime
import os.path
date_format = "%H:%M:%S"
BOARD = 'zcu102'
BENCHMARKS = ["3d-rendering", \
              "digit-recognition_par_40", "digit-recognition_par_80", \
              "optical-flow_64", "optical-flow_96_float", \
              "spam-filter_par_32", "spam-filter_par_64"]

def short_form(benchmark):
    if(benchmark.startswith("digit")):
        return benchmark.replace("-recognition","")
    elif(benchmark.startswith("optical")):
        return benchmark.replace("-flow","").replace("_float","")
    elif(benchmark.startswith("spam")):
        return benchmark.replace("-filter","")
    else:
        return benchmark

# return True if ./package/sd_card.img exists
def is_build_done(benchmark, benchmark_dir):
    sd_img_file = benchmark_dir + "package/sd_card.img"
    return os.path.isfile(sd_img_file)

def find_kernel_name(benchmark, benchmark_dir):
    build_file = benchmark_dir + "build.sh"
    with open(build_file, "r") as infile:
        for line in infile:
            if(line.startswith("export kl_name")):
                kernel_name = line.split("export kl_name=")[1].strip()
    return kernel_name

# example of input t is '0h 1m 23s'
def convert_time_type1(t):
    h,m,s = t.split()[0], t.split()[1], t.split()[2] 
    h = int(h.split("h")[0])
    m = int(m.split("m")[0])
    s = int(s.split("s")[0])
    total_secs = 3600 * h + 60 * m + s
    return total_secs

# # 1:1:1
# def convert_time_type2(t):
#     h,m,s = t.split(":")[0], t.split(":")[1], t.split(":")[2] 
#     return total_secs


# 1. Note that time spent for commands like rtdgen, cf2sw, xclbinutil are excluded.
#    These commands are run after write_bitstream and generally 21~22 seconds long.
# 2. v++ -p time is excluded. It's generally 20~25 seconds long.
# 3. There's some setup time before synthesis, which is syn_extra in the code below.
#    It's generally 9~10 seconds, and added to elapsed_syn
def main():
    BENCHMARKS.sort()
    print("Benchmark" + "\t" + "HLS\t" + "Syn\t" + "P/R\t" + "Bits\t" + "Total")
    print("-------------------------------------------------------------")
    for benchmark in BENCHMARKS:
        benchmark_dir = "./" + benchmark + "/" + BOARD +"/"
        if(is_build_done(benchmark, benchmark_dir)):
            kernel_name = find_kernel_name(benchmark, benchmark_dir)
            # HLS log file (v++ -c)
            with open(benchmark_dir + "_x/logs/" + kernel_name + "/v++.log","r") as infile:
                for line in infile:
                    if(line.startswith("INFO: [v++ 60-791] Total elapsed time")):
                        elapsed_hls = line.split("INFO: [v++ 60-791] Total elapsed time:")[1].strip()
                        elapsed_hls = convert_time_type1(elapsed_hls)
                #print(elapsed_hls)
            
            # v++ -l log file
            with open(benchmark_dir + "_x/logs/link/v++.log","r") as infile:
                for line in infile:
                    if(line.startswith("INFO: [v++ 60-1548] Creating build summary session")):
                        time_start = line.split(" at ")[1].strip()
                        time_start = time_start.split()[3]
                        #print(time_start) # e.g.: 22:29:52
                    if(line.endswith("Step vpl: Started\n")):
                        time_end = line.split(" Run run_link:")[0].strip()
                        time_end = time_end.split()[3]
                        time_end = time_end[1:-1]
                        #print(time_end) # e.g.: 22:30:01

                # setup time before synthesis(9~10s, add to synthesis time)
                syn_extra = datetime.strptime(time_end, date_format) - datetime.strptime(time_start, date_format)
                #print(syn_extra)
            
            # vivado.log for more details
            with open(benchmark_dir + "_x/logs/link/vivado.log","r") as infile:
                for line in infile:
                    if("Start of session at:" in line):
                        time_viv_start = line.split()[8] # magic number to extract time, e.g.: "22:30:03"
                        #print(time_viv_start)
                    if("synth_1 finished" in line):
                        time_syn_end = line.split()[3] # magic number to extract time, e.g.: "22:33:12"
                        #print(time_syn_end)
                    if("write_bitstream: Time" in line):
                        time_bits = line.split()[9] # magic number to extract time, e.g.: "00:00:15"
                        #print(time_bits)
                    if("Exiting Vivado" in line): # multiple times... but last one
                        time_viv_end = line.split()[9]
                #print(time_viv_end) # e.g.: 22:36:08
            
            elapsed_syn = (datetime.strptime(time_syn_end, date_format) - \
                           datetime.strptime(time_viv_start, date_format) + \
                           syn_extra).seconds
            elapsed_bits = datetime.strptime(time_bits, date_format).minute*60 + \
                           datetime.strptime(time_bits, date_format).second
            elapsed_pnr = (datetime.strptime(time_viv_end, date_format) - \
                           datetime.strptime(time_syn_end, date_format)).seconds - \
                           elapsed_bits
            elapsed_total = elapsed_hls + elapsed_syn + elapsed_pnr + elapsed_bits
            print(short_form(benchmark) + "\t" + str(elapsed_hls) + "\t" + \
                                       str(elapsed_syn) + "\t" + \
                                       str(elapsed_pnr) + "\t" + \
                                       str(elapsed_bits) + "\t" + \
                                       str(elapsed_total))
    
if __name__ == '__main__':
    main()
