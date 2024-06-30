library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity pp_buf is
	Generic (
		TDATA_WIDTH		: positive  := 32;
		DATA_LENGTH     : integer   := 400;
		ADDRESS_WIDTH   : integer   := 9
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

        m_axis_tid      : out std_logic_vector(ADDRESS_WIDTH-1 downto 0)
    );
end pp_buf;


architecture Behavioral of pp_buf is

    constant PP_DEPTH           : integer := DATA_LENGTH/2;
    constant ADD_WIDTH          : integer := m_axis_tid'length;

    signal counter_PING         : integer range 0 to DATA_LENGTH := 0;
    signal counter_PONG         : integer range 0 to DATA_LENGTH := 0;

    signal s_axis_tvalid        : std_logic := '0';
    signal s_axis_tready        : std_logic := '0';
    
    signal m_axis_tid_sgn_PING  : std_logic_vector(ADD_WIDTH-1  downto 0) := (Others => '0'); -- AXIS index
    signal m_axis_tid_sgn_PONG  : std_logic_vector(ADD_WIDTH-1  downto 0) := (Others => '0');
    
    ------- regs to store PP values -------- 
    type signal_register_my_type is array (0 to PP_DEPTH - 1) of std_logic_vector(TDATA_WIDTH - 1 DOWNTO 0);
    
    signal memory_a_PING		: signal_register_my_type := (Others => (Others => '0'));
    signal memory_b_PING		: signal_register_my_type := (Others => (Others => '0'));
    signal memory_a_PONG		: signal_register_my_type := (Others => (Others => '0'));
    signal memory_b_PONG		: signal_register_my_type := (Others => (Others => '0'));
    -----------------------------------------

    -------------  State variable -----------
    type state is (IDLE, RECEIVE, SEND);  
    
    signal fsm_state_PING : state := IDLE;
    signal fsm_state_PONG : state := IDLE;
    -----------------------------------------

begin

    -- SLAVE --
    s_axis_tvalid<= s_axis_tvalid_a and s_axis_tvalid_b;
    
    s_axis_tready_a <= s_axis_tready;
    s_axis_tready_b <= s_axis_tready;
    
    s_axis_tready   <= '1' when ((fsm_state_PING = RECEIVE and (counter_PING <= PP_DEPTH - 1)) or
                                ((fsm_state_PONG = RECEIVE and fsm_state_PING /= RECEIVE) and (counter_PONG <= PP_DEPTH - 1))) else '0';
        
    -- MASTER --
    m_axis_tid      <= m_axis_tid_sgn_PONG when fsm_state_PONG = SEND and fsm_state_PING /= SEND else
                       m_axis_tid_sgn_PING when fsm_state_PING = SEND;

    m_axis_tvalid   <= '1'	when (((fsm_state_PING = SEND) and (unsigned(m_axis_tid_sgn_PING) <= PP_DEPTH - 1)) or 
                                 ((fsm_state_PONG = SEND and fsm_state_PING /= SEND) and ((unsigned(m_axis_tid_sgn_PONG) > PP_DEPTH - 1) and unsigned(m_axis_tid_sgn_PONG) <= DATA_LENGTH - 1))) else '0';
    
    m_axis_tdata_a <= memory_a_PING(counter_PING) when (fsm_state_PING = SEND)  else
                      memory_a_PONG(counter_PONG) when (fsm_state_PONG = SEND and (fsm_state_PING /= SEND))  else (Others=>'-');
       
    m_axis_tdata_b <= memory_b_PING(counter_PING) when (fsm_state_PING = SEND)  else
                      memory_b_PONG(counter_PONG) when (fsm_state_PONG = SEND and (fsm_state_PING /= SEND))  else (Others=>'-'); 

    -- PING and PONG are two state machines that interface with each other; 
    -- while one is in a state of receiving data, the other is in a state of sending data, and vice versa.

    FSM_PING : process (ap_clk)
    begin
        if rising_edge(ap_clk) then
            if (ap_rst = '1') then
   
                m_axis_tid_sgn_PING 		<= (Others => '0');

                fsm_state_PING           <= IDLE;   
    
            else
    
                case (fsm_state_PING) is	

                    When IDLE => 
                        
                        m_axis_tid_sgn_PING          <= (Others => '0');

                        counter_PING                 <= 0;

                        memory_a_PING                <= (Others => (Others => '0'));
                        memory_b_PING                <= (Others => (Others => '0'));
                        
                        if(ap_start = '1' and ALU_start='1') then

                            fsm_state_PING 			<= RECEIVE;

                        end if;

                    when RECEIVE =>	 

                        if (s_axis_tvalid = '1' and counter_PING = PP_DEPTH-1) then

                            memory_a_PING 	    <= s_axis_tdata_a & memory_a_PING(0 to memory_a_PING'length - 2);
                            memory_b_PING 	    <= s_axis_tdata_b & memory_b_PING(0 to memory_a_PING'length - 2);
                            
                            fsm_state_PING 		<= SEND;

                        elsif (s_axis_tvalid = '1' and (counter_PING <= PP_DEPTH - 1)) then
        
                            memory_a_PING 	    <= s_axis_tdata_a & memory_a_PING(0 to memory_a_PING'length - 2);
                            memory_b_PING 	    <= s_axis_tdata_b & memory_b_PING(0 to memory_a_PING'length - 2);

                            counter_PING      <= counter_PING + 1;

                            fsm_state_PING 		<= RECEIVE;

                        else 

                            fsm_state_PING 		<= RECEIVE;

                        end if;

                    when SEND =>                                                                

                        if (m_axis_tready = '1' and counter_PING = 0) then    
                                          
                            fsm_state_PING           <= IDLE;
                                
                        elsif (m_axis_tready = '1' and (counter_PING > 0)) then
                        
                            m_axis_tid_sgn_PING      <= std_logic_vector(unsigned(m_axis_tid_sgn_PING) + 1);
                            counter_PING             <= counter_PING - 1;
                            fsm_state_PING           <= SEND;

                        else

                            fsm_state_PING           <= SEND;

                        end if;
                            
                    when Others =>        

                        fsm_state_PING               <= IDLE;
                                                
                end case;
            end if;
        end if;
    end process; 
    
    
    FSM_PONG : process (ap_clk)
    begin
        if rising_edge(ap_clk) then
            if (ap_rst = '1') then
    
                m_axis_tid_sgn_PONG 		<= std_logic_vector(to_unsigned(PP_DEPTH,ADD_WIDTH));

                fsm_state_PONG           <= IDLE;   
    
            else
    
                case (fsm_state_PONG) is	

                    When IDLE => 
                        
                        m_axis_tid_sgn_PONG          <= std_logic_vector(to_unsigned(PP_DEPTH,ADD_WIDTH));

                        counter_PONG                 <= 0;

                        memory_a_PONG                <= (Others => (Others => '0'));
                        memory_b_PONG                <= (Others => (Others => '0'));
                        
                        if(ap_start = '1' and ALU_start='1') then

                            fsm_state_PONG 			<= RECEIVE;

                        end if;

                    when RECEIVE =>	 
                        
                        if (s_axis_tvalid = '1' and counter_PONG = PP_DEPTH-1 and (fsm_state_PING = SEND or fsm_state_PING = IDLE)) then

                            memory_a_PONG 	    <= s_axis_tdata_a & memory_a_PONG(0 to memory_a_PONG'length - 2);
                            memory_b_PONG 	    <= s_axis_tdata_b & memory_b_PONG(0 to memory_a_PONG'length - 2);
                            
                            fsm_state_PONG 		<= SEND;

                        elsif (s_axis_tvalid = '1' and (counter_PONG <= PP_DEPTH - 1) and (fsm_state_PING = SEND or fsm_state_PING = IDLE)) then
        
                            memory_a_PONG 	    <= s_axis_tdata_a & memory_a_PONG(0 to memory_a_PONG'length - 2);
                            memory_b_PONG 	    <= s_axis_tdata_b & memory_b_PONG(0 to memory_b_PONG'length - 2);

                            counter_PONG      <= counter_PONG + 1;

                            fsm_state_PONG 		<= RECEIVE;

                        else 

                            fsm_state_PONG 		<= RECEIVE;

                        end if;
                    
                    when SEND =>                                                                

                        if (m_axis_tready = '1' and counter_PONG = 0 and fsm_state_PING = IDLE) then    
                                          
                            fsm_state_PONG           <= IDLE;
                                
                        elsif (m_axis_tready = '1' and (counter_PONG > 0) and fsm_state_PING = IDLE) then
                        
                            m_axis_tid_sgn_PONG      <= std_logic_vector(unsigned(m_axis_tid_sgn_PONG) + 1);
                            counter_PONG             <= counter_PONG - 1;
                            fsm_state_PONG           <= SEND;

                        else

                            fsm_state_PONG           <= SEND;

                        end if;
                                                 
                    when Others =>        

                        fsm_state_PONG               <= IDLE;
                                                
                end case;
            end if;
        end if;
    end process;                                                             
end Behavioral;