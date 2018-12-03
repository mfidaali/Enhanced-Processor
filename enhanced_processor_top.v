module enhanced_processor_top (

   input SYS_CLK, //50MHz
	input SW,
	input KEY,
	output [9:0] LEDR 
	
);

wire reset_n;
wire Run;
reg run_sync_1x;
reg run_sync_2x;


wire [8:0] Data2Mem;
wire [8:0] Data2Proc;
wire [8:0] ADDR;
wire WriteFromProc;

wire Done;

wire output_LED_en; //Write data from proc to output registers
wire memory_en; //write data from proc to SRAM memory

assign reset_n = KEY;
assign Run = SW;


   //Synchronize Run input to SYs_CLK
	always @(posedge SYS_CLK or negedge reset_n)
	begin
		if (!reset_n) begin
			run_sync_1x <= 'd0;
			run_sync_2x <= 'd0;
		end else begin
			run_sync_1x <= Run;
			run_sync_2x <= run_sync_1x;
		end		
	end	
	
	processor p0 (
		.clk          (SYS_CLK),
		.reset_n      (reset_n), 
		.DIN          (Data2Proc), 
	   .Run          (run_sync_2x),
		
	   .Done         (Done),
		.ADDR         (ADDR),
		.WEN			  (WriteFromProc),
	   .DOUT         (Data2Mem)
	);


	sram_1p memory(
		.address (ADDR[6:0]), //ADDR[8:7] are used for address decoding logic below
		.clock   (SYS_CLK),
		.data		(Data2Mem),	
		.wren    (memory_en),
		
		.q (Data2Proc)
		);

	//Data sent to output registers i.e. LED's
	reg_enable reg_OUT (Data2Mem, output_LED_en, SYS_CLK, LEDR[8:0]); 

	
	//Address decoding logic to decide whether data will be written to memory or output registers 
	assign output_LED_en = ~(ADDR[8] | ~ADDR[7]) & WriteFromProc;	
	assign memory_en = ~(ADDR[8] | ADDR[7]) & WriteFromProc;
	
	assign LEDR[9] = Done;


endmodule