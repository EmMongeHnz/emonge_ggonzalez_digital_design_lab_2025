-- hex7seg.vhd
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity hex7seg is
  generic (
    ACTIVE_LOW : boolean := true   -- true: segmentos activos en '0'
  );
  port(
    N     : in  std_logic_vector(3 downto 0);  -- nibble (0..F)
    SEG   : out std_logic_vector(6 downto 0)   -- g f e d c b a
  );
end entity;

architecture rtl of hex7seg is
  signal D        : std_logic_vector(15 downto 0);  -- one-hot por valor N
  signal seg_a, seg_b, seg_c, seg_d, seg_e, seg_f, seg_g : std_logic;
  signal SEG_int  : std_logic_vector(6 downto 0);   -- activo-alto interno
begin
  -- one-hot: D(k)=1 cuando N=k (k=0..15)
  D <= std_logic_vector( shift_left(to_unsigned(1,16), to_integer(unsigned(N))) );

  -- Listas de segmentos (mismas que usaste):
  -- a: 0,2,3,5,6,7,8,9,A,C,E,F
  seg_a <= D(0) or D(2) or D(3) or D(5) or D(6) or D(7) or D(8) or D(9) or D(10) or D(12) or D(14) or D(15);
  -- b: 0,1,2,3,4,7,8,9,A,D
  seg_b <= D(0) or D(1) or D(2) or D(3) or D(4) or D(7) or D(8) or D(9) or D(10) or D(13);
  -- c: 0,1,3,4,5,6,7,8,9,A,B,D
  seg_c <= D(0) or D(1) or D(3) or D(4) or D(5) or D(6) or D(7) or D(8) or D(9) or D(10) or D(11) or D(13);
  -- d: 0,2,3,5,6,8,9,B,C,D,E
  seg_d <= D(0) or D(2) or D(3) or D(5) or D(6) or D(8) or D(9) or D(11) or D(12) or D(13) or D(14);
  -- e: 0,2,6,8,A,B,C,D,E,F
  seg_e <= D(0) or D(2) or D(6) or D(8) or D(10) or D(11) or D(12) or D(13) or D(14) or D(15);
  -- f: 0,4,5,6,8,9,A,B,C,E,F
  seg_f <= D(0) or D(4) or D(5) or D(6) or D(8) or D(9) or D(10) or D(11) or D(12) or D(14) or D(15);
  -- g: 2,3,4,5,6,8,9,A,B,D,E,F
  seg_g <= D(2) or D(3) or D(4) or D(5) or D(6) or D(8) or D(9) or D(10) or D(11) or D(13) or D(14) or D(15);

  SEG_int <= seg_g & seg_f & seg_e & seg_d & seg_c & seg_b & seg_a; -- gfedcba

  -- Ajuste de polaridad a la salida física
  SEG <= (not SEG_int) when ACTIVE_LOW else SEG_int;
end architecture;
