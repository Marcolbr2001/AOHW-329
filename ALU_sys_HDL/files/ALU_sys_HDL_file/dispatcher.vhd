library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity dispatcher is
	Generic (
		TDATA_WIDTH		: positive := 32;
        DATA_LENGTH     : integer  := 400;
		ADDRESS_WIDTH   : integer  := 9
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
        s_axis_tid      : in std_logic_vector(ADDRESS_WIDTH-1 downto 0);

		m_axis_tvalid_sum	: out std_logic;
		m_axis_tdata_sum_a	: out std_logic_vector(TDATA_WIDTH-1 downto 0);
        m_axis_tdata_sum_b	: out std_logic_vector(TDATA_WIDTH-1 downto 0);
		m_axis_tready_sum	: in std_logic;
        m_axis_tid_sum      : out std_logic_vector(ADDRESS_WIDTH-1 downto 0);

        m_axis_tvalid_sub	: out std_logic;
		m_axis_tdata_sub_a	: out std_logic_vector(TDATA_WIDTH-1 downto 0);
        m_axis_tdata_sub_b	: out std_logic_vector(TDATA_WIDTH-1 downto 0);
		m_axis_tready_sub	: in std_logic;
        m_axis_tid_sub      : out std_logic_vector(ADDRESS_WIDTH-1 downto 0);

        m_axis_tvalid_div	: out std_logic;
		m_axis_tdata_div_a	: out std_logic_vector(TDATA_WIDTH-1 downto 0);
        m_axis_tdata_div_b	: out std_logic_vector(TDATA_WIDTH-1 downto 0);
		m_axis_tready_div	: in std_logic;
        m_axis_tid_div      : out std_logic_vector(ADDRESS_WIDTH-1 downto 0);

        m_axis_tvalid_mul	: out std_logic;
		m_axis_tdata_mul_a	: out std_logic_vector(TDATA_WIDTH-1 downto 0);
        m_axis_tdata_mul_b	: out std_logic_vector(TDATA_WIDTH-1 downto 0);
		m_axis_tready_mul	: in std_logic;
        m_axis_tid_mul      : out std_logic_vector(ADDRESS_WIDTH-1 downto 0);

        RAM_address         : out std_logic_vector(ADDRESS_WIDTH-1 downto 0);
        RAM_value           : in std_logic_vector(TDATA_WIDTH-1 downto 0)

	);
end dispatcher;

architecture Behavioral of dispatcher is

    signal data_a	          : std_logic_vector(TDATA_WIDTH-1 downto 0) := (Others=>'0');
    signal data_b	          : std_logic_vector(TDATA_WIDTH-1 downto 0) := (Others=>'0');

    signal RAM_address_sgn    : std_logic_vector(ADDRESS_WIDTH-1 downto 0);

    -------------  State variable -----------
    type state is (IDLE, ASK_RAM, WAIT_RAM, WAIT_RAM_2, DISPATCHER);  
    signal fsm_state : state := IDLE;
    -----------------------------------------

begin

    -- SLAVE --
    with fsm_state select s_axis_tready <= 
        '1' when ASK_RAM,
        '0' when Others;
    
    -- MASTER --
  
    -- SUM --
    m_axis_tdata_sum_a  <= data_a when fsm_state = DISPATCHER and unsigned(RAM_value) = to_unsigned(0, 32) else (Others => '-');
    m_axis_tdata_sum_b  <= data_b when fsm_state = DISPATCHER and unsigned(RAM_value) = to_unsigned(0, 32) else (Others => '-');
    
    m_axis_tvalid_sum   <= '1' when fsm_state = DISPATCHER and unsigned(RAM_value) = to_unsigned(0, 32) else '0';

    m_axis_tid_sum      <= RAM_address_sgn when fsm_state = DISPATCHER and unsigned(RAM_value) = to_unsigned(0, 32) and m_axis_tready_sum = '1' else (Others => '-');


    -- SUB --
    m_axis_tdata_sub_a  <= data_a when fsm_state = DISPATCHER and unsigned(RAM_value) = to_unsigned(1, 32) else (Others => '-');
    m_axis_tdata_sub_b  <= data_b when fsm_state = DISPATCHER and unsigned(RAM_value) = to_unsigned(1, 32) else (Others => '-'); 
    
    m_axis_tvalid_sub   <= '1' when fsm_state = DISPATCHER and unsigned(RAM_value) = to_unsigned(1, 32) else '0';
        
    m_axis_tid_sub      <= RAM_address_sgn when fsm_state = DISPATCHER and unsigned(RAM_value) = to_unsigned(1, 32) and m_axis_tready_sub = '1' else (Others => '-');


    -- DIV --
    m_axis_tdata_div_a  <= data_a when fsm_state = DISPATCHER and unsigned(RAM_value) = to_unsigned(2, 32) else (Others => '-');
    m_axis_tdata_div_b  <= data_b when fsm_state = DISPATCHER and unsigned(RAM_value) = to_unsigned(2, 32) else (Others => '-'); 
    
    m_axis_tvalid_div   <= '1' when fsm_state = DISPATCHER and unsigned(RAM_value) = to_unsigned(2, 32) else '0';

    m_axis_tid_div      <= RAM_address_sgn when fsm_state = DISPATCHER and unsigned(RAM_value) = to_unsigned(2, 32) and m_axis_tready_div = '1' else (Others => '-');

    -- MUL --    
    m_axis_tdata_mul_a  <= data_a when fsm_state = DISPATCHER and unsigned(RAM_value) = to_unsigned(3, 32) else (Others => '-');
    m_axis_tdata_mul_b  <= data_b when fsm_state = DISPATCHER and unsigned(RAM_value) = to_unsigned(3, 32) else (Others => '-'); 

    m_axis_tvalid_mul   <= '1' when fsm_state = DISPATCHER and unsigned(RAM_value) = to_unsigned(3, 32) else '0';

    m_axis_tid_mul      <= RAM_address_sgn when fsm_state = DISPATCHER and unsigned(RAM_value) = to_unsigned(3, 32) and m_axis_tready_mul = '1' else (Others => '-');

    RAM_address         <= RAM_address_sgn;

    FSM_MUTE : process (ap_clk)
    begin
        if rising_edge(ap_clk) then
            
            if (ap_rst = '1') then

                fsm_state           <= IDLE;   
    
            else
    
                case (fsm_state) is	

                    When IDLE => 

                        if (ap_start = '1' and ALU_start = '1') then
                                
                            fsm_state 			<= ASK_RAM;
                        
                        else
                            
                            fsm_state           <= IDLE;
                            
                        end if;

                    when ASK_RAM =>	

                        if (s_axis_tvalid = '1') then

                            data_a	        <= s_axis_tdata_a;
                            data_b	        <= s_axis_tdata_b;

                            RAM_address_sgn     <= s_axis_tid;

                            fsm_state 		<= WAIT_RAM;

                        else 

                            fsm_state 		<= ASK_RAM;

                        end if;

                    when WAIT_RAM =>

                        fsm_state <= WAIT_RAM_2;
                    
                    when WAIT_RAM_2 =>

                        fsm_state <= DISPATCHER;

                    when DISPATCHER =>

                            if      (RAM_value = "00000000000000000000000000000001") then
                            
                                if (m_axis_tready_sub = '1') then 

                                    if (unsigned(RAM_address_sgn) = DATA_LENGTH - 1) then
                                        
                                        RAM_address_sgn     <= (Others => '0');
                                        fsm_state           <= IDLE;

                                    else
                                        
                                        fsm_state           <= ASK_RAM;

                                    end if;

                                end if;

                            elsif   (RAM_value = "00000000000000000000000000000010") then

                                if (m_axis_tready_div = '1') then 

                                    if (unsigned(RAM_address_sgn) = DATA_LENGTH - 1) then
                                            
                                        RAM_address_sgn     <= (Others => '0');
                                        fsm_state           <= IDLE;

                                    else
                                        
                                        fsm_state           <= ASK_RAM;

                                    end if;
        
                                end if;
    
                            elsif   (RAM_value = "00000000000000000000000000000011") then
                            
                                if (m_axis_tready_mul = '1') then 

                                    if (unsigned(RAM_address_sgn) = DATA_LENGTH - 1) then
                                            
                                        RAM_address_sgn     <= (Others => '0');
                                        fsm_state           <= IDLE;

                                    else
                                        
                                        fsm_state           <= ASK_RAM;

                                    end if;
        
                                end if;
    
                            else -- if   (RAM_value = "0000000000000000000000000000000") then
    
                                if (m_axis_tready_sum = '1') then 

                                    if (unsigned(RAM_address_sgn) = DATA_LENGTH - 1) then
                                            
                                        RAM_address_sgn     <= (Others => '0');
                                        fsm_state           <= IDLE;

                                    else
                                        
                                        fsm_state           <= ASK_RAM;

                                    end if;
        
                                end if;
    
                            end if;

                    when Others =>        

                        fsm_state               <= IDLE;
                                                
                end case;
            end if;
            
        end if;
    end process;                                                              
end Behavioral;
