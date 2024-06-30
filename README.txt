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
├─ ASH_OHW_paper                    # Project documentation 
├─ ASH_OHW_PWP                      # A power point presentation of the project
├─ README.md                        # github README file
└─ README.txt                       # txt version of the README

</pre>

## Instructions to build and test project
   
> [!NOTE]
> You can directly go to STEP 2 using the 'ALU_sys_HDL.xpr.zip' Archived Project. From this VHDL project you can simply start to synthesize, implement and run the bitstream with all the files created with the previous STEP (the implementation hasn't been uploaded because it had too large dimension). 

<pre>
   
#STEP 1 --> Vitis HLS 2023.2
   
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

   
#STEP 2 --> Vivado 2023.2
   
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

# STEP 3 --> Jupyter Environment
   
-- First Step
   
   Select the bitstream that has to be run: there are 4 different bitstreams that can be run.
   It is possible to choose the ASH bitstream under the label:
   
# --------------------------------------- ALU_sys PL ------------------------------------------------ #

   Cancel the # from the bitstream that has to be tested.
   Use just one bitstream, the other ones must be commented on. 

- Second Step

	Select the right value for the burst at the beginning of the program depending on the bitstream used.
	The value of the burst size can be only 50, 100, 200, or 400.

	i.e. burst_size          = 400

	It MUST NOT be changed during the run of the program. 
	It can be changed only when a kernel restart is made. 

-- Third Step
	
	selec must be equal to 0 or 2 the first time the program runs.

	i.e. selec=2
	
	Transactions must be an integer number bigger than 0 

	ie: transactions =1

	press the button to restart the kernel and re-run the notebook.
	See the results at the end of the notebook.
   
--Fourth Step

	Now selec value can change, the value can be 0, 1, 2 or Others.
	Now transaction can change.
	Run the second and the third cell of the Python
	See the results

	The fourth step can be repeated multiple times
</pre>
