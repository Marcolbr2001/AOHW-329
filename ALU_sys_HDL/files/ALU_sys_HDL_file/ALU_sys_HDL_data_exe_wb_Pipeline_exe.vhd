library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ALU_sys_HDL_data_exe_wb_Pipeline_exe is
generic(
    DATA_LENGTH   : integer := 400;
    ADDRESS_WIDTH : integer := 9
);
port (
    ap_clk  : IN STD_LOGIC;
    ap_rst  : IN STD_LOGIC;
    ap_start : IN STD_LOGIC;
    ap_done  : OUT STD_LOGIC;
    ap_idle  : OUT STD_LOGIC;
    ap_ready : OUT STD_LOGIC;

    data_a_dout     : IN STD_LOGIC_VECTOR (31 downto 0);
    data_a_empty_n  : IN STD_LOGIC;
    data_a_read     : OUT STD_LOGIC;

    data_b_dout     : IN STD_LOGIC_VECTOR (31 downto 0);
    data_b_empty_n  : IN STD_LOGIC;
    data_b_read     : OUT STD_LOGIC;

    data_result_din     : OUT STD_LOGIC_VECTOR (31 downto 0);
    data_result_full_n  : IN STD_LOGIC;
    data_result_write   : OUT STD_LOGIC;

    ALU_operation_MEM_address0 : OUT STD_LOGIC_VECTOR (ADDRESS_WIDTH-1 downto 0);
    ALU_operation_MEM_ce0       : OUT STD_LOGIC;
    ALU_operation_MEM_q0        : IN STD_LOGIC_VECTOR (31 downto 0) 
    );
end;

architecture behav of ALU_sys_HDL_data_exe_wb_Pipeline_exe is 
    
    constant ADD_WIDTH          : integer   := ALU_operation_MEM_address0'length;

    signal data_a_read_sgn      : std_logic := '0';  
    signal data_b_read_sgn      : std_logic := '0';
        
    signal CE_pp                : std_logic := '0';
    signal ap_start_sgn         : std_logic := '0';
    signal ALU_start            : std_logic := '0';
    
    -- PP to DISPATCHER signals  --
    signal s_axis_tvalid_disp   : std_logic := '0';
    signal s_axis_tdata_a_disp  : std_logic_vector(31 downto 0) := (Others =>'0');
    signal s_axis_tdata_b_disp  : std_logic_vector(31 downto 0) := (Others =>'0');
    signal s_axis_tready_disp   : std_logic := '0';
    signal m_axis_tid_disp      : std_logic_vector(ADD_WIDTH-1 downto 0) := (Others =>'0');    
    -------------------------------

    -- DISPATCHER to SUM signals --
    signal s_axis_tvalid_sum    : std_logic := '0';
    signal s_axis_tdata_sum_a   : std_logic_vector (31 downto 0) := (Others=>'0');
    signal s_axis_tdata_sum_b   : std_logic_vector (31 downto 0) := (Others=>'0');
    signal s_axis_tready_sum    : std_logic := '0';
    -------------------------------

    -- DISPATCHER to SUB signals --
    signal s_axis_tvalid_sub    : std_logic := '0';
    signal s_axis_tdata_sub_a   : std_logic_vector (31 downto 0) := (Others=>'0');
    signal s_axis_tdata_sub_b   : std_logic_vector (31 downto 0) := (Others=>'0');
    signal s_axis_tready_sub    : std_logic := '0';
    -------------------------------

    -- DISPATCHER to MUL signals --
    signal s_axis_tvalid_mul    : std_logic := '0';
    signal s_axis_tdata_mul_a   : std_logic_vector (31 downto 0) := (Others=>'0');
    signal s_axis_tdata_mul_b   : std_logic_vector (31 downto 0) := (Others=>'0');
    signal s_axis_tready_mul    : std_logic := '0';
    -------------------------------

    -- DISPATCHER to DIV signals --
    signal s_axis_tvalid_div    : std_logic := '0';
    signal s_axis_tdata_div_a   : std_logic_vector (31 downto 0) := (Others=>'0');
    signal s_axis_tdata_div_b   : std_logic_vector (31 downto 0) := (Others=>'0');
    signal s_axis_tready_div    : std_logic := '0';
    -------------------------------

    -- SUM Master Port interface --
    signal FU_sum_m_axis_tvalid : STD_LOGIC := '0';
    signal FU_sum_m_axis_tdata  : std_logic_vector (31 downto 0) := (Others=>'0');
    signal FU_sum_m_axis_tready : STD_LOGIC := '0';
    -------------------------------

    -- SUB Master Port interface --
    signal FU_sub_m_axis_tvalid : STD_LOGIC := '0';
    signal FU_sub_m_axis_tdata  : std_logic_vector (31 downto 0) := (Others=>'0');
    signal FU_sub_m_axis_tready : STD_LOGIC :='0';
    -------------------------------
    
    -- MUL Master Port interface --
    signal FU_mul_m_axis_tvalid : STD_LOGIC := '0';
    signal FU_mul_m_axis_tdata  : std_logic_vector (31 downto 0) := (Others=>'0');
    signal FU_mul_m_axis_tready : STD_LOGIC := '0';
    -------------------------------

    -- DIV Master Port interface --
    signal FU_div_m_axis_tvalid : STD_LOGIC := '0';
    signal FU_div_m_axis_tdata  : std_logic_vector (31 downto 0) := (Others=>'0');
    signal FU_div_m_axis_tready : STD_LOGIC := '0';
    -------------------------------

    --     AXIS data indexes     --
    signal data_id_sum          : std_logic_vector (ADD_WIDTH-1 downto 0) := (Others=>'0');
    signal data_id_sub          : std_logic_vector (ADD_WIDTH-1 downto 0) := (Others=>'0');
    signal data_id_mul          : std_logic_vector (ADD_WIDTH-1 downto 0) := (Others=>'0');
    signal data_id_div          : std_logic_vector (ADD_WIDTH-1 downto 0) := (Others=>'0');
    -------------------------------

    signal counter : std_logic_vector (ADD_WIDTH-1 downto 0) := (Others => '0');                          -- Keep track of the written index of the out Memory

    signal ALU_operation_MEM_address0_sgn : std_logic_vector (ADD_WIDTH-1 downto 0) := (Others=>'0');     -- Signal of RAM address (operations are stored in this memory)
    
    -------------  State variable -----------
    type state is (IDLE, ALU);  
    signal fsm_state : state := IDLE;
    -----------------------------------------

    component sum is
        Generic (
            TDATA_WIDTH		: positive := 32;
            DATA_LENGTH     : integer  := DATA_LENGTH;
	        ADDRESS_WIDTH   : integer   := ADD_WIDTH
        );
        Port (
		ap_clk			: in std_logic;
		ap_rst			: in std_logic;

        ap_start        : in std_logic;
        ALU_start       : in std_logic;

        data_id         : in std_logic_vector(ADD_WIDTH-1 downto 0);

		s_axis_tvalid	: in std_logic;
		s_axis_tdata_a	: in std_logic_vector(TDATA_WIDTH-1 downto 0);
		s_axis_tdata_b	: in std_logic_vector(TDATA_WIDTH-1 downto 0);
		s_axis_tready	: out std_logic;

		m_axis_tvalid	: out std_logic;
		m_axis_tdata	: out std_logic_vector(TDATA_WIDTH-1 downto 0);
		m_axis_tready	: in std_logic;

        mem_id          : in std_logic_vector(ADD_WIDTH-1 downto 0)
	);
    end component;

    component sub is
        Generic (
            TDATA_WIDTH		: positive := 32;
            DATA_LENGTH     : integer  := DATA_LENGTH;
	        ADDRESS_WIDTH   : integer   := ADD_WIDTH
        );
        Port (
		ap_clk			: in std_logic;
		ap_rst			: in std_logic;

        ap_start        : in std_logic;
        ALU_start       : in std_logic;

        data_id         : in std_logic_vector(ADD_WIDTH-1 downto 0);

		s_axis_tvalid	: in std_logic;
		s_axis_tdata_a	: in std_logic_vector(TDATA_WIDTH-1 downto 0);
		s_axis_tdata_b	: in std_logic_vector(TDATA_WIDTH-1 downto 0);
		s_axis_tready	: out std_logic;

		m_axis_tvalid	: out std_logic;
		m_axis_tdata	: out std_logic_vector(TDATA_WIDTH-1 downto 0);
		m_axis_tready	: in std_logic;

        mem_id          : in std_logic_vector(ADD_WIDTH-1 downto 0)
	);
    end component;

    component mul is
        Generic (
            TDATA_WIDTH		: positive := 32;
            DATA_LENGTH     : integer  := DATA_LENGTH;
	        ADDRESS_WIDTH   : integer   := ADD_WIDTH
        );
        Port (
		ap_clk			: in std_logic;
		ap_rst			: in std_logic;

        ap_start        : in std_logic;
        ALU_start       : in std_logic;

        data_id         : in std_logic_vector(ADD_WIDTH-1 downto 0);

		s_axis_tvalid	: in std_logic;
		s_axis_tdata_a	: in std_logic_vector(TDATA_WIDTH-1 downto 0);
		s_axis_tdata_b	: in std_logic_vector(TDATA_WIDTH-1 downto 0);
		s_axis_tready	: out std_logic;

		m_axis_tvalid	: out std_logic;
		m_axis_tdata	: out std_logic_vector(TDATA_WIDTH-1 downto 0);
		m_axis_tready	: in std_logic;

        mem_id          : in std_logic_vector(ADD_WIDTH-1 downto 0)
	);
    end component;

    component div is
        Generic (
            TDATA_WIDTH		: positive := 32;
            DATA_LENGTH     : integer  := DATA_LENGTH;
	        ADDRESS_WIDTH   : integer   := ADD_WIDTH
        );
        Port (
		ap_clk			: in std_logic;
		ap_rst			: in std_logic;

        ap_start        : in std_logic;
        ALU_start       : in std_logic;

        data_id         : in std_logic_vector(ADD_WIDTH-1 downto 0);

		s_axis_tvalid	: in std_logic;
		s_axis_tdata_a	: in std_logic_vector(TDATA_WIDTH-1 downto 0);
		s_axis_tdata_b	: in std_logic_vector(TDATA_WIDTH-1 downto 0);
		s_axis_tready	: out std_logic;

		m_axis_tvalid	: out std_logic;
		m_axis_tdata	: out std_logic_vector(TDATA_WIDTH-1 downto 0);
		m_axis_tready	: in std_logic;

        mem_id          : in std_logic_vector(ADD_WIDTH-1 downto 0)
	);
    end component;

    component pp_buf is
        Generic (
            TDATA_WIDTH		: positive := 32;
            DATA_LENGTH : integer := DATA_LENGTH;
	        ADDRESS_WIDTH   : integer   := ADD_WIDTH
        );
        Port (
		ap_clk			: in std_logic;
		ap_rst			: in std_logic;

        ap_start        : in std_logic;
        ALU_start       : in std_logic;

		s_axis_tvalid_a	: in std_logic;
		s_axis_tdata_a	: in std_logic_vector(TDATA_WIDTH-1 downto 0);
		s_axis_tready_a	: out std_logic;

        s_axis_tvalid_b	: in std_logic;
		s_axis_tdata_b	: in std_logic_vector(TDATA_WIDTH-1 downto 0);
		s_axis_tready_b	: out std_logic;

        m_axis_tvalid	: out std_logic;
		m_axis_tdata_a	: out std_logic_vector(TDATA_WIDTH-1 downto 0);
        m_axis_tdata_b	: out std_logic_vector(TDATA_WIDTH-1 downto 0);
		m_axis_tready	: in std_logic;

        m_axis_tid      : out std_logic_vector(ADD_WIDTH-1 downto 0)
    );
    end component;
    
    component dispatcher is
	Generic (
		TDATA_WIDTH		: positive := 32;
        DATA_LENGTH     : integer  := DATA_LENGTH;
	    ADDRESS_WIDTH   : integer   := ADD_WIDTH
	);
	Port (
		ap_clk			: in std_logic;
		ap_rst			: in std_logic;

        ap_start        : in std_logic;
        ALU_start       : in std_logic;

		s_axis_tvalid	: in std_logic;
		s_axis_tdata_a	: in std_logic_vector(TDATA_WIDTH-1 downto 0);
        s_axis_tdata_b	: in std_logic_vector(TDATA_WIDTH-1 downto 0);
		s_axis_tready	: out std_logic;
        s_axis_tid      : in std_logic_vector(ADD_WIDTH-1 downto 0);

		m_axis_tvalid_sum	: out std_logic;
		m_axis_tdata_sum_a	: out std_logic_vector(TDATA_WIDTH-1 downto 0);
        m_axis_tdata_sum_b	: out std_logic_vector(TDATA_WIDTH-1 downto 0);
		m_axis_tready_sum	: in std_logic;
        m_axis_tid_sum      : out std_logic_vector(ADD_WIDTH-1 downto 0);

        m_axis_tvalid_sub	: out std_logic;
		m_axis_tdata_sub_a	: out std_logic_vector(TDATA_WIDTH-1 downto 0);
        m_axis_tdata_sub_b	: out std_logic_vector(TDATA_WIDTH-1 downto 0);
		m_axis_tready_sub	: in std_logic;
        m_axis_tid_sub      : out std_logic_vector(ADD_WIDTH-1 downto 0);

        m_axis_tvalid_div	: out std_logic;
		m_axis_tdata_div_a	: out std_logic_vector(TDATA_WIDTH-1 downto 0);
        m_axis_tdata_div_b	: out std_logic_vector(TDATA_WIDTH-1 downto 0);
		m_axis_tready_div	: in std_logic;
        m_axis_tid_div      : out std_logic_vector(ADD_WIDTH-1 downto 0);

        m_axis_tvalid_mul	: out std_logic;
		m_axis_tdata_mul_a	: out std_logic_vector(TDATA_WIDTH-1 downto 0);
        m_axis_tdata_mul_b	: out std_logic_vector(TDATA_WIDTH-1 downto 0);
		m_axis_tready_mul	: in std_logic;
        m_axis_tid_mul      : out std_logic_vector(ADD_WIDTH-1 downto 0);
        
        RAM_address         : out std_logic_vector(ADD_WIDTH-1 downto 0);
        RAM_value           : in std_logic_vector(TDATA_WIDTH-1 downto 0)

	);
end component;

begin

    ap_start_sgn <= ap_start;

    ping_pong_buffer : pp_buf

        Port Map(
            ap_clk			=> ap_clk,
            ap_rst			=> ap_rst,
            
            ap_start        => ap_start_sgn,
            ALU_start       => ALU_start,
    
            s_axis_tvalid_a	=> data_a_empty_n,
            s_axis_tdata_a	=> data_a_dout,
            s_axis_tready_a => data_a_read_sgn,
    
            s_axis_tvalid_b	=> data_b_empty_n,
            s_axis_tdata_b	=> data_b_dout,
            s_axis_tready_b	=> data_b_read_sgn,
    
            m_axis_tvalid	=> s_axis_tvalid_disp,
            m_axis_tdata_a	=> s_axis_tdata_a_disp,
            m_axis_tdata_b	=> s_axis_tdata_b_disp,
            m_axis_tready	=> s_axis_tready_disp,
            
            m_axis_tid      => m_axis_tid_disp
        );
       
     block_dispatch : dispatcher
        Port map(
            ap_clk			=> ap_clk,
            ap_rst			=> ap_rst,

            ap_start        => ap_start_sgn,
            ALU_start       => ALU_start,

            s_axis_tvalid	=> s_axis_tvalid_disp,
            s_axis_tdata_a	=> s_axis_tdata_a_disp,
            s_axis_tdata_b	=> s_axis_tdata_b_disp,
            s_axis_tready	=> s_axis_tready_disp,
            s_axis_tid      => m_axis_tid_disp,

            m_axis_tvalid_sum	=> s_axis_tvalid_sum,
            m_axis_tdata_sum_a	=> s_axis_tdata_sum_a,
            m_axis_tdata_sum_b	=> s_axis_tdata_sum_b,
            m_axis_tready_sum	=> s_axis_tready_sum,
            m_axis_tid_sum      => data_id_sum,

            m_axis_tvalid_sub	=> s_axis_tvalid_sub,
            m_axis_tdata_sub_a	=> s_axis_tdata_sub_a,
            m_axis_tdata_sub_b	=> s_axis_tdata_sub_b,
            m_axis_tready_sub	=> s_axis_tready_sub,
            m_axis_tid_sub      => data_id_sub,

            m_axis_tvalid_div	=> s_axis_tvalid_div,
            m_axis_tdata_div_a	=> s_axis_tdata_div_a,
            m_axis_tdata_div_b	=> s_axis_tdata_div_b,
            m_axis_tready_div	=> s_axis_tready_div,
            m_axis_tid_div      => data_id_div,

            m_axis_tvalid_mul	=> s_axis_tvalid_mul,
            m_axis_tdata_mul_a	=> s_axis_tdata_mul_a,
            m_axis_tdata_mul_b	=> s_axis_tdata_mul_b,
            m_axis_tready_mul	=> s_axis_tready_mul,
            m_axis_tid_mul      => data_id_mul,
            
            RAM_address         => ALU_operation_MEM_address0_sgn,
            RAM_value           => ALU_operation_MEM_q0

        );
	
        
    block_sum : sum 
        
        Port Map (
            ap_clk			=> ap_clk,
            ap_rst			=> ap_rst,

            ap_start        => ap_start_sgn,
            ALU_start       => ALU_start,
    
            data_id         => data_id_sum,
    
            s_axis_tvalid	=> s_axis_tvalid_sum,
            s_axis_tdata_a	=> s_axis_tdata_sum_a,
            s_axis_tdata_b	=> s_axis_tdata_sum_b,
            s_axis_tready	=> s_axis_tready_sum,
    
            m_axis_tvalid	=> FU_sum_m_axis_tvalid,
            m_axis_tdata	=> FU_sum_m_axis_tdata,
            m_axis_tready	=> FU_sum_m_axis_tready,
    
            mem_id          => counter
        );
    
    block_sub : sub 

        Port Map(
            ap_clk			=> ap_clk,
            ap_rst			=> ap_rst,
    
            ap_start        => ap_start_sgn,
            ALU_start       => ALU_start,

            data_id         => data_id_sub,
    
            s_axis_tvalid	=> s_axis_tvalid_sub,
            s_axis_tdata_a	=> s_axis_tdata_sub_a,
            s_axis_tdata_b	=> s_axis_tdata_sub_b,
            s_axis_tready	=> s_axis_tready_sub,
    
            m_axis_tvalid	=> FU_sub_m_axis_tvalid,
            m_axis_tdata	=> FU_sub_m_axis_tdata,
            m_axis_tready	=> FU_sub_m_axis_tready,
    
            mem_id          => counter
        );
        
        

    block_mul : mul

        Port Map(
            ap_clk			=> ap_clk,
            ap_rst			=> ap_rst,
    
            ap_start        => ap_start_sgn,
            ALU_start       => ALU_start,

            data_id         => data_id_mul,
    
            s_axis_tvalid	=> s_axis_tvalid_mul,
            s_axis_tdata_a	=> s_axis_tdata_mul_a,
            s_axis_tdata_b	=> s_axis_tdata_mul_b,
            s_axis_tready	=> s_axis_tready_mul,
    
            m_axis_tvalid	=> FU_mul_m_axis_tvalid,
            m_axis_tdata	=> FU_mul_m_axis_tdata,
            m_axis_tready	=> FU_mul_m_axis_tready,
    
            mem_id          => counter
        );

    block_div : div

        Port Map(
            ap_clk			=> ap_clk,
            ap_rst			=> ap_rst,
    
            ap_start        => ap_start_sgn,
            ALU_start       => ALU_start,

            data_id         => data_id_div,
    
            s_axis_tvalid	=> s_axis_tvalid_div,
            s_axis_tdata_a	=> s_axis_tdata_div_a,
            s_axis_tdata_b	=> s_axis_tdata_div_b,
            s_axis_tready	=> s_axis_tready_div,
    
            m_axis_tvalid	=> FU_div_m_axis_tvalid,
            m_axis_tdata	=> FU_div_m_axis_tdata,
            m_axis_tready	=> FU_div_m_axis_tready,
    
            mem_id          => counter
        );
        
         
    -------------- ap and out logic -----------------

    with fsm_state select ap_idle <=                                                                            -- ap_idle is asserted when FSM is in IDLE state, ALU goes in IDLE when a burst has been completed
        '1' when IDLE,
        '0' when Others;

    ap_done <=  '1' when ((fsm_state = ALU) and (unsigned(counter) = DATA_LENGTH)) else '0';                    -- ap_done is asserted when FSM is in SEND_DATA state and a burst has been completed

    ap_ready <= '1' when ((fsm_state = ALU) and (data_a_read_sgn = '1' and data_b_read_sgn = '1')) else '0';    -- ap_ready is asserted when FSM is in ALU state and pp_buf is at RECEIVE state


    ALU_operation_MEM_ce0       <= '1';                                                                         -- Keep always enabled the register at the RAM output
    
    ALU_operation_MEM_address0  <= ALU_operation_MEM_address0_sgn;

    data_a_read <=  data_a_read_sgn;
    data_b_read <=  data_b_read_sgn;
    
    FU_sum_m_axis_tready <= data_result_full_n;                                                                 -- Check if FIFO are not full
    FU_sub_m_axis_tready <= data_result_full_n;
    FU_mul_m_axis_tready <= data_result_full_n;
    FU_div_m_axis_tready <= data_result_full_n;    

    ---------------------------------------------------

    ALU_start <= ap_start when fsm_state = IDLE else '0';

    process(ap_clk)
    begin
        if(rising_edge(ap_clk)) then
            
            if(ap_rst = '1') then
                
                CE_pp <= '0';

                fsm_state   <= IDLE;

            else
            
                case (fsm_state) is	
                    
                    When IDLE => 
    
                        if (ap_start = '1') then
        
                            fsm_state   <= ALU;
                        else
        
                            fsm_state   <= IDLE;

                        end if;
      
                    when ALU =>	
    
                        if(unsigned(counter) = to_unsigned(DATA_LENGTH, ADD_WIDTH)) then
                            
                            counter             <= (Others => '0');
                            data_result_write   <= '0';
                            
                            fsm_state           <= IDLE;
    
                        else
                            
                            if (FU_sum_m_axis_tvalid = '1' and data_result_full_n = '1') then -- m_axis_tvalid is asserted high if the data correspond to the the right position in where has to be stored in out memory
                                
                                data_result_write   <= '1';                                     -- Inform FIFO that has to be written
                                data_result_din     <= FU_sum_m_axis_tdata;                     -- Data is outputted
                                counter             <= std_logic_vector(unsigned(counter) + 1); -- Memory id is refreshed and points to the new cell that has to be written
            
                            elsif (FU_sub_m_axis_tvalid = '1' and data_result_full_n = '1') then
                                
                                data_result_write   <= '1';
                                data_result_din     <= FU_sub_m_axis_tdata;
                                counter             <= std_logic_vector(unsigned(counter) + 1);
            
                            elsif (FU_mul_m_axis_tvalid = '1' and data_result_full_n = '1') then
            
                                data_result_write   <= '1';
                                data_result_din     <= FU_mul_m_axis_tdata;  
                                counter             <= std_logic_vector(unsigned(counter) + 1);
            
                            elsif (FU_div_m_axis_tvalid = '1' and data_result_full_n = '1') then
                                                                                               
                                data_result_write   <= '1';
                                data_result_din     <= FU_div_m_axis_tdata; 
                                counter             <= std_logic_vector(unsigned(counter) + 1);
                            
                            else
    
                                data_result_write <= '0';
    
                            end if;
    
                        end if;  
    
                    when Others =>
                    
                        fsm_state <= IDLE;
                        
                end case;
                
            end if;

        end if;
    end process;

end behav;
