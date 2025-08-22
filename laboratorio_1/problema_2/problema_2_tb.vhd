library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity problema_2_tb is
end problema_2_tb;

architecture Behavioral of problema_2_tb is

  component problema_2
    port (
      A1    : in  std_logic_vector(3 downto 0);
      B1    : in  std_logic_vector(3 downto 0);
      Cin1  : in  std_logic;
      Cout1 : out std_logic;
      Y1    : out std_logic_vector(3 downto 0)
    );
  end component;

  signal A1    : std_logic_vector(3 downto 0) := (others => '0');
  signal B1    : std_logic_vector(3 downto 0) := (others => '0');
  signal Cin1  : std_logic := '0';
  signal Cout1 : std_logic;
  signal Y1    : std_logic_vector(3 downto 0);

begin

  uut: problema_2
    port map (
      A1    => A1,
      B1    => B1,
      Cin1  => Cin1,
      Cout1 => Cout1,
      Y1    => Y1
    );

  stim: process
  begin
    A1 <= "0000"; B1 <= "0000"; Cin1 <= '0';
    wait for 20 ns;

    A1 <= "1010"; B1 <= "1000"; Cin1 <= '0';
    wait for 20 ns;

    A1 <= "1010"; B1 <= "1000"; Cin1 <= '1';
    wait for 20 ns;

    A1 <= "0000"; B1 <= "1110"; Cin1 <= '1';
    wait for 20 ns;

    A1 <= "0000"; B1 <= "1111"; Cin1 <= '1';
    wait for 20 ns;

    wait;
  end process;

end Behavioral;
