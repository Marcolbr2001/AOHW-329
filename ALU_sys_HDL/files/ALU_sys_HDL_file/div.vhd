library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity div is
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

        data_id         : in std_logic_vector(ADDRESS_WIDTH-1 downto 0);

		s_axis_tvalid	: in std_logic;
		s_axis_tdata_a	: in std_logic_vector(TDATA_WIDTH-1 downto 0);
		s_axis_tdata_b	: in std_logic_vector(TDATA_WIDTH-1 downto 0);
		s_axis_tready	: out std_logic;

		m_axis_tvalid	: out std_logic;
		m_axis_tdata	: out std_logic_vector(TDATA_WIDTH-1 downto 0);
		m_axis_tready	: in std_logic;

        mem_id          : in std_logic_vector(ADDRESS_WIDTH-1 downto 0)
	);
end div;

architecture Behavioral of div is
    
    component ALU_sys_HDL_sdiv_32s_32s_32_36_1_divider is
    generic (
        in0_WIDTH   : INTEGER :=32;
        in1_WIDTH   : INTEGER :=32;
        out_WIDTH   : INTEGER :=32);
    port (
        clk         : in  STD_LOGIC;
        reset       : in  STD_LOGIC;
        ce          : in  STD_LOGIC;
        dividend    : in  STD_LOGIC_VECTOR(in0_WIDTH-1 downto 0);
        divisor     : in  STD_LOGIC_VECTOR(in1_WIDTH-1 downto 0);
        sign_i      : in  STD_LOGIC_VECTOR(1 downto 0);
        sign_o      : out STD_LOGIC_VECTOR(1 downto 0);
        quot        : out STD_LOGIC_VECTOR(out_WIDTH-1 downto 0);
        remd        : out STD_LOGIC_VECTOR(out_WIDTH-1 downto 0));

end component;

    signal data_in_a 		: std_logic_vector(TDATA_WIDTH-1 downto 0) := (Others => '0');
    signal data_in_b 		: std_logic_vector(TDATA_WIDTH-1 downto 0) := (Others => '0');

    signal data_id_sgn      : std_logic_vector(ADDRESS_WIDTH-1 downto 0) := (Others => '0');

    signal data_out 		: std_logic_vector(TDATA_WIDTH-1 downto 0) := (Others => '0');

    signal div_step 		: std_logic_vector(TDATA_WIDTH-1 downto 0) := (Others => '0');

    signal delay_count 		: integer range 0 to 49 := 0;

    -------------  State variable -----------
    type state is (IDLE, RECEIVE,  DIV, DIV_DELAY_1, SEND);  
    signal fsm_state : state := IDLE;
    -----------------------------------------

    signal quot, remd    : std_logic_vector(TDATA_WIDTH-1 downto 0) := (Others => '0');

begin

    divid:ALU_sys_HDL_sdiv_32s_32s_32_36_1_divider
    port map
    (
    
        clk         => ap_clk,
        reset       => ap_rst,
        ce          => '1',
        dividend    => data_in_a,
        divisor     => data_in_b,
        sign_i      => "00",
        quot        => quot,
        remd        => remd
    
    );

    -- SLAVE --
    with fsm_state select s_axis_tready <= 
        '1' when RECEIVE,
        '0' when Others;    
    
    -- MASTER --
    m_axis_tvalid <= '1' when fsm_state = SEND and data_id_sgn = mem_id else '0'; 

    m_axis_tdata <=quot when fsm_state = SEND else (Others => '-');

    FSM_DIV : process (ap_clk)
    begin
        if rising_edge(ap_clk) then
            if (ap_rst = '1') then
    
                data_in_a 	    <= (Others => '0');
                data_in_b 		<= (Others => '0');

                data_out 		<= (Others => '0');

                fsm_state           <= IDLE;   
    
            else
    
                case (fsm_state) is	

                    When IDLE => 

                        if (ap_start = '1' and ALU_start = '1') then
                                
                            fsm_state 			<= RECEIVE;
                        
                        else
                            
                            fsm_state           <= IDLE;
                            
                        end if;

                    when RECEIVE =>	

                        if (unsigned(mem_id) = DATA_LENGTH) then
                        
                            data_id_sgn         <= (Others => '0');
                            fsm_state           <= IDLE;
                            
                        elsif (s_axis_tvalid = '1') then

                            data_in_a	    <= s_axis_tdata_a;
                            data_in_b	    <= s_axis_tdata_b;

                            data_id_sgn     <= data_id;

                            fsm_state 		<= DIV;

                        else 

                            fsm_state 		<= RECEIVE;

                        end if;
                                                                                                                                    
                    when DIV =>             

                            if (delay_count = 49) then
                        
                                fsm_state           <= SEND;
                                delay_count         <= 0;

                            else 
                                         
                                delay_count         <= delay_count + 1;
                                
                            end if;
                                
                    when SEND =>                                                                
                        
                        if (m_axis_tready = '1' and data_id_sgn = mem_id) then -- and controller is at the right position 
                                       	   
                            fsm_state           <= RECEIVE;

                        end if;

                    when Others =>        

                        fsm_state               <= IDLE;
                                                
                end case;
            end if;
        end if;
    end process;                                                              
end Behavioral;
