-- ==============================================================
-- Generated by Vitis HLS v2023.2
-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
-- ==============================================================

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ALU_sys_HDL_op_data_exe_wb_Pipeline_l_operation is
port (
    ap_clk : IN STD_LOGIC;
    ap_rst : IN STD_LOGIC;
    ap_start : IN STD_LOGIC;
    ap_done : OUT STD_LOGIC;
    ap_idle : OUT STD_LOGIC;
    ap_ready : OUT STD_LOGIC;
    m_axi_gmem3_AWVALID : OUT STD_LOGIC;
    m_axi_gmem3_AWREADY : IN STD_LOGIC;
    m_axi_gmem3_AWADDR : OUT STD_LOGIC_VECTOR (63 downto 0);
    m_axi_gmem3_AWID : OUT STD_LOGIC_VECTOR (0 downto 0);
    m_axi_gmem3_AWLEN : OUT STD_LOGIC_VECTOR (31 downto 0);
    m_axi_gmem3_AWSIZE : OUT STD_LOGIC_VECTOR (2 downto 0);
    m_axi_gmem3_AWBURST : OUT STD_LOGIC_VECTOR (1 downto 0);
    m_axi_gmem3_AWLOCK : OUT STD_LOGIC_VECTOR (1 downto 0);
    m_axi_gmem3_AWCACHE : OUT STD_LOGIC_VECTOR (3 downto 0);
    m_axi_gmem3_AWPROT : OUT STD_LOGIC_VECTOR (2 downto 0);
    m_axi_gmem3_AWQOS : OUT STD_LOGIC_VECTOR (3 downto 0);
    m_axi_gmem3_AWREGION : OUT STD_LOGIC_VECTOR (3 downto 0);
    m_axi_gmem3_AWUSER : OUT STD_LOGIC_VECTOR (0 downto 0);
    m_axi_gmem3_WVALID : OUT STD_LOGIC;
    m_axi_gmem3_WREADY : IN STD_LOGIC;
    m_axi_gmem3_WDATA : OUT STD_LOGIC_VECTOR (31 downto 0);
    m_axi_gmem3_WSTRB : OUT STD_LOGIC_VECTOR (3 downto 0);
    m_axi_gmem3_WLAST : OUT STD_LOGIC;
    m_axi_gmem3_WID : OUT STD_LOGIC_VECTOR (0 downto 0);
    m_axi_gmem3_WUSER : OUT STD_LOGIC_VECTOR (0 downto 0);
    m_axi_gmem3_ARVALID : OUT STD_LOGIC;
    m_axi_gmem3_ARREADY : IN STD_LOGIC;
    m_axi_gmem3_ARADDR : OUT STD_LOGIC_VECTOR (63 downto 0);
    m_axi_gmem3_ARID : OUT STD_LOGIC_VECTOR (0 downto 0);
    m_axi_gmem3_ARLEN : OUT STD_LOGIC_VECTOR (31 downto 0);
    m_axi_gmem3_ARSIZE : OUT STD_LOGIC_VECTOR (2 downto 0);
    m_axi_gmem3_ARBURST : OUT STD_LOGIC_VECTOR (1 downto 0);
    m_axi_gmem3_ARLOCK : OUT STD_LOGIC_VECTOR (1 downto 0);
    m_axi_gmem3_ARCACHE : OUT STD_LOGIC_VECTOR (3 downto 0);
    m_axi_gmem3_ARPROT : OUT STD_LOGIC_VECTOR (2 downto 0);
    m_axi_gmem3_ARQOS : OUT STD_LOGIC_VECTOR (3 downto 0);
    m_axi_gmem3_ARREGION : OUT STD_LOGIC_VECTOR (3 downto 0);
    m_axi_gmem3_ARUSER : OUT STD_LOGIC_VECTOR (0 downto 0);
    m_axi_gmem3_RVALID : IN STD_LOGIC;
    m_axi_gmem3_RREADY : OUT STD_LOGIC;
    m_axi_gmem3_RDATA : IN STD_LOGIC_VECTOR (31 downto 0);
    m_axi_gmem3_RLAST : IN STD_LOGIC;
    m_axi_gmem3_RID : IN STD_LOGIC_VECTOR (0 downto 0);
    m_axi_gmem3_RFIFONUM : IN STD_LOGIC_VECTOR (8 downto 0);
    m_axi_gmem3_RUSER : IN STD_LOGIC_VECTOR (0 downto 0);
    m_axi_gmem3_RRESP : IN STD_LOGIC_VECTOR (1 downto 0);
    m_axi_gmem3_BVALID : IN STD_LOGIC;
    m_axi_gmem3_BREADY : OUT STD_LOGIC;
    m_axi_gmem3_BRESP : IN STD_LOGIC_VECTOR (1 downto 0);
    m_axi_gmem3_BID : IN STD_LOGIC_VECTOR (0 downto 0);
    m_axi_gmem3_BUSER : IN STD_LOGIC_VECTOR (0 downto 0);
    ALU_operation_din : OUT STD_LOGIC_VECTOR (31 downto 0);
    ALU_operation_full_n : IN STD_LOGIC;
    ALU_operation_write : OUT STD_LOGIC;
    op : IN STD_LOGIC_VECTOR (63 downto 0) );
end;


architecture behav of ALU_sys_HDL_op_data_exe_wb_Pipeline_l_operation is 
    constant ap_const_logic_1 : STD_LOGIC := '1';
    constant ap_const_logic_0 : STD_LOGIC := '0';
    constant ap_ST_fsm_pp0_stage0 : STD_LOGIC_VECTOR (0 downto 0) := "1";
    constant ap_const_lv32_0 : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000000";
    constant ap_const_boolean_1 : BOOLEAN := true;
    constant ap_const_boolean_0 : BOOLEAN := false;
    constant ap_const_lv1_1 : STD_LOGIC_VECTOR (0 downto 0) := "1";
    constant ap_const_lv64_0 : STD_LOGIC_VECTOR (63 downto 0) := "0000000000000000000000000000000000000000000000000000000000000000";
    constant ap_const_lv1_0 : STD_LOGIC_VECTOR (0 downto 0) := "0";
    constant ap_const_lv3_0 : STD_LOGIC_VECTOR (2 downto 0) := "000";
    constant ap_const_lv2_0 : STD_LOGIC_VECTOR (1 downto 0) := "00";
    constant ap_const_lv4_0 : STD_LOGIC_VECTOR (3 downto 0) := "0000";
    constant ap_const_lv32_1 : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000001";
    constant ap_const_lv9_0 : STD_LOGIC_VECTOR (8 downto 0) := "000000000";
    constant ap_const_lv9_190 : STD_LOGIC_VECTOR (8 downto 0) := "110010000";
    constant ap_const_lv9_1 : STD_LOGIC_VECTOR (8 downto 0) := "000000001";
    constant ap_const_lv32_2 : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000010";
    constant ap_const_lv32_3F : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000111111";

attribute shreg_extract : string;
    signal ap_CS_fsm : STD_LOGIC_VECTOR (0 downto 0) := "1";
    attribute fsm_encoding : string;
    attribute fsm_encoding of ap_CS_fsm : signal is "none";
    signal ap_CS_fsm_pp0_stage0 : STD_LOGIC;
    attribute fsm_encoding of ap_CS_fsm_pp0_stage0 : signal is "none";
    signal ap_enable_reg_pp0_iter0 : STD_LOGIC;
    signal ap_enable_reg_pp0_iter1 : STD_LOGIC := '0';
    signal ap_enable_reg_pp0_iter2 : STD_LOGIC := '0';
    signal ap_enable_reg_pp0_iter3 : STD_LOGIC := '0';
    signal ap_enable_reg_pp0_iter4 : STD_LOGIC := '0';
    signal ap_enable_reg_pp0_iter5 : STD_LOGIC := '0';
    signal ap_enable_reg_pp0_iter6 : STD_LOGIC := '0';
    signal ap_enable_reg_pp0_iter7 : STD_LOGIC := '0';
    signal ap_enable_reg_pp0_iter8 : STD_LOGIC := '0';
    signal ap_enable_reg_pp0_iter9 : STD_LOGIC := '0';
    signal ap_enable_reg_pp0_iter10 : STD_LOGIC := '0';
    signal ap_idle_pp0 : STD_LOGIC;
    signal ap_block_state10_pp0_stage0_iter9 : BOOLEAN;
    signal ap_block_state11_pp0_stage0_iter10 : BOOLEAN;
    signal ap_block_pp0_stage0_subdone : BOOLEAN;
    signal icmp_ln81_fu_99_p2 : STD_LOGIC_VECTOR (0 downto 0);
    signal ap_condition_exit_pp0_iter0_stage0 : STD_LOGIC;
    signal ap_loop_exit_ready : STD_LOGIC;
    signal ap_ready_int : STD_LOGIC;
    signal gmem3_blk_n_AR : STD_LOGIC;
    signal ap_block_pp0_stage0 : BOOLEAN;
    signal gmem3_blk_n_R : STD_LOGIC;
    signal ALU_operation_blk_n : STD_LOGIC;
    signal ap_block_pp0_stage0_11001 : BOOLEAN;
    signal gmem3_addr_reg_165 : STD_LOGIC_VECTOR (63 downto 0);
    signal tmp_op_reg_171 : STD_LOGIC_VECTOR (31 downto 0);
    signal sext_ln85_fu_139_p1 : STD_LOGIC_VECTOR (63 downto 0);
    signal i_fu_62 : STD_LOGIC_VECTOR (8 downto 0) := "000000000";
    signal add_ln81_fu_105_p2 : STD_LOGIC_VECTOR (8 downto 0);
    signal ap_loop_init : STD_LOGIC;
    signal ap_sig_allocacmp_i_5 : STD_LOGIC_VECTOR (8 downto 0);
    signal ap_block_pp0_stage0_01001 : BOOLEAN;
    signal shl_ln_fu_111_p3 : STD_LOGIC_VECTOR (10 downto 0);
    signal zext_ln85_fu_119_p1 : STD_LOGIC_VECTOR (63 downto 0);
    signal add_ln85_fu_123_p2 : STD_LOGIC_VECTOR (63 downto 0);
    signal trunc_ln_fu_129_p4 : STD_LOGIC_VECTOR (61 downto 0);
    signal ap_done_reg : STD_LOGIC := '0';
    signal ap_continue_int : STD_LOGIC;
    signal ap_done_int : STD_LOGIC;
    signal ap_loop_exit_ready_pp0_iter1_reg : STD_LOGIC;
    signal ap_loop_exit_ready_pp0_iter2_reg : STD_LOGIC;
    signal ap_loop_exit_ready_pp0_iter3_reg : STD_LOGIC;
    signal ap_loop_exit_ready_pp0_iter4_reg : STD_LOGIC;
    signal ap_loop_exit_ready_pp0_iter5_reg : STD_LOGIC;
    signal ap_loop_exit_ready_pp0_iter6_reg : STD_LOGIC;
    signal ap_loop_exit_ready_pp0_iter7_reg : STD_LOGIC;
    signal ap_loop_exit_ready_pp0_iter8_reg : STD_LOGIC;
    signal ap_loop_exit_ready_pp0_iter9_reg : STD_LOGIC;
    signal ap_NS_fsm : STD_LOGIC_VECTOR (0 downto 0);
    signal ap_enable_pp0 : STD_LOGIC;
    signal ap_start_int : STD_LOGIC;
    signal ap_ce_reg : STD_LOGIC;

    component ALU_sys_HDL_flow_control_loop_pipe_sequential_init IS
    port (
        ap_clk : IN STD_LOGIC;
        ap_rst : IN STD_LOGIC;
        ap_start : IN STD_LOGIC;
        ap_ready : OUT STD_LOGIC;
        ap_done : OUT STD_LOGIC;
        ap_start_int : OUT STD_LOGIC;
        ap_loop_init : OUT STD_LOGIC;
        ap_ready_int : IN STD_LOGIC;
        ap_loop_exit_ready : IN STD_LOGIC;
        ap_loop_exit_done : IN STD_LOGIC;
        ap_continue_int : OUT STD_LOGIC;
        ap_done_int : IN STD_LOGIC );
    end component;



begin
    flow_control_loop_pipe_sequential_init_U : component ALU_sys_HDL_flow_control_loop_pipe_sequential_init
    port map (
        ap_clk => ap_clk,
        ap_rst => ap_rst,
        ap_start => ap_start,
        ap_ready => ap_ready,
        ap_done => ap_done,
        ap_start_int => ap_start_int,
        ap_loop_init => ap_loop_init,
        ap_ready_int => ap_ready_int,
        ap_loop_exit_ready => ap_condition_exit_pp0_iter0_stage0,
        ap_loop_exit_done => ap_done_int,
        ap_continue_int => ap_continue_int,
        ap_done_int => ap_done_int);





    ap_CS_fsm_assign_proc : process(ap_clk)
    begin
        if (ap_clk'event and ap_clk =  '1') then
            if (ap_rst = '1') then
                ap_CS_fsm <= ap_ST_fsm_pp0_stage0;
            else
                ap_CS_fsm <= ap_NS_fsm;
            end if;
        end if;
    end process;


    ap_done_reg_assign_proc : process(ap_clk)
    begin
        if (ap_clk'event and ap_clk =  '1') then
            if (ap_rst = '1') then
                ap_done_reg <= ap_const_logic_0;
            else
                if ((ap_continue_int = ap_const_logic_1)) then 
                    ap_done_reg <= ap_const_logic_0;
                elsif (((ap_loop_exit_ready_pp0_iter9_reg = ap_const_logic_1) and (ap_const_boolean_0 = ap_block_pp0_stage0_subdone))) then 
                    ap_done_reg <= ap_const_logic_1;
                end if; 
            end if;
        end if;
    end process;


    ap_enable_reg_pp0_iter1_assign_proc : process(ap_clk)
    begin
        if (ap_clk'event and ap_clk =  '1') then
            if (ap_rst = '1') then
                ap_enable_reg_pp0_iter1 <= ap_const_logic_0;
            else
                if ((ap_const_logic_1 = ap_condition_exit_pp0_iter0_stage0)) then 
                    ap_enable_reg_pp0_iter1 <= ap_const_logic_0;
                elsif (((ap_const_logic_1 = ap_CS_fsm_pp0_stage0) and (ap_const_boolean_0 = ap_block_pp0_stage0_subdone))) then 
                    ap_enable_reg_pp0_iter1 <= ap_start_int;
                end if; 
            end if;
        end if;
    end process;


    ap_enable_reg_pp0_iter10_assign_proc : process(ap_clk)
    begin
        if (ap_clk'event and ap_clk =  '1') then
            if (ap_rst = '1') then
                ap_enable_reg_pp0_iter10 <= ap_const_logic_0;
            else
                if ((ap_const_boolean_0 = ap_block_pp0_stage0_subdone)) then 
                    ap_enable_reg_pp0_iter10 <= ap_enable_reg_pp0_iter9;
                end if; 
            end if;
        end if;
    end process;


    ap_enable_reg_pp0_iter2_assign_proc : process(ap_clk)
    begin
        if (ap_clk'event and ap_clk =  '1') then
            if (ap_rst = '1') then
                ap_enable_reg_pp0_iter2 <= ap_const_logic_0;
            else
                if ((ap_const_boolean_0 = ap_block_pp0_stage0_subdone)) then 
                    ap_enable_reg_pp0_iter2 <= ap_enable_reg_pp0_iter1;
                end if; 
            end if;
        end if;
    end process;


    ap_enable_reg_pp0_iter3_assign_proc : process(ap_clk)
    begin
        if (ap_clk'event and ap_clk =  '1') then
            if (ap_rst = '1') then
                ap_enable_reg_pp0_iter3 <= ap_const_logic_0;
            else
                if ((ap_const_boolean_0 = ap_block_pp0_stage0_subdone)) then 
                    ap_enable_reg_pp0_iter3 <= ap_enable_reg_pp0_iter2;
                end if; 
            end if;
        end if;
    end process;


    ap_enable_reg_pp0_iter4_assign_proc : process(ap_clk)
    begin
        if (ap_clk'event and ap_clk =  '1') then
            if (ap_rst = '1') then
                ap_enable_reg_pp0_iter4 <= ap_const_logic_0;
            else
                if ((ap_const_boolean_0 = ap_block_pp0_stage0_subdone)) then 
                    ap_enable_reg_pp0_iter4 <= ap_enable_reg_pp0_iter3;
                end if; 
            end if;
        end if;
    end process;


    ap_enable_reg_pp0_iter5_assign_proc : process(ap_clk)
    begin
        if (ap_clk'event and ap_clk =  '1') then
            if (ap_rst = '1') then
                ap_enable_reg_pp0_iter5 <= ap_const_logic_0;
            else
                if ((ap_const_boolean_0 = ap_block_pp0_stage0_subdone)) then 
                    ap_enable_reg_pp0_iter5 <= ap_enable_reg_pp0_iter4;
                end if; 
            end if;
        end if;
    end process;


    ap_enable_reg_pp0_iter6_assign_proc : process(ap_clk)
    begin
        if (ap_clk'event and ap_clk =  '1') then
            if (ap_rst = '1') then
                ap_enable_reg_pp0_iter6 <= ap_const_logic_0;
            else
                if ((ap_const_boolean_0 = ap_block_pp0_stage0_subdone)) then 
                    ap_enable_reg_pp0_iter6 <= ap_enable_reg_pp0_iter5;
                end if; 
            end if;
        end if;
    end process;


    ap_enable_reg_pp0_iter7_assign_proc : process(ap_clk)
    begin
        if (ap_clk'event and ap_clk =  '1') then
            if (ap_rst = '1') then
                ap_enable_reg_pp0_iter7 <= ap_const_logic_0;
            else
                if ((ap_const_boolean_0 = ap_block_pp0_stage0_subdone)) then 
                    ap_enable_reg_pp0_iter7 <= ap_enable_reg_pp0_iter6;
                end if; 
            end if;
        end if;
    end process;


    ap_enable_reg_pp0_iter8_assign_proc : process(ap_clk)
    begin
        if (ap_clk'event and ap_clk =  '1') then
            if (ap_rst = '1') then
                ap_enable_reg_pp0_iter8 <= ap_const_logic_0;
            else
                if ((ap_const_boolean_0 = ap_block_pp0_stage0_subdone)) then 
                    ap_enable_reg_pp0_iter8 <= ap_enable_reg_pp0_iter7;
                end if; 
            end if;
        end if;
    end process;


    ap_enable_reg_pp0_iter9_assign_proc : process(ap_clk)
    begin
        if (ap_clk'event and ap_clk =  '1') then
            if (ap_rst = '1') then
                ap_enable_reg_pp0_iter9 <= ap_const_logic_0;
            else
                if ((ap_const_boolean_0 = ap_block_pp0_stage0_subdone)) then 
                    ap_enable_reg_pp0_iter9 <= ap_enable_reg_pp0_iter8;
                end if; 
            end if;
        end if;
    end process;


    i_fu_62_assign_proc : process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if (((ap_const_logic_1 = ap_CS_fsm_pp0_stage0) and (ap_const_boolean_0 = ap_block_pp0_stage0_11001))) then
                if (((ap_enable_reg_pp0_iter0 = ap_const_logic_1) and (icmp_ln81_fu_99_p2 = ap_const_lv1_0))) then 
                    i_fu_62 <= add_ln81_fu_105_p2;
                elsif ((ap_loop_init = ap_const_logic_1)) then 
                    i_fu_62 <= ap_const_lv9_0;
                end if;
            end if; 
        end if;
    end process;
    process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if (((ap_const_logic_1 = ap_CS_fsm_pp0_stage0) and (ap_const_boolean_0 = ap_block_pp0_stage0_11001))) then
                ap_loop_exit_ready_pp0_iter1_reg <= ap_loop_exit_ready;
                ap_loop_exit_ready_pp0_iter2_reg <= ap_loop_exit_ready_pp0_iter1_reg;
                gmem3_addr_reg_165 <= sext_ln85_fu_139_p1;
            end if;
        end if;
    end process;
    process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if ((ap_const_boolean_0 = ap_block_pp0_stage0_11001)) then
                ap_loop_exit_ready_pp0_iter3_reg <= ap_loop_exit_ready_pp0_iter2_reg;
                ap_loop_exit_ready_pp0_iter4_reg <= ap_loop_exit_ready_pp0_iter3_reg;
                ap_loop_exit_ready_pp0_iter5_reg <= ap_loop_exit_ready_pp0_iter4_reg;
                ap_loop_exit_ready_pp0_iter6_reg <= ap_loop_exit_ready_pp0_iter5_reg;
                ap_loop_exit_ready_pp0_iter7_reg <= ap_loop_exit_ready_pp0_iter6_reg;
                ap_loop_exit_ready_pp0_iter8_reg <= ap_loop_exit_ready_pp0_iter7_reg;
                ap_loop_exit_ready_pp0_iter9_reg <= ap_loop_exit_ready_pp0_iter8_reg;
                tmp_op_reg_171 <= m_axi_gmem3_RDATA;
            end if;
        end if;
    end process;

    ap_NS_fsm_assign_proc : process (ap_CS_fsm)
    begin
        case ap_CS_fsm is
            when ap_ST_fsm_pp0_stage0 => 
                ap_NS_fsm <= ap_ST_fsm_pp0_stage0;
            when others =>  
                ap_NS_fsm <= "X";
        end case;
    end process;

    ALU_operation_blk_n_assign_proc : process(ap_enable_reg_pp0_iter10, ALU_operation_full_n, ap_block_pp0_stage0)
    begin
        if (((ap_enable_reg_pp0_iter10 = ap_const_logic_1) and (ap_const_boolean_0 = ap_block_pp0_stage0))) then 
            ALU_operation_blk_n <= ALU_operation_full_n;
        else 
            ALU_operation_blk_n <= ap_const_logic_1;
        end if; 
    end process;

    ALU_operation_din <= tmp_op_reg_171;

    ALU_operation_write_assign_proc : process(ap_enable_reg_pp0_iter10, ap_block_pp0_stage0_11001)
    begin
        if (((ap_enable_reg_pp0_iter10 = ap_const_logic_1) and (ap_const_boolean_0 = ap_block_pp0_stage0_11001))) then 
            ALU_operation_write <= ap_const_logic_1;
        else 
            ALU_operation_write <= ap_const_logic_0;
        end if; 
    end process;

    add_ln81_fu_105_p2 <= std_logic_vector(unsigned(ap_sig_allocacmp_i_5) + unsigned(ap_const_lv9_1));
    add_ln85_fu_123_p2 <= std_logic_vector(unsigned(zext_ln85_fu_119_p1) + unsigned(op));
    ap_CS_fsm_pp0_stage0 <= ap_CS_fsm(0);
        ap_block_pp0_stage0 <= not((ap_const_boolean_1 = ap_const_boolean_1));

    ap_block_pp0_stage0_01001_assign_proc : process(ap_enable_reg_pp0_iter9, ap_enable_reg_pp0_iter10, ap_block_state10_pp0_stage0_iter9, ap_block_state11_pp0_stage0_iter10)
    begin
                ap_block_pp0_stage0_01001 <= (((ap_enable_reg_pp0_iter10 = ap_const_logic_1) and (ap_const_boolean_1 = ap_block_state11_pp0_stage0_iter10)) or ((ap_enable_reg_pp0_iter9 = ap_const_logic_1) and (ap_const_boolean_1 = ap_block_state10_pp0_stage0_iter9)));
    end process;


    ap_block_pp0_stage0_11001_assign_proc : process(ap_enable_reg_pp0_iter1, ap_enable_reg_pp0_iter9, ap_enable_reg_pp0_iter10, m_axi_gmem3_ARREADY, ap_block_state10_pp0_stage0_iter9, ap_block_state11_pp0_stage0_iter10)
    begin
                ap_block_pp0_stage0_11001 <= (((ap_enable_reg_pp0_iter10 = ap_const_logic_1) and (ap_const_boolean_1 = ap_block_state11_pp0_stage0_iter10)) or ((ap_enable_reg_pp0_iter9 = ap_const_logic_1) and (ap_const_boolean_1 = ap_block_state10_pp0_stage0_iter9)) or ((m_axi_gmem3_ARREADY = ap_const_logic_0) and (ap_enable_reg_pp0_iter1 = ap_const_logic_1)));
    end process;


    ap_block_pp0_stage0_subdone_assign_proc : process(ap_enable_reg_pp0_iter1, ap_enable_reg_pp0_iter9, ap_enable_reg_pp0_iter10, m_axi_gmem3_ARREADY, ap_block_state10_pp0_stage0_iter9, ap_block_state11_pp0_stage0_iter10)
    begin
                ap_block_pp0_stage0_subdone <= (((ap_enable_reg_pp0_iter10 = ap_const_logic_1) and (ap_const_boolean_1 = ap_block_state11_pp0_stage0_iter10)) or ((ap_enable_reg_pp0_iter9 = ap_const_logic_1) and (ap_const_boolean_1 = ap_block_state10_pp0_stage0_iter9)) or ((m_axi_gmem3_ARREADY = ap_const_logic_0) and (ap_enable_reg_pp0_iter1 = ap_const_logic_1)));
    end process;


    ap_block_state10_pp0_stage0_iter9_assign_proc : process(m_axi_gmem3_RVALID)
    begin
                ap_block_state10_pp0_stage0_iter9 <= (m_axi_gmem3_RVALID = ap_const_logic_0);
    end process;


    ap_block_state11_pp0_stage0_iter10_assign_proc : process(ALU_operation_full_n)
    begin
                ap_block_state11_pp0_stage0_iter10 <= (ap_const_logic_0 = ALU_operation_full_n);
    end process;


    ap_condition_exit_pp0_iter0_stage0_assign_proc : process(ap_CS_fsm_pp0_stage0, ap_enable_reg_pp0_iter0, ap_block_pp0_stage0_subdone, icmp_ln81_fu_99_p2)
    begin
        if (((ap_enable_reg_pp0_iter0 = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_pp0_stage0) and (icmp_ln81_fu_99_p2 = ap_const_lv1_1) and (ap_const_boolean_0 = ap_block_pp0_stage0_subdone))) then 
            ap_condition_exit_pp0_iter0_stage0 <= ap_const_logic_1;
        else 
            ap_condition_exit_pp0_iter0_stage0 <= ap_const_logic_0;
        end if; 
    end process;


    ap_done_int_assign_proc : process(ap_block_pp0_stage0_subdone, ap_done_reg, ap_loop_exit_ready_pp0_iter9_reg)
    begin
        if (((ap_loop_exit_ready_pp0_iter9_reg = ap_const_logic_1) and (ap_const_boolean_0 = ap_block_pp0_stage0_subdone))) then 
            ap_done_int <= ap_const_logic_1;
        else 
            ap_done_int <= ap_done_reg;
        end if; 
    end process;

    ap_enable_pp0 <= (ap_idle_pp0 xor ap_const_logic_1);
    ap_enable_reg_pp0_iter0 <= ap_start_int;

    ap_idle_assign_proc : process(ap_CS_fsm_pp0_stage0, ap_idle_pp0, ap_start_int)
    begin
        if (((ap_idle_pp0 = ap_const_logic_1) and (ap_start_int = ap_const_logic_0) and (ap_const_logic_1 = ap_CS_fsm_pp0_stage0))) then 
            ap_idle <= ap_const_logic_1;
        else 
            ap_idle <= ap_const_logic_0;
        end if; 
    end process;


    ap_idle_pp0_assign_proc : process(ap_enable_reg_pp0_iter0, ap_enable_reg_pp0_iter1, ap_enable_reg_pp0_iter2, ap_enable_reg_pp0_iter3, ap_enable_reg_pp0_iter4, ap_enable_reg_pp0_iter5, ap_enable_reg_pp0_iter6, ap_enable_reg_pp0_iter7, ap_enable_reg_pp0_iter8, ap_enable_reg_pp0_iter9, ap_enable_reg_pp0_iter10)
    begin
        if (((ap_enable_reg_pp0_iter10 = ap_const_logic_0) and (ap_enable_reg_pp0_iter9 = ap_const_logic_0) and (ap_enable_reg_pp0_iter8 = ap_const_logic_0) and (ap_enable_reg_pp0_iter7 = ap_const_logic_0) and (ap_enable_reg_pp0_iter6 = ap_const_logic_0) and (ap_enable_reg_pp0_iter5 = ap_const_logic_0) and (ap_enable_reg_pp0_iter4 = ap_const_logic_0) and (ap_enable_reg_pp0_iter3 = ap_const_logic_0) and (ap_enable_reg_pp0_iter2 = ap_const_logic_0) and (ap_enable_reg_pp0_iter1 = ap_const_logic_0) and (ap_enable_reg_pp0_iter0 = ap_const_logic_0))) then 
            ap_idle_pp0 <= ap_const_logic_1;
        else 
            ap_idle_pp0 <= ap_const_logic_0;
        end if; 
    end process;

    ap_loop_exit_ready <= ap_condition_exit_pp0_iter0_stage0;

    ap_ready_int_assign_proc : process(ap_CS_fsm_pp0_stage0, ap_enable_reg_pp0_iter0, ap_block_pp0_stage0_subdone)
    begin
        if (((ap_enable_reg_pp0_iter0 = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_pp0_stage0) and (ap_const_boolean_0 = ap_block_pp0_stage0_subdone))) then 
            ap_ready_int <= ap_const_logic_1;
        else 
            ap_ready_int <= ap_const_logic_0;
        end if; 
    end process;


    ap_sig_allocacmp_i_5_assign_proc : process(ap_CS_fsm_pp0_stage0, ap_block_pp0_stage0, i_fu_62, ap_loop_init)
    begin
        if (((ap_const_logic_1 = ap_CS_fsm_pp0_stage0) and (ap_loop_init = ap_const_logic_1) and (ap_const_boolean_0 = ap_block_pp0_stage0))) then 
            ap_sig_allocacmp_i_5 <= ap_const_lv9_0;
        else 
            ap_sig_allocacmp_i_5 <= i_fu_62;
        end if; 
    end process;


    gmem3_blk_n_AR_assign_proc : process(ap_CS_fsm_pp0_stage0, ap_enable_reg_pp0_iter1, m_axi_gmem3_ARREADY, ap_block_pp0_stage0)
    begin
        if (((ap_enable_reg_pp0_iter1 = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_pp0_stage0) and (ap_const_boolean_0 = ap_block_pp0_stage0))) then 
            gmem3_blk_n_AR <= m_axi_gmem3_ARREADY;
        else 
            gmem3_blk_n_AR <= ap_const_logic_1;
        end if; 
    end process;


    gmem3_blk_n_R_assign_proc : process(ap_enable_reg_pp0_iter9, m_axi_gmem3_RVALID, ap_block_pp0_stage0)
    begin
        if (((ap_enable_reg_pp0_iter9 = ap_const_logic_1) and (ap_const_boolean_0 = ap_block_pp0_stage0))) then 
            gmem3_blk_n_R <= m_axi_gmem3_RVALID;
        else 
            gmem3_blk_n_R <= ap_const_logic_1;
        end if; 
    end process;

    icmp_ln81_fu_99_p2 <= "1" when (ap_sig_allocacmp_i_5 = ap_const_lv9_190) else "0";
    m_axi_gmem3_ARADDR <= gmem3_addr_reg_165;
    m_axi_gmem3_ARBURST <= ap_const_lv2_0;
    m_axi_gmem3_ARCACHE <= ap_const_lv4_0;
    m_axi_gmem3_ARID <= ap_const_lv1_0;
    m_axi_gmem3_ARLEN <= ap_const_lv32_1;
    m_axi_gmem3_ARLOCK <= ap_const_lv2_0;
    m_axi_gmem3_ARPROT <= ap_const_lv3_0;
    m_axi_gmem3_ARQOS <= ap_const_lv4_0;
    m_axi_gmem3_ARREGION <= ap_const_lv4_0;
    m_axi_gmem3_ARSIZE <= ap_const_lv3_0;
    m_axi_gmem3_ARUSER <= ap_const_lv1_0;

    m_axi_gmem3_ARVALID_assign_proc : process(ap_CS_fsm_pp0_stage0, ap_enable_reg_pp0_iter1, ap_block_pp0_stage0_11001)
    begin
        if (((ap_enable_reg_pp0_iter1 = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_pp0_stage0) and (ap_const_boolean_0 = ap_block_pp0_stage0_11001))) then 
            m_axi_gmem3_ARVALID <= ap_const_logic_1;
        else 
            m_axi_gmem3_ARVALID <= ap_const_logic_0;
        end if; 
    end process;

    m_axi_gmem3_AWADDR <= ap_const_lv64_0;
    m_axi_gmem3_AWBURST <= ap_const_lv2_0;
    m_axi_gmem3_AWCACHE <= ap_const_lv4_0;
    m_axi_gmem3_AWID <= ap_const_lv1_0;
    m_axi_gmem3_AWLEN <= ap_const_lv32_0;
    m_axi_gmem3_AWLOCK <= ap_const_lv2_0;
    m_axi_gmem3_AWPROT <= ap_const_lv3_0;
    m_axi_gmem3_AWQOS <= ap_const_lv4_0;
    m_axi_gmem3_AWREGION <= ap_const_lv4_0;
    m_axi_gmem3_AWSIZE <= ap_const_lv3_0;
    m_axi_gmem3_AWUSER <= ap_const_lv1_0;
    m_axi_gmem3_AWVALID <= ap_const_logic_0;
    m_axi_gmem3_BREADY <= ap_const_logic_0;

    m_axi_gmem3_RREADY_assign_proc : process(ap_enable_reg_pp0_iter9, ap_block_pp0_stage0_11001)
    begin
        if (((ap_enable_reg_pp0_iter9 = ap_const_logic_1) and (ap_const_boolean_0 = ap_block_pp0_stage0_11001))) then 
            m_axi_gmem3_RREADY <= ap_const_logic_1;
        else 
            m_axi_gmem3_RREADY <= ap_const_logic_0;
        end if; 
    end process;

    m_axi_gmem3_WDATA <= ap_const_lv32_0;
    m_axi_gmem3_WID <= ap_const_lv1_0;
    m_axi_gmem3_WLAST <= ap_const_logic_0;
    m_axi_gmem3_WSTRB <= ap_const_lv4_0;
    m_axi_gmem3_WUSER <= ap_const_lv1_0;
    m_axi_gmem3_WVALID <= ap_const_logic_0;
        sext_ln85_fu_139_p1 <= std_logic_vector(IEEE.numeric_std.resize(signed(trunc_ln_fu_129_p4),64));

    shl_ln_fu_111_p3 <= (ap_sig_allocacmp_i_5 & ap_const_lv2_0);
    trunc_ln_fu_129_p4 <= add_ln85_fu_123_p2(63 downto 2);
    zext_ln85_fu_119_p1 <= std_logic_vector(IEEE.numeric_std.resize(unsigned(shl_ln_fu_111_p3),64));
end behav;
