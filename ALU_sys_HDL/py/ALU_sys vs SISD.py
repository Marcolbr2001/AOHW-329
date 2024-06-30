#!/usr/bin/env python
# coding: utf-8

# In[1]:


import pynq
from pynq import Overlay
from pynq import allocate

from pynq import PL

import numpy as np
import time

PL.reset() # Clear Programmable Logic
first = 1  # It is a constant, It's '1' if you are running the first test ever


# In[2]:


# ---- Choose what the hardware has to do ---- #

burst_size          = 400       # A single Burst size
transactions        = 10         # Total Number of Bursts you want to do

selec = 2       # selec = 0      --> Store New Operation
                # selec = 1      --> Load New Data and Execute
                # selec = 2      --> Run Entire Program
                # selec = Others --> Reset
            
# -------------------------------------------- #


# In[3]:


#  ----- ALU_sys Software implementation ------ #

def golden(a, b, op, res):    
    for i in range(burst_size):        
        match op[i]:
            case 1:
                res[i] = a[i] - b[i]
            case 2:
                res[i] = a[i]/b[i]
            case 3:
                res[i] = a[i]*b[i]
            case 0:
                res[i] = a[i] + b[i]
    return res 

#  -------------------------------------------- #


#  ------ SISD Software implementation -------- #

def golden_SISD(a, b, op):    
    match op:
        case 1:
            res = a - b
        case 2:
            res = a//b
        case 3:
            res = a*b
        case 0:
            res = a + b
            
    return res 

#  -------------------------------------------- #


#  ---- ALU_sys and SW function comparator ---- #

def eye(res_sw, res_hw):
    for i in range(len(res_sw)):
        if res_sw[i] == res_hw[i]:
            pass
        else:
            return 0

    return 1  

#  -------------------------------------------- #


# ------ SISD and SW function comparator ------ #

def eye_SISD(res_sw, res_hw):
    
    if res_sw == res_hw:
        pass
    else:
        return 0

    return 1

#  -------------------------------------------- #

# -------- Create data and operations -------- #

seed = np.random.randint(low = 1, high = 99999, size=1)

np.random.seed(seed)

data_a_np  = np.random.randint(16383, 32767, size=(transactions, burst_size))
data_b_np  = np.random.randint(1, 16383, size=(transactions, burst_size))

operation_np = np.random.randint(0, 4, size=(transactions, burst_size))

data_a = data_a_np.tolist()
data_b = data_b_np.tolist()

operation = operation_np.tolist()

# -------------------------------------------- #


# ----------------------------------------- SISD PL ------------------------------------------------- #
if (first == 1):

    PL.reset() # Clear Programmable Logic

    test_2 = Overlay('/home/xilinx/pynq/overlays/AXI_ALU/SISD/ALU_sisd.bit') # Load SISD implementation, the State of The Art


    AXI_ALU = test_2.ALU_sisd   # Save Hierarchy

    time_list_SISD = []         # List of the Equivalent time taken to complete the same number of transactions to as many as ALU_sys Burst has

    compare_SISD = []           # Keep track if there are mismatches between HW and SW results

    for i in range(transactions):
        for j in range(burst_size):
            
            start = time.time()

            AXI_ALU.write(0x10, data_a[i][j])
            AXI_ALU.write(0x18, data_b[i][j])
            AXI_ALU.write(0x20, operation[i][j])

            c = AXI_ALU.read(0x28)

            end = time.time()

            res = golden_SISD(data_a[i][j], data_b[i][j], operation[i][j])

            compare_SISD.append(eye_SISD(res, c))

            time_list_SISD.append(end-start)

# ------------------------------------ End of SISD PL ----------------------------------------------- #


# --------------------------------------- ALU_sys PL ------------------------------------------------ #

if (first == 1):
    
    #test_1    = Overlay('/home/xilinx/pynq/overlays/AXI_ALU/ALU_sys_HDL/50/ALU_sys_HDL_50.bit')      # Load this bitstream if you choose to send a 50 data burst
    #test_1    = Overlay('/home/xilinx/pynq/overlays/AXI_ALU/ALU_sys_HDL/100/ALU_sys_HDL_100.bit')     # Load this bitstream if you choose to send a 100 data burst
    #test_1    = Overlay('/home/xilinx/pynq/overlays/AXI_ALU/ALU_sys_HDL/200/ALU_sys_HDL_200.bit')    # Load this bitstream if you choose to send a 200 data burst
    test_1    = Overlay('/home/xilinx/pynq/overlays/AXI_ALU/ALU_sys_HDL/400/ALU_sys_HDL_400.bit')    # Load this bitstream if you choose to send a 400 data burst

    AXI_ALU = test_1.ALU_sys_HDL_0  # Save Hierarchy
    
    first = 0
    
time_list_ALU_sys   = []        # List of the time taken to complete a single ALU_sys burst
time_list_sw        = []        # List of Equivalent time taken by the Software to achieve the same number of transaction

compare_ALU_sys     = []        # Keep track if there are mismatches between HW and SW results


for i in range(transactions):      
    
    # --- Buffering in order to mimic ALU_sys --- #

    start_sw = time.time() # Software Time counter starts here
    
    selec_sw     = selec
    
    output_sw = np.zeros(burst_size, dtype=np.int32)
    
    # -------------------------------------------- #


    # ------------- SW function call ------------- #
    
    match(selec):

        case 0:
            
            operation_sw = operation[i]
            sw_result    = np.zeros(burst_size, 'int32')

        case 1:
            
            data_a_sw    = data_a[i]
            data_b_sw    = data_b[i]
            
            sw_result    = golden(data_a_sw, data_b_sw, operation_sw, output_sw)


        case 2:
            
            data_a_sw    = data_a[i]
            data_b_sw    = data_b[i]
            operation_sw = operation[i]
            
            sw_result    = golden(data_a_sw, data_b_sw, operation_sw, output_sw)

        case others: 

            sw_result = np.zeros(burst_size, 'int32')

    # -------------------------------------------- #


    end_sw = time.time() # Software Time counter ends here

    time_list_sw.append(end_sw - start_sw) # Store this SW time value into the SW list


    # -- Allocating and preparing pynq buffers --- #

    input_a     = pynq.allocate(burst_size, np.int32)
    input_b     = pynq.allocate(burst_size, np.int32)

    input_op    = pynq.allocate(burst_size, np.uint32)

    output      = pynq.allocate(burst_size, np.int32)
    
    if (selec == 0 or selec == 2):
        operation_hw = operation
        
    input_a[:] = data_a[i]
    input_b[:] = data_b[i]
    input_op[:] = operation_hw[i]

    input_a.flush()
    input_b.flush()
    input_op.flush()

    # -------------------------------------------- #


    # ----------- Write into registers ----------- #

    AXI_ALU.write(0x10, input_a.physical_address)   #0x10 a      address port
    AXI_ALU.write(0x1c, input_b.physical_address)   #0x1c b      address port
    AXI_ALU.write(0x34, input_op.physical_address)  #0x34 op     address port 
    AXI_ALU.write(0x40, selec)                      #0x40 selec  address port
    AXI_ALU.write(0x28, output.physical_address)    #0x28 output address port 

    AXI_ALU.write(0x00,0x1)  # ALU_sys IP starts (ap_start = 1)

    # -------------------------------------------- #


    # ---- polling ----- #

    start_hw = time.time()  # Hardware Time counter starts here

    while (AXI_ALU.read(0x00) & 0x4) != 4: #0x4 != 4 --> exit when in idle (better) 
            pass                           #0x2 != 2 --> exit when ap_done high 

    end_hw   = time.time()  # Hardware Time counter ends here

    # ----------------- #
    
    time_list_ALU_sys.append(end_hw - start_hw) # Store this HW time value into the HW list

    output.sync_from_device()

    compare_ALU_sys.append(eye(sw_result, output)) # Check if Hardware and Software results are equal
    
# -------------------------------------- End of ALU_sys PL ------------------------------------------- #


# ------ ALU_sys behavior ----- #

mismatch = 0

if (selec != 0):

    for i in compare_ALU_sys:
        if i == 0:
            mismatch += 1
            
    if mismatch == 0:
        print("ALU_sys Hardware Behaved CORRECTLY")
    else:
        print("There are", mismatch, "WRONG transactions.")

# ---------------------------- #


# ------- SISD behavior ------- # 

mismatch = 0

if (selec != 0):

    for i in compare_SISD:
        if i == 0:
            mismatch += 1
            
    if mismatch == 0:
        print("SISD Hardware Behaved CORRECTLY\n")
    else:
        print("There are ", mismatch, " WRONG computation.\n")

# ---------------------------- #


# ------ ALU_sys timing ------ # 

time_sum = 0

for i in time_list_ALU_sys:
    time_sum += i
    
average_hw = time_sum/len(time_list_ALU_sys)

# ---------------------------- #


# ----- Software timing ----- # 

time_sum = 0

for i in time_list_sw:
    time_sum += i

average_sw = time_sum/len(time_list_sw)

# ---------------------------- #


# ------- SISD timing ------- # 

time_sum = 0

for i in time_list_SISD:
    time_sum += i
    
average_SISD = (time_sum/len(time_list_SISD))*(burst_size)

# ---------------------------- #


# ----- Printing Results ---- #

print("SOFTWARE average time: ", round(average_sw, 6), "s")

print("SISD     average time: ", round(average_SISD, 6),"s")

print("ALU_sys  average time: ", round(average_hw, 7), "s\n")

print("SISD    Speed-Up on Python: ", round(average_sw/average_SISD, 2), "x")

print("ALU_sys Speed-Up on Python: ", round(average_sw/average_hw, 2), "x")

print("ALU_sys Speed-Up on   SISD: ", round(average_SISD/average_hw, 2), "x\n")

# ---------------------------- #

