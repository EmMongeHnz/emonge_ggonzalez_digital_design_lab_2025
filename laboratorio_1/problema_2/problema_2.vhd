-- problema_2.vhd (fragmento relevante)
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity problema_2 is
  generic (
    ACTIVE_LOW_7SEG : boolean := true
  );
  port(
    A1    : in  std_logic_vector(3 downto 0);
    B1    : in  std_logic_vector(3 downto 0);
    Cin1  : in  std_logic;
    Cout1 : out std_logic;
    Y1    : out std_logic_vector(3 downto 0);
    HEX_A : out std_logic_vector(6 downto 0);  -- gfedcba
    HEX_B : out std_logic_vector(6 downto 0);
    HEX   : out std_logic_vector(6 downto 0)
  );
end entity;

architecture Behavioral of problema_2 is
  component restador is
    port(A,B,Cin: in std_logic; Y: out std_logic; Cout: out std_logic);
  end component;

  -- Declaración del decodificador (si no usas instanciación directa):
  component hex7seg is
    generic (ACTIVE_LOW : boolean := true);
    port (N: in std_logic_vector(3 downto 0); SEG: out std_logic_vector(6 downto 0));
  end component;

  signal C     : std_logic_vector(3 downto 1);
  signal y_int : std_logic_vector(3 downto 0);
begin
  -- Restador ripple
  FS0: restador port map(A=>A1(0), B=>B1(0), Cin=>Cin1, Y=>y_int(0), Cout=>C(1));
  FS1: restador port map(A=>A1(1), B=>B1(1), Cin=>C(1),  Y=>y_int(1), Cout=>C(2));
  FS2: restador port map(A=>A1(2), B=>B1(2), Cin=>C(2),  Y=>y_int(2), Cout=>C(3));
  FS3: restador port map(A=>A1(3), B=>B1(3), Cin=>C(3),  Y=>y_int(3), Cout=>Cout1);

  Y1 <= y_int;

  -- Instancias del decodificador (A, B y Y)
  segA: hex7seg generic map(ACTIVE_LOW => ACTIVE_LOW_7SEG) port map(N => A1,    SEG => HEX_A);
  segB: hex7seg generic map(ACTIVE_LOW => ACTIVE_LOW_7SEG) port map(N => B1,    SEG => HEX_B);
  segY: hex7seg generic map(ACTIVE_LOW => ACTIVE_LOW_7SEG) port map(N => y_int, SEG => HEX);

end architecture;
