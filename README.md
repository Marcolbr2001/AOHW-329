# AOHW24-329 Registration
## Info & Description

|                         | Information   |
| -------------           | ------------- |
| Team Number             | AOHW-329      |
| Project Name            | High-Speed System Communication and Caching Enhancement for RegEx Matching  |
| YouTube's Video         | https://youtu.be/B9i5I3WfR30 |
| Project's Repository    | https://github.com/Marcolbr2001/AOHW-329.git    |
| University Name         | Politecnico di Milano      |
| Participant (email)     | Filippo Carloni (filippo.carloni@polimi.it)      |
| Participant (email)     | Marco La Barbera (marco.labarbera@mail.polimi.it)      |
| Participant (email)     | Giulio Lotto (giulio.lotto@mail.polimi.it)      |
| Supervisor name         | Davide Conficconi      |
| Supervisor email        | davide.conficconi@mail.polimi.it |
| Board used              | PYNQ Z2 |
| Software version        | Vivado 2023.2, Vitis HLS 2023.2 |

## Description of Archive

<pre>
├─ ALU_sys_HDL                      # It contains the core project
   └─ files                         # All the files stage by stage that had been used to build the entire project
   └─ Py                            # Python code to test the Hardware
   └─ ALU_sys_HDL.xpr.zip           # Vivado Archived Project, it has the block design already implemented (synthesis, implementation and bitstream has to be done)
   └─ ALU_sys_HDL.zip               # HLS Archived Project, it has the HLS generated file before our VHDL insertion
├─ SISD                             # The ALVEARE State-Of-Art communication protocol
   └─ files                         # HLS core.cpp and tb
   └─ SISD.xpr.zip                  # The SISD implementation
└─ ASH_Paper                        # Project documentation 

</pre>

## Instructions to build and test project
   
<pre>
   
#STEP 1
   
- Open VITIS HLS 2023.2
- Create a new HLS project
- Type as top_function ALU_sys_HDL and add
- Type as part 'xc7z020clg400-1' and add
- Right click on 'sources' and then 'add source file'
- Add 'core.cpp', you can find it in the 'files' folder
- Right click on 'Test Bench' and 'Add Test Bench File'
- Add 'test.cpp', you can find it in the 'files' folder
- Click 'Run C simulation'
- Click 'Run C Synthesis'
- [Optional] Click 'Run Cosimulation'
- Click on VHDL e select VIVADO XSIM and select OK
- Click on 'Run Implemetation'
- Select VHDL and press OK
- Click on 'Run Export RTL'
- Select as display format Vivado, type as display name ALU_sys_HDL and click OK

   
#STEP 2
   
- Unzip export folder created in the previous step, you will find the same folder already implemented in the 'files' folder, named 'HLS_generated'
- Open the 'ALU_sys_HDL_file' folder and copy all the files, you can find it in the 'files' folder
- Open the export folder and paste the files copied in 'ALU_sys_HDL_file', it will also replace some HLS generated VHDL files
- Open Vivado 2023.2
- Create a new project named ALU_sys_HDL
- Select as target language VHDL and select 'Add Files': select all the files that are in the 'export' folder, where you copy paste also our CHDL code, and click OK
- Select as Board the PYNQZ2 and click OK
- Once the new project is created select TOOLS --> PACKAGE YOUR CURRENT PROJECT --> CLICK NEXT --> SELECT THE LOCATION WHERE TO SAVE THE ip_repo
- In the window Package IP click Review Package and click package IP
- Import the ip_repo created in the project, you will find the same folder already implemented in the 'files' folder, named 'ip_repo' 
- Create block design
- Import in the block design ZYNQ processing system and 'Run Block Automation'
- Import in the block design the 'ALU_sys_HDL' ip_repo
- Add 4 HP slave
- Run connection automation, keep attention to specify axi-gmem_0, axi-gmem_1, axi-gmem_2 and axi-gmem_3 for HP slaves 1, 2 and 3
- Save the Block Design
- Create the HDL wrapper
- Select the HDL wrapper as top entity
- Generate the Bitstream
- Copy '.bit' file, '.tcl' file, '.hwh' file and change their names in 'ALU_sys_HDL_400.bit', 'ALU_sys_HDL_400.tcl' , 'ALU_sys_HDL_400.hwh' and copy them
- Insert the files in your Pynq folder to import Overlays
- Open Jupiter notebook, paste the Python code following the cell order
- Run the programm
   
</pre>
