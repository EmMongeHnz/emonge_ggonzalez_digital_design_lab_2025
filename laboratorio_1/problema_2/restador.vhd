library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity restador is
  port (
    A    : in  std_logic;
    B    : in  std_logic;
    Cin  : in  std_logic;   -- Borrow in
    Y    : out std_logic;   -- Diferencia
    Cout : out std_logic    -- Borrow out
  );
end entity;

architecture rtl of restador is
begin
  Y    <= A xor B xor Cin;
  Cout <= ((not A) and B) or (Cin and (not (A xor B)));
end architecture;
