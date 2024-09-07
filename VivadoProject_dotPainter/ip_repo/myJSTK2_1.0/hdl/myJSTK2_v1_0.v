
`timescale 1 ns / 1 ps

	module myJSTK2_v1_0 #
	(
		// Users to add parameters here

		// User parameters ends
		// Do not modify the parameters beyond this line


		// Parameters of Axi Slave Bus Interface S00_AXI
		parameter integer C_S00_AXI_DATA_WIDTH	= 32,
		parameter integer C_S00_AXI_ADDR_WIDTH	= 4
	)
	(
		// Users to add ports here
		input wire MISO,
		output wire MOSI,
		output wire SCLK,
		output wire CS,

		// User ports ends
		// Do not modify the ports beyond this line


		// Ports of Axi Slave Bus Interface S00_AXI
		input wire  s00_axi_aclk,
		input wire  s00_axi_aresetn,
		input wire [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_awaddr,
		input wire [2 : 0] s00_axi_awprot,
		input wire  s00_axi_awvalid,
		output wire  s00_axi_awready,
		input wire [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_wdata,
		input wire [(C_S00_AXI_DATA_WIDTH/8)-1 : 0] s00_axi_wstrb,
		input wire  s00_axi_wvalid,
		output wire  s00_axi_wready,
		output wire [1 : 0] s00_axi_bresp,
		output wire  s00_axi_bvalid,
		input wire  s00_axi_bready,
		input wire [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_araddr,
		input wire [2 : 0] s00_axi_arprot,
		input wire  s00_axi_arvalid,
		output wire  s00_axi_arready,
		output wire [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_rdata,
		output wire [1 : 0] s00_axi_rresp,
		output wire  s00_axi_rvalid,
		input wire  s00_axi_rready
	);

	wire 			w_fetch;

	wire [7 : 0] 	w_cmd;
	wire [7 : 0] 	w_cmd_echo;
	wire 			w_cmd_valid;

	wire [7 : 0]	w_param_1;
	wire [7 : 0]	w_param_2;
	wire [7 : 0]	w_param_3;
	wire [7 : 0]	w_param_4;

	wire [55 : 0]	w_rx_data_multiple_byte;
	wire			w_spi_done;

// Instantiation of Axi Bus Interface S00_AXI
	myJSTK2_v1_0_S00_AXI # ( 
		.C_S_AXI_DATA_WIDTH(C_S00_AXI_DATA_WIDTH),
		.C_S_AXI_ADDR_WIDTH(C_S00_AXI_ADDR_WIDTH)
	) myJSTK2_v1_0_S00_AXI_inst (
		// SLV REG
		.o_fetch 						(w_fetch),
		.o_cmd 							(w_cmd),
		.o_cmd_valid 					(w_cmd_valid),
		.i_cmd_echo						(w_cmd_echo),

		.o_param_1						(w_param_1),
		.o_param_2						(w_param_2),
		.o_param_3						(w_param_3),
		.o_param_4						(w_param_4),

		.i_rx_data_multiple_byte 		(w_rx_data_multiple_byte),
		.i_spi_done				 		(w_spi_done),

		// AXI
		.S_AXI_ACLK(s00_axi_aclk),
		.S_AXI_ARESETN(s00_axi_aresetn),
		.S_AXI_AWADDR(s00_axi_awaddr),
		.S_AXI_AWPROT(s00_axi_awprot),
		.S_AXI_AWVALID(s00_axi_awvalid),
		.S_AXI_AWREADY(s00_axi_awready),
		.S_AXI_WDATA(s00_axi_wdata),
		.S_AXI_WSTRB(s00_axi_wstrb),
		.S_AXI_WVALID(s00_axi_wvalid),
		.S_AXI_WREADY(s00_axi_wready),
		.S_AXI_BRESP(s00_axi_bresp),
		.S_AXI_BVALID(s00_axi_bvalid),
		.S_AXI_BREADY(s00_axi_bready),
		.S_AXI_ARADDR(s00_axi_araddr),
		.S_AXI_ARPROT(s00_axi_arprot),
		.S_AXI_ARVALID(s00_axi_arvalid),
		.S_AXI_ARREADY(s00_axi_arready),
		.S_AXI_RDATA(s00_axi_rdata),
		.S_AXI_RRESP(s00_axi_rresp),
		.S_AXI_RVALID(s00_axi_rvalid),
		.S_AXI_RREADY(s00_axi_rready)
	);


	// Add user logic here
	JSTK2_driver JSTK2_driver_i	(
		// System
		.i_clk						(s00_axi_aclk),
		.i_n_reset					(s00_axi_aresetn),

		// SPI
		.i_miso						(MISO),
		.o_cs						(CS),
		.o_mosi						(MOSI),
		.o_sclk						(SCLK),

		// PS AXI
		.i_fetch					(w_fetch),
		.i_cmd						(w_cmd),
		.i_cmd_valid				(w_cmd_valid),

		.i_param_1					(w_param_1),
		.i_param_2					(w_param_2),
		.i_param_3					(w_param_3),
		.i_param_4					(w_param_4),

		.o_cmd_echo					(w_cmd_echo),

		.o_rx_data					(w_rx_data_multiple_byte),
		.o_done						(w_spi_done)
	);
	// User logic ends

	endmodule
