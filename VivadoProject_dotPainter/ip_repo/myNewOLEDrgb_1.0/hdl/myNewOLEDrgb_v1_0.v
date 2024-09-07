
`timescale 1 ns / 1 ps

	module myNewOLEDrgb_v1_0 #
	(
		// Users to add parameters here

		// User parameters ends
		// Do not modify the parameters beyond this line


		// Parameters of Axi Slave Bus Interface S00_AXI
		parameter integer C_S00_AXI_DATA_WIDTH	= 32,
		parameter integer C_S00_AXI_ADDR_WIDTH	= 5
	)
	(
		// Users to add ports here
		output		wire		SCLK,
		output		wire		MOSI,
		output		wire		CS,
		output		wire		DC,
		output		wire		RES,
		output		wire		VCCEN,
		output		wire		PMODEN,
		output		wire		NC,
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

	wire 			w_start;
	wire 			w_cmd_reset;
	wire [3 : 0] 	w_num_cmd;
	wire 			w_done;

	wire [7 : 0] 	w_cmd_1;
	wire [7 : 0] 	w_cmd_2;
	wire [7 : 0] 	w_cmd_3;
	wire [7 : 0] 	w_cmd_4;
	wire [7 : 0] 	w_cmd_5;
	wire [7 : 0] 	w_cmd_6;
	wire [7 : 0] 	w_cmd_7;
	wire [7 : 0] 	w_cmd_8;
	wire [7 : 0] 	w_cmd_9;
	wire [7 : 0] 	w_cmd_10;
	wire [7 : 0] 	w_cmd_11;
	wire [7 : 0] 	w_cmd_12;
	wire [7 : 0] 	w_cmd_13;
	wire [7 : 0] 	w_cmd_14;
	wire [7 : 0] 	w_cmd_15;

// Instantiation of Axi Bus Interface S00_AXI
	myNewOLEDrgb_v1_0_S00_AXI # ( 
		.C_S_AXI_DATA_WIDTH(C_S00_AXI_DATA_WIDTH),
		.C_S_AXI_ADDR_WIDTH(C_S00_AXI_ADDR_WIDTH)
	) myNewOLEDrgb_v1_0_S00_AXI_inst (

		// OLEDrgb driver
		.o_start						(w_start),
		.o_cmd_reset					(w_cmd_reset),
		.o_num_cmd						(w_num_cmd),
		.i_done							(w_done),

		// SPI
		.o_dc							(DC),
		.o_res							(RES),
		.o_vccen						(VCCEN),
		.o_pmoden						(PMODEN),

		.o_cmd_1						(w_cmd_1),
		.o_cmd_2						(w_cmd_2),
		.o_cmd_3						(w_cmd_3),
		.o_cmd_4						(w_cmd_4),
		.o_cmd_5						(w_cmd_5),
		.o_cmd_6						(w_cmd_6),
		.o_cmd_7						(w_cmd_7),
		.o_cmd_8						(w_cmd_8),
		.o_cmd_9						(w_cmd_9),
		.o_cmd_10						(w_cmd_10),
		.o_cmd_11						(w_cmd_11),
		.o_cmd_12						(w_cmd_12),
		.o_cmd_13						(w_cmd_13),
		.o_cmd_14						(w_cmd_14),
		.o_cmd_15						(w_cmd_15),

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
	OLEDrgb_driver OLEDrgb_driver_i		(
		// System
		.i_clk							(s00_axi_aclk),
		.i_n_reset						(s00_axi_aresetn),

		// PS AXI
		.i_start						(w_start),
		.i_cmd_reset					(w_cmd_reset),

		.i_num_cmd						(w_num_cmd),
		
		.i_cmd_1						(w_cmd_1),
		.i_cmd_2						(w_cmd_2),
		.i_cmd_3						(w_cmd_3),
		.i_cmd_4						(w_cmd_4),
		.i_cmd_5						(w_cmd_5),
		.i_cmd_6						(w_cmd_6),
		.i_cmd_7						(w_cmd_7),
		.i_cmd_8						(w_cmd_8),
		.i_cmd_9						(w_cmd_9),
		.i_cmd_10						(w_cmd_10),
		.i_cmd_11						(w_cmd_11),
		.i_cmd_12						(w_cmd_12),
		.i_cmd_13						(w_cmd_13),
		.i_cmd_14						(w_cmd_14),
		.i_cmd_15						(w_cmd_15),

		.o_done							(w_done),

		// SPI
		.o_mosi							(MOSI),
		.o_sclk							(SCLK),
		.o_cs							(CS)
	);
	// User logic ends

	endmodule
