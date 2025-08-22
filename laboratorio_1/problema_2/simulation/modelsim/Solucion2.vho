-- Copyright (C) 2022  Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions 
-- and other software and tools, and any partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License 
-- Subscription Agreement, the Intel Quartus Prime License Agreement,
-- the Intel FPGA IP License Agreement, or other applicable license
-- agreement, including, without limitation, that your use is for
-- the sole purpose of programming logic devices manufactured by
-- Intel and sold by Intel or its authorized distributors.  Please
-- refer to the applicable agreement for further details, at
-- https://fpgasoftware.intel.com/eula.

-- VENDOR "Altera"
-- PROGRAM "Quartus Prime"
-- VERSION "Version 22.1std.0 Build 915 10/25/2022 SC Lite Edition"

-- DATE "08/21/2025 08:10:42"

-- 
-- Device: Altera 5CSXFC6D6F31C6 Package FBGA896
-- 

-- 
-- This VHDL file should be used for ModelSim (VHDL) only
-- 

LIBRARY ALTERA_LNSIM;
LIBRARY CYCLONEV;
LIBRARY IEEE;
USE ALTERA_LNSIM.ALTERA_LNSIM_COMPONENTS.ALL;
USE CYCLONEV.CYCLONEV_COMPONENTS.ALL;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY 	problema_2 IS
    PORT (
	A1 : IN std_logic_vector(3 DOWNTO 0);
	B1 : IN std_logic_vector(3 DOWNTO 0);
	Cin1 : IN std_logic;
	Cout1 : BUFFER std_logic;
	Y1 : BUFFER std_logic_vector(3 DOWNTO 0);
	HEX_A : BUFFER std_logic_vector(6 DOWNTO 0);
	HEX_B : BUFFER std_logic_vector(6 DOWNTO 0);
	HEX : BUFFER std_logic_vector(6 DOWNTO 0)
	);
END problema_2;

-- Design Ports Information
-- Cout1	=>  Location: PIN_AJ24,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- Y1[0]	=>  Location: PIN_AF24,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- Y1[1]	=>  Location: PIN_AA19,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- Y1[2]	=>  Location: PIN_AK24,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- Y1[3]	=>  Location: PIN_AK23,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- HEX_A[0]	=>  Location: PIN_AD21,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- HEX_A[1]	=>  Location: PIN_AG22,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- HEX_A[2]	=>  Location: PIN_AE22,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- HEX_A[3]	=>  Location: PIN_AE23,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- HEX_A[4]	=>  Location: PIN_AG23,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- HEX_A[5]	=>  Location: PIN_AF23,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- HEX_A[6]	=>  Location: PIN_AH22,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- HEX_B[0]	=>  Location: PIN_AA21,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- HEX_B[1]	=>  Location: PIN_AB17,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- HEX_B[2]	=>  Location: PIN_AA18,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- HEX_B[3]	=>  Location: PIN_Y17,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- HEX_B[4]	=>  Location: PIN_Y18,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- HEX_B[5]	=>  Location: PIN_AF18,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- HEX_B[6]	=>  Location: PIN_W16,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- HEX[0]	=>  Location: PIN_W17,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- HEX[1]	=>  Location: PIN_V18,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- HEX[2]	=>  Location: PIN_AG17,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- HEX[3]	=>  Location: PIN_AG16,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- HEX[4]	=>  Location: PIN_AH17,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- HEX[5]	=>  Location: PIN_AG18,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- HEX[6]	=>  Location: PIN_AH18,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- A1[3]	=>  Location: PIN_AA30,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- B1[3]	=>  Location: PIN_W25,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- A1[2]	=>  Location: PIN_AC29,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- B1[2]	=>  Location: PIN_AC30,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- A1[1]	=>  Location: PIN_AD30,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- B1[1]	=>  Location: PIN_AB28,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- A1[0]	=>  Location: PIN_AC28,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- B1[0]	=>  Location: PIN_Y27,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- Cin1	=>  Location: PIN_AB30,	 I/O Standard: 2.5 V,	 Current Strength: Default


ARCHITECTURE structure OF problema_2 IS
SIGNAL gnd : std_logic := '0';
SIGNAL vcc : std_logic := '1';
SIGNAL unknown : std_logic := 'X';
SIGNAL devoe : std_logic := '1';
SIGNAL devclrn : std_logic := '1';
SIGNAL devpor : std_logic := '1';
SIGNAL ww_devoe : std_logic;
SIGNAL ww_devclrn : std_logic;
SIGNAL ww_devpor : std_logic;
SIGNAL ww_A1 : std_logic_vector(3 DOWNTO 0);
SIGNAL ww_B1 : std_logic_vector(3 DOWNTO 0);
SIGNAL ww_Cin1 : std_logic;
SIGNAL ww_Cout1 : std_logic;
SIGNAL ww_Y1 : std_logic_vector(3 DOWNTO 0);
SIGNAL ww_HEX_A : std_logic_vector(6 DOWNTO 0);
SIGNAL ww_HEX_B : std_logic_vector(6 DOWNTO 0);
SIGNAL ww_HEX : std_logic_vector(6 DOWNTO 0);
SIGNAL \~QUARTUS_CREATED_GND~I_combout\ : std_logic;
SIGNAL \A1[3]~input_o\ : std_logic;
SIGNAL \A1[2]~input_o\ : std_logic;
SIGNAL \B1[3]~input_o\ : std_logic;
SIGNAL \Cin1~input_o\ : std_logic;
SIGNAL \A1[0]~input_o\ : std_logic;
SIGNAL \A1[1]~input_o\ : std_logic;
SIGNAL \B1[0]~input_o\ : std_logic;
SIGNAL \B1[1]~input_o\ : std_logic;
SIGNAL \FS1|Cout~combout\ : std_logic;
SIGNAL \B1[2]~input_o\ : std_logic;
SIGNAL \FS3|Cout~combout\ : std_logic;
SIGNAL \FS0|Y~combout\ : std_logic;
SIGNAL \FS1|Y~combout\ : std_logic;
SIGNAL \FS2|Y~combout\ : std_logic;
SIGNAL \FS3|Y~0_combout\ : std_logic;
SIGNAL \FS3|Y~combout\ : std_logic;
SIGNAL \segA|seg_a~0_combout\ : std_logic;
SIGNAL \segA|seg_b~0_combout\ : std_logic;
SIGNAL \segA|seg_c~0_combout\ : std_logic;
SIGNAL \segA|seg_d~0_combout\ : std_logic;
SIGNAL \segA|seg_e~0_combout\ : std_logic;
SIGNAL \segA|seg_f~0_combout\ : std_logic;
SIGNAL \segA|seg_g~0_combout\ : std_logic;
SIGNAL \segB|seg_a~0_combout\ : std_logic;
SIGNAL \segB|seg_b~0_combout\ : std_logic;
SIGNAL \segB|seg_c~0_combout\ : std_logic;
SIGNAL \segB|seg_d~0_combout\ : std_logic;
SIGNAL \segB|seg_e~0_combout\ : std_logic;
SIGNAL \segB|seg_f~0_combout\ : std_logic;
SIGNAL \segB|seg_g~0_combout\ : std_logic;
SIGNAL \segY|seg_a~0_combout\ : std_logic;
SIGNAL \segY|seg_b~0_combout\ : std_logic;
SIGNAL \segY|seg_c~0_combout\ : std_logic;
SIGNAL \segY|seg_d~0_combout\ : std_logic;
SIGNAL \segY|seg_e~0_combout\ : std_logic;
SIGNAL \segY|seg_f~0_combout\ : std_logic;
SIGNAL \segY|seg_g~0_combout\ : std_logic;
SIGNAL \ALT_INV_A1[1]~input_o\ : std_logic;
SIGNAL \ALT_INV_B1[0]~input_o\ : std_logic;
SIGNAL \segY|ALT_INV_seg_e~0_combout\ : std_logic;
SIGNAL \ALT_INV_A1[2]~input_o\ : std_logic;
SIGNAL \ALT_INV_Cin1~input_o\ : std_logic;
SIGNAL \segY|ALT_INV_seg_f~0_combout\ : std_logic;
SIGNAL \ALT_INV_B1[3]~input_o\ : std_logic;
SIGNAL \segY|ALT_INV_seg_g~0_combout\ : std_logic;
SIGNAL \ALT_INV_A1[3]~input_o\ : std_logic;
SIGNAL \ALT_INV_B1[1]~input_o\ : std_logic;
SIGNAL \ALT_INV_A1[0]~input_o\ : std_logic;
SIGNAL \ALT_INV_B1[2]~input_o\ : std_logic;
SIGNAL \segB|ALT_INV_seg_d~0_combout\ : std_logic;
SIGNAL \segB|ALT_INV_seg_b~0_combout\ : std_logic;
SIGNAL \segB|ALT_INV_seg_f~0_combout\ : std_logic;
SIGNAL \FS0|ALT_INV_Y~combout\ : std_logic;
SIGNAL \segA|ALT_INV_seg_g~0_combout\ : std_logic;
SIGNAL \segB|ALT_INV_seg_c~0_combout\ : std_logic;
SIGNAL \segB|ALT_INV_seg_g~0_combout\ : std_logic;
SIGNAL \segY|ALT_INV_seg_a~0_combout\ : std_logic;
SIGNAL \segA|ALT_INV_seg_f~0_combout\ : std_logic;
SIGNAL \segB|ALT_INV_seg_e~0_combout\ : std_logic;
SIGNAL \segY|ALT_INV_seg_b~0_combout\ : std_logic;
SIGNAL \segY|ALT_INV_seg_c~0_combout\ : std_logic;
SIGNAL \segA|ALT_INV_seg_b~0_combout\ : std_logic;
SIGNAL \segA|ALT_INV_seg_a~0_combout\ : std_logic;
SIGNAL \segA|ALT_INV_seg_d~0_combout\ : std_logic;
SIGNAL \segB|ALT_INV_seg_a~0_combout\ : std_logic;
SIGNAL \segY|ALT_INV_seg_d~0_combout\ : std_logic;
SIGNAL \FS1|ALT_INV_Cout~combout\ : std_logic;
SIGNAL \FS1|ALT_INV_Y~combout\ : std_logic;
SIGNAL \FS3|ALT_INV_Y~0_combout\ : std_logic;
SIGNAL \segA|ALT_INV_seg_c~0_combout\ : std_logic;
SIGNAL \segA|ALT_INV_seg_e~0_combout\ : std_logic;

BEGIN

ww_A1 <= A1;
ww_B1 <= B1;
ww_Cin1 <= Cin1;
Cout1 <= ww_Cout1;
Y1 <= ww_Y1;
HEX_A <= ww_HEX_A;
HEX_B <= ww_HEX_B;
HEX <= ww_HEX;
ww_devoe <= devoe;
ww_devclrn <= devclrn;
ww_devpor <= devpor;
\ALT_INV_A1[1]~input_o\ <= NOT \A1[1]~input_o\;
\ALT_INV_B1[0]~input_o\ <= NOT \B1[0]~input_o\;
\segY|ALT_INV_seg_e~0_combout\ <= NOT \segY|seg_e~0_combout\;
\ALT_INV_A1[2]~input_o\ <= NOT \A1[2]~input_o\;
\ALT_INV_Cin1~input_o\ <= NOT \Cin1~input_o\;
\segY|ALT_INV_seg_f~0_combout\ <= NOT \segY|seg_f~0_combout\;
\ALT_INV_B1[3]~input_o\ <= NOT \B1[3]~input_o\;
\segY|ALT_INV_seg_g~0_combout\ <= NOT \segY|seg_g~0_combout\;
\ALT_INV_A1[3]~input_o\ <= NOT \A1[3]~input_o\;
\ALT_INV_B1[1]~input_o\ <= NOT \B1[1]~input_o\;
\ALT_INV_A1[0]~input_o\ <= NOT \A1[0]~input_o\;
\ALT_INV_B1[2]~input_o\ <= NOT \B1[2]~input_o\;
\segB|ALT_INV_seg_d~0_combout\ <= NOT \segB|seg_d~0_combout\;
\segB|ALT_INV_seg_b~0_combout\ <= NOT \segB|seg_b~0_combout\;
\segB|ALT_INV_seg_f~0_combout\ <= NOT \segB|seg_f~0_combout\;
\FS0|ALT_INV_Y~combout\ <= NOT \FS0|Y~combout\;
\segA|ALT_INV_seg_g~0_combout\ <= NOT \segA|seg_g~0_combout\;
\segB|ALT_INV_seg_c~0_combout\ <= NOT \segB|seg_c~0_combout\;
\segB|ALT_INV_seg_g~0_combout\ <= NOT \segB|seg_g~0_combout\;
\segY|ALT_INV_seg_a~0_combout\ <= NOT \segY|seg_a~0_combout\;
\segA|ALT_INV_seg_f~0_combout\ <= NOT \segA|seg_f~0_combout\;
\segB|ALT_INV_seg_e~0_combout\ <= NOT \segB|seg_e~0_combout\;
\segY|ALT_INV_seg_b~0_combout\ <= NOT \segY|seg_b~0_combout\;
\segY|ALT_INV_seg_c~0_combout\ <= NOT \segY|seg_c~0_combout\;
\segA|ALT_INV_seg_b~0_combout\ <= NOT \segA|seg_b~0_combout\;
\segA|ALT_INV_seg_a~0_combout\ <= NOT \segA|seg_a~0_combout\;
\segA|ALT_INV_seg_d~0_combout\ <= NOT \segA|seg_d~0_combout\;
\segB|ALT_INV_seg_a~0_combout\ <= NOT \segB|seg_a~0_combout\;
\segY|ALT_INV_seg_d~0_combout\ <= NOT \segY|seg_d~0_combout\;
\FS1|ALT_INV_Cout~combout\ <= NOT \FS1|Cout~combout\;
\FS1|ALT_INV_Y~combout\ <= NOT \FS1|Y~combout\;
\FS3|ALT_INV_Y~0_combout\ <= NOT \FS3|Y~0_combout\;
\segA|ALT_INV_seg_c~0_combout\ <= NOT \segA|seg_c~0_combout\;
\segA|ALT_INV_seg_e~0_combout\ <= NOT \segA|seg_e~0_combout\;

-- Location: IOOBUF_X74_Y0_N76
\Cout1~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \FS3|Cout~combout\,
	devoe => ww_devoe,
	o => ww_Cout1);

-- Location: IOOBUF_X74_Y0_N59
\Y1[0]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \FS0|Y~combout\,
	devoe => ww_devoe,
	o => ww_Y1(0));

-- Location: IOOBUF_X72_Y0_N19
\Y1[1]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \FS1|Y~combout\,
	devoe => ww_devoe,
	o => ww_Y1(1));

-- Location: IOOBUF_X72_Y0_N53
\Y1[2]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \FS2|Y~combout\,
	devoe => ww_devoe,
	o => ww_Y1(2));

-- Location: IOOBUF_X72_Y0_N36
\Y1[3]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \FS3|Y~combout\,
	devoe => ww_devoe,
	o => ww_Y1(3));

-- Location: IOOBUF_X82_Y0_N59
\HEX_A[0]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \segA|ALT_INV_seg_a~0_combout\,
	devoe => ww_devoe,
	o => ww_HEX_A(0));

-- Location: IOOBUF_X66_Y0_N76
\HEX_A[1]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \segA|ALT_INV_seg_b~0_combout\,
	devoe => ww_devoe,
	o => ww_HEX_A(1));

-- Location: IOOBUF_X78_Y0_N2
\HEX_A[2]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \segA|ALT_INV_seg_c~0_combout\,
	devoe => ww_devoe,
	o => ww_HEX_A(2));

-- Location: IOOBUF_X78_Y0_N19
\HEX_A[3]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \segA|ALT_INV_seg_d~0_combout\,
	devoe => ww_devoe,
	o => ww_HEX_A(3));

-- Location: IOOBUF_X64_Y0_N36
\HEX_A[4]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \segA|ALT_INV_seg_e~0_combout\,
	devoe => ww_devoe,
	o => ww_HEX_A(4));

-- Location: IOOBUF_X74_Y0_N42
\HEX_A[5]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \segA|ALT_INV_seg_f~0_combout\,
	devoe => ww_devoe,
	o => ww_HEX_A(5));

-- Location: IOOBUF_X66_Y0_N93
\HEX_A[6]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \segA|ALT_INV_seg_g~0_combout\,
	devoe => ww_devoe,
	o => ww_HEX_A(6));

-- Location: IOOBUF_X88_Y0_N3
\HEX_B[0]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \segB|ALT_INV_seg_a~0_combout\,
	devoe => ww_devoe,
	o => ww_HEX_B(0));

-- Location: IOOBUF_X56_Y0_N19
\HEX_B[1]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \segB|ALT_INV_seg_b~0_combout\,
	devoe => ww_devoe,
	o => ww_HEX_B(1));

-- Location: IOOBUF_X68_Y0_N19
\HEX_B[2]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \segB|ALT_INV_seg_c~0_combout\,
	devoe => ww_devoe,
	o => ww_HEX_B(2));

-- Location: IOOBUF_X68_Y0_N2
\HEX_B[3]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \segB|ALT_INV_seg_d~0_combout\,
	devoe => ww_devoe,
	o => ww_HEX_B(3));

-- Location: IOOBUF_X72_Y0_N2
\HEX_B[4]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \segB|ALT_INV_seg_e~0_combout\,
	devoe => ww_devoe,
	o => ww_HEX_B(4));

-- Location: IOOBUF_X50_Y0_N59
\HEX_B[5]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \segB|ALT_INV_seg_f~0_combout\,
	devoe => ww_devoe,
	o => ww_HEX_B(5));

-- Location: IOOBUF_X52_Y0_N19
\HEX_B[6]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \segB|ALT_INV_seg_g~0_combout\,
	devoe => ww_devoe,
	o => ww_HEX_B(6));

-- Location: IOOBUF_X60_Y0_N19
\HEX[0]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \segY|ALT_INV_seg_a~0_combout\,
	devoe => ww_devoe,
	o => ww_HEX(0));

-- Location: IOOBUF_X80_Y0_N2
\HEX[1]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \segY|ALT_INV_seg_b~0_combout\,
	devoe => ww_devoe,
	o => ww_HEX(1));

-- Location: IOOBUF_X50_Y0_N93
\HEX[2]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \segY|ALT_INV_seg_c~0_combout\,
	devoe => ww_devoe,
	o => ww_HEX(2));

-- Location: IOOBUF_X50_Y0_N76
\HEX[3]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \segY|ALT_INV_seg_d~0_combout\,
	devoe => ww_devoe,
	o => ww_HEX(3));

-- Location: IOOBUF_X56_Y0_N36
\HEX[4]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \segY|ALT_INV_seg_e~0_combout\,
	devoe => ww_devoe,
	o => ww_HEX(4));

-- Location: IOOBUF_X58_Y0_N76
\HEX[5]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \segY|ALT_INV_seg_f~0_combout\,
	devoe => ww_devoe,
	o => ww_HEX(5));

-- Location: IOOBUF_X56_Y0_N53
\HEX[6]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \segY|ALT_INV_seg_g~0_combout\,
	devoe => ww_devoe,
	o => ww_HEX(6));

-- Location: IOIBUF_X89_Y21_N21
\A1[3]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_A1(3),
	o => \A1[3]~input_o\);

-- Location: IOIBUF_X89_Y20_N95
\A1[2]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_A1(2),
	o => \A1[2]~input_o\);

-- Location: IOIBUF_X89_Y20_N44
\B1[3]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_B1(3),
	o => \B1[3]~input_o\);

-- Location: IOIBUF_X89_Y21_N4
\Cin1~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_Cin1,
	o => \Cin1~input_o\);

-- Location: IOIBUF_X89_Y20_N78
\A1[0]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_A1(0),
	o => \A1[0]~input_o\);

-- Location: IOIBUF_X89_Y25_N38
\A1[1]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_A1(1),
	o => \A1[1]~input_o\);

-- Location: IOIBUF_X89_Y25_N21
\B1[0]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_B1(0),
	o => \B1[0]~input_o\);

-- Location: IOIBUF_X89_Y21_N38
\B1[1]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_B1(1),
	o => \B1[1]~input_o\);

-- Location: LABCELL_X73_Y1_N0
\FS1|Cout\ : cyclonev_lcell_comb
-- Equation(s):
-- \FS1|Cout~combout\ = ( \B1[1]~input_o\ & ( (!\A1[1]~input_o\) # ((!\Cin1~input_o\ & (!\A1[0]~input_o\ & \B1[0]~input_o\)) # (\Cin1~input_o\ & ((!\A1[0]~input_o\) # (\B1[0]~input_o\)))) ) ) # ( !\B1[1]~input_o\ & ( (!\A1[1]~input_o\ & ((!\Cin1~input_o\ & 
-- (!\A1[0]~input_o\ & \B1[0]~input_o\)) # (\Cin1~input_o\ & ((!\A1[0]~input_o\) # (\B1[0]~input_o\))))) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0100000011010000010000001101000011110100111111011111010011111101",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_Cin1~input_o\,
	datab => \ALT_INV_A1[0]~input_o\,
	datac => \ALT_INV_A1[1]~input_o\,
	datad => \ALT_INV_B1[0]~input_o\,
	dataf => \ALT_INV_B1[1]~input_o\,
	combout => \FS1|Cout~combout\);

-- Location: IOIBUF_X89_Y25_N55
\B1[2]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_B1(2),
	o => \B1[2]~input_o\);

-- Location: LABCELL_X73_Y1_N39
\FS3|Cout\ : cyclonev_lcell_comb
-- Equation(s):
-- \FS3|Cout~combout\ = ( \B1[2]~input_o\ & ( (!\A1[3]~input_o\ & ((!\A1[2]~input_o\) # ((\FS1|Cout~combout\) # (\B1[3]~input_o\)))) # (\A1[3]~input_o\ & (\B1[3]~input_o\ & ((!\A1[2]~input_o\) # (\FS1|Cout~combout\)))) ) ) # ( !\B1[2]~input_o\ & ( 
-- (!\A1[3]~input_o\ & (((!\A1[2]~input_o\ & \FS1|Cout~combout\)) # (\B1[3]~input_o\))) # (\A1[3]~input_o\ & (!\A1[2]~input_o\ & (\B1[3]~input_o\ & \FS1|Cout~combout\))) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000101010001110000010101000111010001110101011111000111010101111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_A1[3]~input_o\,
	datab => \ALT_INV_A1[2]~input_o\,
	datac => \ALT_INV_B1[3]~input_o\,
	datad => \FS1|ALT_INV_Cout~combout\,
	dataf => \ALT_INV_B1[2]~input_o\,
	combout => \FS3|Cout~combout\);

-- Location: LABCELL_X73_Y1_N42
\FS0|Y\ : cyclonev_lcell_comb
-- Equation(s):
-- \FS0|Y~combout\ = ( \B1[0]~input_o\ & ( !\A1[0]~input_o\ $ (\Cin1~input_o\) ) ) # ( !\B1[0]~input_o\ & ( !\A1[0]~input_o\ $ (!\Cin1~input_o\) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0011110000111100001111000011110011000011110000111100001111000011",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datab => \ALT_INV_A1[0]~input_o\,
	datac => \ALT_INV_Cin1~input_o\,
	dataf => \ALT_INV_B1[0]~input_o\,
	combout => \FS0|Y~combout\);

-- Location: LABCELL_X73_Y1_N3
\FS1|Y\ : cyclonev_lcell_comb
-- Equation(s):
-- \FS1|Y~combout\ = ( \B1[0]~input_o\ & ( !\B1[1]~input_o\ $ (!\A1[1]~input_o\ $ (((!\A1[0]~input_o\) # (\Cin1~input_o\)))) ) ) # ( !\B1[0]~input_o\ & ( !\B1[1]~input_o\ $ (!\A1[1]~input_o\ $ (((\Cin1~input_o\ & !\A1[0]~input_o\)))) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0100101110110100010010111011010011010010001011011101001000101101",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_Cin1~input_o\,
	datab => \ALT_INV_A1[0]~input_o\,
	datac => \ALT_INV_B1[1]~input_o\,
	datad => \ALT_INV_A1[1]~input_o\,
	dataf => \ALT_INV_B1[0]~input_o\,
	combout => \FS1|Y~combout\);

-- Location: MLABCELL_X72_Y1_N0
\FS2|Y\ : cyclonev_lcell_comb
-- Equation(s):
-- \FS2|Y~combout\ = ( \FS1|Cout~combout\ & ( \B1[2]~input_o\ & ( \A1[2]~input_o\ ) ) ) # ( !\FS1|Cout~combout\ & ( \B1[2]~input_o\ & ( !\A1[2]~input_o\ ) ) ) # ( \FS1|Cout~combout\ & ( !\B1[2]~input_o\ & ( !\A1[2]~input_o\ ) ) ) # ( !\FS1|Cout~combout\ & ( 
-- !\B1[2]~input_o\ & ( \A1[2]~input_o\ ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000111100001111111100001111000011110000111100000000111100001111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datac => \ALT_INV_A1[2]~input_o\,
	datae => \FS1|ALT_INV_Cout~combout\,
	dataf => \ALT_INV_B1[2]~input_o\,
	combout => \FS2|Y~combout\);

-- Location: LABCELL_X73_Y1_N48
\FS3|Y~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \FS3|Y~0_combout\ = !\A1[3]~input_o\ $ (!\B1[3]~input_o\)

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0101101001011010010110100101101001011010010110100101101001011010",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_A1[3]~input_o\,
	datac => \ALT_INV_B1[3]~input_o\,
	combout => \FS3|Y~0_combout\);

-- Location: MLABCELL_X72_Y1_N39
\FS3|Y\ : cyclonev_lcell_comb
-- Equation(s):
-- \FS3|Y~combout\ = ( \FS1|Cout~combout\ & ( \B1[2]~input_o\ & ( !\FS3|Y~0_combout\ ) ) ) # ( !\FS1|Cout~combout\ & ( \B1[2]~input_o\ & ( !\A1[2]~input_o\ $ (\FS3|Y~0_combout\) ) ) ) # ( \FS1|Cout~combout\ & ( !\B1[2]~input_o\ & ( !\A1[2]~input_o\ $ 
-- (\FS3|Y~0_combout\) ) ) ) # ( !\FS1|Cout~combout\ & ( !\B1[2]~input_o\ & ( \FS3|Y~0_combout\ ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000111100001111101001011010010110100101101001011111000011110000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_A1[2]~input_o\,
	datac => \FS3|ALT_INV_Y~0_combout\,
	datae => \FS1|ALT_INV_Cout~combout\,
	dataf => \ALT_INV_B1[2]~input_o\,
	combout => \FS3|Y~combout\);

-- Location: LABCELL_X73_Y1_N54
\segA|seg_a~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \segA|seg_a~0_combout\ = ( \A1[0]~input_o\ & ( (!\A1[2]~input_o\ & (!\A1[1]~input_o\ $ (!\A1[3]~input_o\))) # (\A1[2]~input_o\ & ((!\A1[3]~input_o\) # (\A1[1]~input_o\))) ) ) # ( !\A1[0]~input_o\ & ( (!\A1[2]~input_o\) # ((\A1[3]~input_o\) # 
-- (\A1[1]~input_o\)) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1100111111111111110011111111111100111111110000110011111111000011",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datab => \ALT_INV_A1[2]~input_o\,
	datac => \ALT_INV_A1[1]~input_o\,
	datad => \ALT_INV_A1[3]~input_o\,
	dataf => \ALT_INV_A1[0]~input_o\,
	combout => \segA|seg_a~0_combout\);

-- Location: LABCELL_X73_Y1_N57
\segA|seg_b~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \segA|seg_b~0_combout\ = ( \A1[0]~input_o\ & ( (!\A1[1]~input_o\ & ((!\A1[2]~input_o\) # (\A1[3]~input_o\))) # (\A1[1]~input_o\ & ((!\A1[3]~input_o\))) ) ) # ( !\A1[0]~input_o\ & ( (!\A1[2]~input_o\) # ((!\A1[1]~input_o\ & !\A1[3]~input_o\)) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1111101011110000111110101111000011110101101010101111010110101010",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_A1[1]~input_o\,
	datac => \ALT_INV_A1[2]~input_o\,
	datad => \ALT_INV_A1[3]~input_o\,
	dataf => \ALT_INV_A1[0]~input_o\,
	combout => \segA|seg_b~0_combout\);

-- Location: LABCELL_X73_Y1_N45
\segA|seg_c~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \segA|seg_c~0_combout\ = (!\A1[2]~input_o\ & ((!\A1[1]~input_o\) # ((\A1[3]~input_o\) # (\A1[0]~input_o\)))) # (\A1[2]~input_o\ & ((!\A1[3]~input_o\) # ((!\A1[1]~input_o\ & \A1[0]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1011111111110010101111111111001010111111111100101011111111110010",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_A1[1]~input_o\,
	datab => \ALT_INV_A1[0]~input_o\,
	datac => \ALT_INV_A1[2]~input_o\,
	datad => \ALT_INV_A1[3]~input_o\,
	combout => \segA|seg_c~0_combout\);

-- Location: LABCELL_X73_Y1_N51
\segA|seg_d~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \segA|seg_d~0_combout\ = (!\A1[1]~input_o\ & ((!\A1[2]~input_o\ $ (\A1[0]~input_o\)) # (\A1[3]~input_o\))) # (\A1[1]~input_o\ & ((!\A1[2]~input_o\ & ((!\A1[3]~input_o\) # (\A1[0]~input_o\))) # (\A1[2]~input_o\ & ((!\A1[0]~input_o\)))))

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1101011110111100110101111011110011010111101111001101011110111100",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_A1[3]~input_o\,
	datab => \ALT_INV_A1[2]~input_o\,
	datac => \ALT_INV_A1[0]~input_o\,
	datad => \ALT_INV_A1[1]~input_o\,
	combout => \segA|seg_d~0_combout\);

-- Location: LABCELL_X73_Y1_N30
\segA|seg_e~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \segA|seg_e~0_combout\ = ( \A1[0]~input_o\ & ( (\A1[3]~input_o\ & ((\A1[2]~input_o\) # (\A1[1]~input_o\))) ) ) # ( !\A1[0]~input_o\ & ( ((!\A1[2]~input_o\) # (\A1[3]~input_o\)) # (\A1[1]~input_o\) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1101111111011111110111111101111100000111000001110000011100000111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_A1[1]~input_o\,
	datab => \ALT_INV_A1[2]~input_o\,
	datac => \ALT_INV_A1[3]~input_o\,
	dataf => \ALT_INV_A1[0]~input_o\,
	combout => \segA|seg_e~0_combout\);

-- Location: LABCELL_X73_Y1_N33
\segA|seg_f~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \segA|seg_f~0_combout\ = ( \A1[0]~input_o\ & ( !\A1[3]~input_o\ $ (((!\A1[2]~input_o\) # (\A1[1]~input_o\))) ) ) # ( !\A1[0]~input_o\ & ( (!\A1[1]~input_o\) # ((\A1[3]~input_o\) # (\A1[2]~input_o\)) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1010111111111111101011111111111100001010111101010000101011110101",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_A1[1]~input_o\,
	datac => \ALT_INV_A1[2]~input_o\,
	datad => \ALT_INV_A1[3]~input_o\,
	dataf => \ALT_INV_A1[0]~input_o\,
	combout => \segA|seg_f~0_combout\);

-- Location: LABCELL_X73_Y1_N36
\segA|seg_g~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \segA|seg_g~0_combout\ = (!\A1[0]~input_o\ & ((!\A1[3]~input_o\ $ (!\A1[2]~input_o\)) # (\A1[1]~input_o\))) # (\A1[0]~input_o\ & ((!\A1[2]~input_o\ $ (!\A1[1]~input_o\)) # (\A1[3]~input_o\)))

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0110111101111101011011110111110101101111011111010110111101111101",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_A1[3]~input_o\,
	datab => \ALT_INV_A1[2]~input_o\,
	datac => \ALT_INV_A1[1]~input_o\,
	datad => \ALT_INV_A1[0]~input_o\,
	combout => \segA|seg_g~0_combout\);

-- Location: MLABCELL_X72_Y1_N42
\segB|seg_a~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \segB|seg_a~0_combout\ = ( \B1[0]~input_o\ & ( \B1[2]~input_o\ & ( (!\B1[3]~input_o\) # (\B1[1]~input_o\) ) ) ) # ( !\B1[0]~input_o\ & ( \B1[2]~input_o\ & ( (\B1[3]~input_o\) # (\B1[1]~input_o\) ) ) ) # ( \B1[0]~input_o\ & ( !\B1[2]~input_o\ & ( 
-- !\B1[1]~input_o\ $ (!\B1[3]~input_o\) ) ) ) # ( !\B1[0]~input_o\ & ( !\B1[2]~input_o\ ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1111111111111111001111000011110000111111001111111111001111110011",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datab => \ALT_INV_B1[1]~input_o\,
	datac => \ALT_INV_B1[3]~input_o\,
	datae => \ALT_INV_B1[0]~input_o\,
	dataf => \ALT_INV_B1[2]~input_o\,
	combout => \segB|seg_a~0_combout\);

-- Location: MLABCELL_X72_Y1_N18
\segB|seg_b~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \segB|seg_b~0_combout\ = ( \B1[0]~input_o\ & ( \B1[2]~input_o\ & ( !\B1[1]~input_o\ $ (!\B1[3]~input_o\) ) ) ) # ( !\B1[0]~input_o\ & ( \B1[2]~input_o\ & ( (!\B1[1]~input_o\ & !\B1[3]~input_o\) ) ) ) # ( \B1[0]~input_o\ & ( !\B1[2]~input_o\ & ( 
-- (!\B1[1]~input_o\) # (!\B1[3]~input_o\) ) ) ) # ( !\B1[0]~input_o\ & ( !\B1[2]~input_o\ ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1111111111111111111111001111110011000000110000000011110000111100",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datab => \ALT_INV_B1[1]~input_o\,
	datac => \ALT_INV_B1[3]~input_o\,
	datae => \ALT_INV_B1[0]~input_o\,
	dataf => \ALT_INV_B1[2]~input_o\,
	combout => \segB|seg_b~0_combout\);

-- Location: MLABCELL_X72_Y1_N27
\segB|seg_c~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \segB|seg_c~0_combout\ = ( \B1[0]~input_o\ & ( \B1[2]~input_o\ & ( (!\B1[3]~input_o\) # (!\B1[1]~input_o\) ) ) ) # ( !\B1[0]~input_o\ & ( \B1[2]~input_o\ & ( !\B1[3]~input_o\ ) ) ) # ( \B1[0]~input_o\ & ( !\B1[2]~input_o\ ) ) # ( !\B1[0]~input_o\ & ( 
-- !\B1[2]~input_o\ & ( (!\B1[1]~input_o\) # (\B1[3]~input_o\) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1111010111110101111111111111111110101010101010101111101011111010",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_B1[3]~input_o\,
	datac => \ALT_INV_B1[1]~input_o\,
	datae => \ALT_INV_B1[0]~input_o\,
	dataf => \ALT_INV_B1[2]~input_o\,
	combout => \segB|seg_c~0_combout\);

-- Location: MLABCELL_X72_Y1_N30
\segB|seg_d~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \segB|seg_d~0_combout\ = ( \B1[2]~input_o\ & ( (!\B1[1]~input_o\ & ((\B1[0]~input_o\) # (\B1[3]~input_o\))) # (\B1[1]~input_o\ & ((!\B1[0]~input_o\))) ) ) # ( !\B1[2]~input_o\ & ( (!\B1[3]~input_o\ & ((!\B1[0]~input_o\) # (\B1[1]~input_o\))) # 
-- (\B1[3]~input_o\ & ((!\B1[1]~input_o\) # (\B1[0]~input_o\))) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1110111001110111111011100111011101110111110011000111011111001100",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_B1[3]~input_o\,
	datab => \ALT_INV_B1[1]~input_o\,
	datad => \ALT_INV_B1[0]~input_o\,
	dataf => \ALT_INV_B1[2]~input_o\,
	combout => \segB|seg_d~0_combout\);

-- Location: MLABCELL_X72_Y1_N33
\segB|seg_e~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \segB|seg_e~0_combout\ = ( \B1[2]~input_o\ & ( ((\B1[1]~input_o\ & !\B1[0]~input_o\)) # (\B1[3]~input_o\) ) ) # ( !\B1[2]~input_o\ & ( (!\B1[0]~input_o\) # ((\B1[3]~input_o\ & \B1[1]~input_o\)) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1111000111110001111100011111000101110101011101010111010101110101",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_B1[3]~input_o\,
	datab => \ALT_INV_B1[1]~input_o\,
	datac => \ALT_INV_B1[0]~input_o\,
	dataf => \ALT_INV_B1[2]~input_o\,
	combout => \segB|seg_e~0_combout\);

-- Location: MLABCELL_X72_Y1_N6
\segB|seg_f~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \segB|seg_f~0_combout\ = ( \B1[2]~input_o\ & ( (!\B1[0]~input_o\) # (!\B1[3]~input_o\ $ (\B1[1]~input_o\)) ) ) # ( !\B1[2]~input_o\ & ( ((!\B1[1]~input_o\ & !\B1[0]~input_o\)) # (\B1[3]~input_o\) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1101110101010101110111010101010111111111100110011111111110011001",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_B1[3]~input_o\,
	datab => \ALT_INV_B1[1]~input_o\,
	datad => \ALT_INV_B1[0]~input_o\,
	dataf => \ALT_INV_B1[2]~input_o\,
	combout => \segB|seg_f~0_combout\);

-- Location: MLABCELL_X72_Y1_N9
\segB|seg_g~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \segB|seg_g~0_combout\ = ( \B1[2]~input_o\ & ( (!\B1[3]~input_o\ & ((!\B1[1]~input_o\) # (!\B1[0]~input_o\))) # (\B1[3]~input_o\ & ((\B1[0]~input_o\) # (\B1[1]~input_o\))) ) ) # ( !\B1[2]~input_o\ & ( (\B1[1]~input_o\) # (\B1[3]~input_o\) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0101111101011111010111110101111110101111111101011010111111110101",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_B1[3]~input_o\,
	datac => \ALT_INV_B1[1]~input_o\,
	datad => \ALT_INV_B1[0]~input_o\,
	dataf => \ALT_INV_B1[2]~input_o\,
	combout => \segB|seg_g~0_combout\);

-- Location: LABCELL_X73_Y1_N6
\segY|seg_a~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \segY|seg_a~0_combout\ = ( \FS1|Cout~combout\ & ( \B1[2]~input_o\ & ( (!\FS3|Y~0_combout\ & ((!\FS0|Y~combout\) # (!\FS1|Y~combout\ $ (\A1[2]~input_o\)))) # (\FS3|Y~0_combout\ & ((!\FS0|Y~combout\ $ (\A1[2]~input_o\)) # (\FS1|Y~combout\))) ) ) ) # ( 
-- !\FS1|Cout~combout\ & ( \B1[2]~input_o\ & ( (!\A1[2]~input_o\ & ((!\FS0|Y~combout\ $ (\FS3|Y~0_combout\)) # (\FS1|Y~combout\))) # (\A1[2]~input_o\ & ((!\FS0|Y~combout\) # (!\FS1|Y~combout\ $ (!\FS3|Y~0_combout\)))) ) ) ) # ( \FS1|Cout~combout\ & ( 
-- !\B1[2]~input_o\ & ( (!\A1[2]~input_o\ & ((!\FS0|Y~combout\ $ (\FS3|Y~0_combout\)) # (\FS1|Y~combout\))) # (\A1[2]~input_o\ & ((!\FS0|Y~combout\) # (!\FS1|Y~combout\ $ (!\FS3|Y~0_combout\)))) ) ) ) # ( !\FS1|Cout~combout\ & ( !\B1[2]~input_o\ & ( 
-- (!\FS3|Y~0_combout\ & ((!\FS0|Y~combout\ $ (\A1[2]~input_o\)) # (\FS1|Y~combout\))) # (\FS3|Y~0_combout\ & ((!\FS0|Y~combout\) # (!\FS1|Y~combout\ $ (\A1[2]~input_o\)))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1101111001111101110101111101111011010111110111101110110111010111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \FS1|ALT_INV_Y~combout\,
	datab => \FS0|ALT_INV_Y~combout\,
	datac => \FS3|ALT_INV_Y~0_combout\,
	datad => \ALT_INV_A1[2]~input_o\,
	datae => \FS1|ALT_INV_Cout~combout\,
	dataf => \ALT_INV_B1[2]~input_o\,
	combout => \segY|seg_a~0_combout\);

-- Location: LABCELL_X73_Y1_N12
\segY|seg_b~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \segY|seg_b~0_combout\ = ( \FS1|Cout~combout\ & ( \B1[2]~input_o\ & ( (!\FS1|Y~combout\ & ((!\A1[2]~input_o\) # (!\FS0|Y~combout\ $ (!\FS3|Y~0_combout\)))) # (\FS1|Y~combout\ & ((!\FS0|Y~combout\ & ((!\A1[2]~input_o\))) # (\FS0|Y~combout\ & 
-- (\FS3|Y~0_combout\)))) ) ) ) # ( !\FS1|Cout~combout\ & ( \B1[2]~input_o\ & ( (!\FS1|Y~combout\ & ((!\FS0|Y~combout\ $ (!\FS3|Y~0_combout\)) # (\A1[2]~input_o\))) # (\FS1|Y~combout\ & (!\A1[2]~input_o\ $ (((!\FS0|Y~combout\) # (!\FS3|Y~0_combout\))))) ) ) 
-- ) # ( \FS1|Cout~combout\ & ( !\B1[2]~input_o\ & ( (!\FS1|Y~combout\ & ((!\FS0|Y~combout\ $ (!\FS3|Y~0_combout\)) # (\A1[2]~input_o\))) # (\FS1|Y~combout\ & (!\A1[2]~input_o\ $ (((!\FS0|Y~combout\) # (!\FS3|Y~0_combout\))))) ) ) ) # ( !\FS1|Cout~combout\ & 
-- ( !\B1[2]~input_o\ & ( (!\FS1|Y~combout\ & ((!\A1[2]~input_o\) # (!\FS0|Y~combout\ $ (\FS3|Y~0_combout\)))) # (\FS1|Y~combout\ & ((!\FS0|Y~combout\ & ((!\A1[2]~input_o\))) # (\FS0|Y~combout\ & (!\FS3|Y~0_combout\)))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1111111010010010001010011111111000101001111111101110111100101001",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \FS1|ALT_INV_Y~combout\,
	datab => \FS0|ALT_INV_Y~combout\,
	datac => \FS3|ALT_INV_Y~0_combout\,
	datad => \ALT_INV_A1[2]~input_o\,
	datae => \FS1|ALT_INV_Cout~combout\,
	dataf => \ALT_INV_B1[2]~input_o\,
	combout => \segY|seg_b~0_combout\);

-- Location: LABCELL_X73_Y1_N18
\segY|seg_c~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \segY|seg_c~0_combout\ = ( \FS1|Cout~combout\ & ( \B1[2]~input_o\ & ( (!\FS3|Y~0_combout\ & ((!\A1[2]~input_o\) # ((!\FS1|Y~combout\ & \FS0|Y~combout\)))) # (\FS3|Y~0_combout\ & ((!\FS1|Y~combout\) # ((\A1[2]~input_o\) # (\FS0|Y~combout\)))) ) ) ) # ( 
-- !\FS1|Cout~combout\ & ( \B1[2]~input_o\ & ( ((!\FS1|Y~combout\ & ((\A1[2]~input_o\) # (\FS0|Y~combout\))) # (\FS1|Y~combout\ & (\FS0|Y~combout\ & \A1[2]~input_o\))) # (\FS3|Y~0_combout\) ) ) ) # ( \FS1|Cout~combout\ & ( !\B1[2]~input_o\ & ( 
-- ((!\FS1|Y~combout\ & ((\A1[2]~input_o\) # (\FS0|Y~combout\))) # (\FS1|Y~combout\ & (\FS0|Y~combout\ & \A1[2]~input_o\))) # (\FS3|Y~0_combout\) ) ) ) # ( !\FS1|Cout~combout\ & ( !\B1[2]~input_o\ & ( (!\FS3|Y~0_combout\ & ((!\FS1|Y~combout\) # 
-- ((\A1[2]~input_o\) # (\FS0|Y~combout\)))) # (\FS3|Y~0_combout\ & ((!\A1[2]~input_o\) # ((!\FS1|Y~combout\ & \FS0|Y~combout\)))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1011111111110010001011111011111100101111101111111111101100101111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \FS1|ALT_INV_Y~combout\,
	datab => \FS0|ALT_INV_Y~combout\,
	datac => \FS3|ALT_INV_Y~0_combout\,
	datad => \ALT_INV_A1[2]~input_o\,
	datae => \FS1|ALT_INV_Cout~combout\,
	dataf => \ALT_INV_B1[2]~input_o\,
	combout => \segY|seg_c~0_combout\);

-- Location: LABCELL_X73_Y1_N24
\segY|seg_d~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \segY|seg_d~0_combout\ = ( \FS1|Cout~combout\ & ( \B1[2]~input_o\ & ( (!\FS1|Y~combout\ & ((!\FS3|Y~0_combout\) # (!\FS0|Y~combout\ $ (\A1[2]~input_o\)))) # (\FS1|Y~combout\ & ((!\FS0|Y~combout\ & ((\A1[2]~input_o\) # (\FS3|Y~0_combout\))) # 
-- (\FS0|Y~combout\ & ((!\A1[2]~input_o\))))) ) ) ) # ( !\FS1|Cout~combout\ & ( \B1[2]~input_o\ & ( (!\FS0|Y~combout\ & ((!\FS3|Y~0_combout\) # (!\FS1|Y~combout\ $ (!\A1[2]~input_o\)))) # (\FS0|Y~combout\ & ((!\FS1|Y~combout\ & ((!\A1[2]~input_o\) # 
-- (\FS3|Y~0_combout\))) # (\FS1|Y~combout\ & ((\A1[2]~input_o\))))) ) ) ) # ( \FS1|Cout~combout\ & ( !\B1[2]~input_o\ & ( (!\FS0|Y~combout\ & ((!\FS3|Y~0_combout\) # (!\FS1|Y~combout\ $ (!\A1[2]~input_o\)))) # (\FS0|Y~combout\ & ((!\FS1|Y~combout\ & 
-- ((!\A1[2]~input_o\) # (\FS3|Y~0_combout\))) # (\FS1|Y~combout\ & ((\A1[2]~input_o\))))) ) ) ) # ( !\FS1|Cout~combout\ & ( !\B1[2]~input_o\ & ( (!\FS1|Y~combout\ & ((!\FS0|Y~combout\ $ (\A1[2]~input_o\)) # (\FS3|Y~0_combout\))) # (\FS1|Y~combout\ & 
-- ((!\FS0|Y~combout\ & ((!\FS3|Y~0_combout\) # (\A1[2]~input_o\))) # (\FS0|Y~combout\ & ((!\A1[2]~input_o\))))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1101101101101110111001101101101111100110110110111011110111100110",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \FS1|ALT_INV_Y~combout\,
	datab => \FS0|ALT_INV_Y~combout\,
	datac => \FS3|ALT_INV_Y~0_combout\,
	datad => \ALT_INV_A1[2]~input_o\,
	datae => \FS1|ALT_INV_Cout~combout\,
	dataf => \ALT_INV_B1[2]~input_o\,
	combout => \segY|seg_d~0_combout\);

-- Location: MLABCELL_X72_Y1_N12
\segY|seg_e~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \segY|seg_e~0_combout\ = ( \FS1|Cout~combout\ & ( \B1[2]~input_o\ & ( (!\FS1|Y~combout\ & ((!\A1[2]~input_o\ & (!\FS0|Y~combout\)) # (\A1[2]~input_o\ & ((!\FS3|Y~0_combout\))))) # (\FS1|Y~combout\ & (((!\FS0|Y~combout\) # (!\FS3|Y~0_combout\)))) ) ) ) # ( 
-- !\FS1|Cout~combout\ & ( \B1[2]~input_o\ & ( (!\A1[2]~input_o\ & ((!\FS3|Y~0_combout\) # ((!\FS0|Y~combout\ & \FS1|Y~combout\)))) # (\A1[2]~input_o\ & ((!\FS0|Y~combout\) # ((\FS1|Y~combout\ & \FS3|Y~0_combout\)))) ) ) ) # ( \FS1|Cout~combout\ & ( 
-- !\B1[2]~input_o\ & ( (!\A1[2]~input_o\ & ((!\FS3|Y~0_combout\) # ((!\FS0|Y~combout\ & \FS1|Y~combout\)))) # (\A1[2]~input_o\ & ((!\FS0|Y~combout\) # ((\FS1|Y~combout\ & \FS3|Y~0_combout\)))) ) ) ) # ( !\FS1|Cout~combout\ & ( !\B1[2]~input_o\ & ( 
-- (!\FS1|Y~combout\ & ((!\A1[2]~input_o\ & (!\FS0|Y~combout\)) # (\A1[2]~input_o\ & ((\FS3|Y~0_combout\))))) # (\FS1|Y~combout\ & (((!\FS0|Y~combout\) # (\FS3|Y~0_combout\)))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1000110011011111111011100100110111101110010011011101111110001100",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_A1[2]~input_o\,
	datab => \FS0|ALT_INV_Y~combout\,
	datac => \FS1|ALT_INV_Y~combout\,
	datad => \FS3|ALT_INV_Y~0_combout\,
	datae => \FS1|ALT_INV_Cout~combout\,
	dataf => \ALT_INV_B1[2]~input_o\,
	combout => \segY|seg_e~0_combout\);

-- Location: MLABCELL_X72_Y1_N48
\segY|seg_f~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \segY|seg_f~0_combout\ = ( \FS1|Cout~combout\ & ( \B1[2]~input_o\ & ( (!\A1[2]~input_o\ & ((!\FS3|Y~0_combout\) # ((!\FS0|Y~combout\ & !\FS1|Y~combout\)))) # (\A1[2]~input_o\ & ((!\FS0|Y~combout\) # (!\FS1|Y~combout\ $ (!\FS3|Y~0_combout\)))) ) ) ) # ( 
-- !\FS1|Cout~combout\ & ( \B1[2]~input_o\ & ( (!\A1[2]~input_o\ & ((!\FS0|Y~combout\) # (!\FS1|Y~combout\ $ (!\FS3|Y~0_combout\)))) # (\A1[2]~input_o\ & (((!\FS0|Y~combout\ & !\FS1|Y~combout\)) # (\FS3|Y~0_combout\))) ) ) ) # ( \FS1|Cout~combout\ & ( 
-- !\B1[2]~input_o\ & ( (!\A1[2]~input_o\ & ((!\FS0|Y~combout\) # (!\FS1|Y~combout\ $ (!\FS3|Y~0_combout\)))) # (\A1[2]~input_o\ & (((!\FS0|Y~combout\ & !\FS1|Y~combout\)) # (\FS3|Y~0_combout\))) ) ) ) # ( !\FS1|Cout~combout\ & ( !\B1[2]~input_o\ & ( 
-- (!\A1[2]~input_o\ & (((!\FS0|Y~combout\ & !\FS1|Y~combout\)) # (\FS3|Y~0_combout\))) # (\A1[2]~input_o\ & ((!\FS0|Y~combout\) # (!\FS1|Y~combout\ $ (\FS3|Y~0_combout\)))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1101010011101111110010101111110111001010111111011110111111010100",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_A1[2]~input_o\,
	datab => \FS0|ALT_INV_Y~combout\,
	datac => \FS1|ALT_INV_Y~combout\,
	datad => \FS3|ALT_INV_Y~0_combout\,
	datae => \FS1|ALT_INV_Cout~combout\,
	dataf => \ALT_INV_B1[2]~input_o\,
	combout => \segY|seg_f~0_combout\);

-- Location: MLABCELL_X72_Y1_N54
\segY|seg_g~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \segY|seg_g~0_combout\ = ( \FS1|Cout~combout\ & ( \B1[2]~input_o\ & ( (!\FS0|Y~combout\ & ((!\A1[2]~input_o\ $ (\FS3|Y~0_combout\)) # (\FS1|Y~combout\))) # (\FS0|Y~combout\ & ((!\FS3|Y~0_combout\) # (!\A1[2]~input_o\ $ (!\FS1|Y~combout\)))) ) ) ) # ( 
-- !\FS1|Cout~combout\ & ( \B1[2]~input_o\ & ( (!\FS1|Y~combout\ & (((!\A1[2]~input_o\ & \FS0|Y~combout\)) # (\FS3|Y~0_combout\))) # (\FS1|Y~combout\ & (((!\FS0|Y~combout\) # (!\FS3|Y~0_combout\)) # (\A1[2]~input_o\))) ) ) ) # ( \FS1|Cout~combout\ & ( 
-- !\B1[2]~input_o\ & ( (!\FS1|Y~combout\ & (((!\A1[2]~input_o\ & \FS0|Y~combout\)) # (\FS3|Y~0_combout\))) # (\FS1|Y~combout\ & (((!\FS0|Y~combout\) # (!\FS3|Y~0_combout\)) # (\A1[2]~input_o\))) ) ) ) # ( !\FS1|Cout~combout\ & ( !\B1[2]~input_o\ & ( 
-- (!\FS0|Y~combout\ & ((!\A1[2]~input_o\ $ (!\FS3|Y~0_combout\)) # (\FS1|Y~combout\))) # (\FS0|Y~combout\ & ((!\A1[2]~input_o\ $ (!\FS1|Y~combout\)) # (\FS3|Y~0_combout\))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0101111010111111001011111111110100101111111111011011111101011110",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_A1[2]~input_o\,
	datab => \FS0|ALT_INV_Y~combout\,
	datac => \FS1|ALT_INV_Y~combout\,
	datad => \FS3|ALT_INV_Y~0_combout\,
	datae => \FS1|ALT_INV_Cout~combout\,
	dataf => \ALT_INV_B1[2]~input_o\,
	combout => \segY|seg_g~0_combout\);

-- Location: LABCELL_X46_Y15_N3
\~QUARTUS_CREATED_GND~I\ : cyclonev_lcell_comb
-- Equation(s):

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000000000000000000000000000000000000000000000000000",
	shared_arith => "off")
-- pragma translate_on
;
END structure;


