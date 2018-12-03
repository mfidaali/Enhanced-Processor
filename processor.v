module processor (

	input [8:0] DIN,
	input reset_n, 
	input clk, 
	input Run,
	
	output reg Done,
	output  [8:0] DOUT,
	output  WEN, //To tell external memory to write data "DOUT" into address "ADDR" 
	output  [8:0] ADDR
	
	);

//parameter T_LD = 5'b00001, T_RUN = 5'b00010, T1 = 5'b00100, T2 = 5'b01000, T3 = 5'b10000; 
//parameter T_LD = 5'b00001, T1 = 5'b00010, T2 = 5'b00100, T3 = 5'b01000, T4 = 5'b10000; 
parameter T_LD = 6'b000001, T_RUN = 6'b000010, T1 = 6'b000100, T2 = 6'b001000, T3 = 6'b010000, T4 = 6'b100000;

reg [5:0] Tstep_D, Tstep_Q;


//**********************
//Output of Control FSM
//**********************
wire [9:0] select; //select for main mux output (BusWires)
reg [7:0] RSel;
reg GSel, DINsel;

reg [7:0] Rin; //Enable signals for R# Registers + PC Register (R7)

reg IRin; //Enable signal
reg AddOrSub; //0 means add, 1 mean subtract
reg Ain; //Enable signal
reg Gin; //Enable signal
reg ADDRin; //Enable signal for ADDR reg
reg DOUTin; //Enable signal for DOUT reg;
reg WENin;
reg incr_PC;
//**********************


//Instruction Reg declarations
wire [8:0] IR; //Instruction Register value, set when IRin from FSM goes high
wire [2:0] Instruction;



//Accumulator, Adder, G Reg declarations
wire [8:0] A;
wire [8:0] AddSubOut;
wire [8:0] G;


//R0-R7 reg declarations
wire [8:0] R0;
wire [8:0] R1;
wire [8:0] R2;
wire [8:0] R3;
wire [8:0] R4;
wire [8:0] R5;
wire [8:0] R6;
wire [8:0] PC;


//Xreg and Yreg declarations from Instruction register
wire [7:0] Xreg;
wire [7:0] Yreg;


//Breaking apart the Instruction Data
assign Instruction = IR[8:6];

dec3to8 decX (IR[5:3], 1'b1, Xreg);
dec3to8 decY (IR[2:0], 1'b1, Yreg);

//clear for counter
wire clear;

//Output Control Mux
reg [8:0] BusWires;

//Necessary for mvnz instruction. Check to see if reg_G is 0 or not 
wire reg_G_empty;
assign reg_G_empty = (G==0);

/*//Rising Edge detect of Run to signal to increment pointer for next address to fetch from memory
wire run_rise_detect;
reg run_ff;
assign run_rise_detect = run & ~run_ff;
always @(posedge clk or negedge resetn) begin
	if (!resetn)
		run_ff <=0;
	else
		run_ff <= run;
end
*/

// Control FSM state table
always @(Tstep_Q, Run, Done)
begin
	case (Tstep_Q)
		T_LD: //Load new instruction into IR. 
			if (!Run) 
				Tstep_D = T_LD;
			else 
				Tstep_D = T_RUN;
		T_RUN: //Run Instruction has asserted 
				 //Before running instruction, increment PC //and send new PC address to memory to fetch next instruction
				Tstep_D = T1;
		T1: // 1st time step run for current instruction
			if (Done) 
				Tstep_D = T_LD; //Load new instruction (fetched from T_Run) because current instruction has completed
			else 
				Tstep_D = T2; //Go to next time step because current instruction has not completed
		T2: // 2nd time step run for current instruction
			if (Done) 
				Tstep_D = T_LD; //Load new instruction (fetched from T_Run) because current instruction has completed
			else 
				Tstep_D = T3; //Go to next time step because current instruction has not completed		
		T3: // 3rd time step run
			if (Done) 
				Tstep_D = T_LD; //Load new instruction (fetched from T_Run) because current instruction has completed
			else 
				Tstep_D = T4; //Go to next time step because current instruction has not completed	
		T4: // 4th time step run
			 // All instructions should be done by now
			 // Load new instruction (fetched from T_Run) because current instruction has completed
				Tstep_D = T_LD; 
				
	endcase
end


// Control FSM outputs
always @(Tstep_Q or Instruction or Xreg or Yreg)
begin
	incr_PC = 1'b0;
	
	//Selects for muxes
	RSel[7:0] = 8'b0; 
	GSel = 1'b0; 
	DINsel = 1'b0;
	
	//Add/Sub defaults to add
	AddOrSub = 1'b0;
	
	//Enables for registers
	IRin  = 1'b0;
	Ain = 1'b0;
	Gin = 1'b0;
	Rin[7:0] = 8'b0;
	ADDRin = 1'b0;
	DOUTin = 1'b0;
	WENin = 1'b0;
	
	//Done signal defaults to 0
	Done  = 1'b0;

	case (Tstep_Q)
		T_LD: //Load instruction into IR
		begin
				IRin = 1; //Load new instruction into Inst Reg
				
				RSel[7] = 1;
				ADDRin =  1;
		end
		T_RUN:  //Start current instruction
		begin
				incr_PC = 1; //Increment PC counter so it points to next instruction address	
				
				//RSel[7] = 1; //Load new PC counter addr into memory via RSel[7] and ADDRin enable				
				//ADDRin =  1;
		end		
		T1: //Begin instruction
			casez (Instruction)
				3'b000: //mv instruction: copy data from Yreg to Xreg
					begin
						RSel = Yreg; 
						Rin = Xreg;
						Done = 1;
					end
				3'b001: //mvi instruction: copy data from DIN to Xreg
					begin
						RSel[7] = 1; //Load new PC counter addr into memory via RSel[7] and ADDRin enable				
						ADDRin =  1;
						//DINsel = 1;
						//Rin = Xreg;
						incr_PC = 1; //Increment PC counter for next memory instruction (since IMMEDIATE Data was supplied to DIN from memory at this cycle)
					end
				3'b010: //add instruction part 1: Put data in Xreg into Reg A
					begin
						RSel = Xreg;
						Ain = 1;
					end	
				3'b011: //subtract instruction part 1: Put data in Xreg into Reg A
					begin
						RSel = Xreg;
						Ain = 1;
					end
				3'b100: //load instruction: load data into Xreg from external memory address specified in Yreg
				        //part 1: Take address from Yreg and put it into Reg ADDR
					begin
						RSel = Yreg;
						ADDRin = 1;
					end
				3'b101: //store instruction: Write data in Xreg to memory at addr stored in Yreg 
						  //part 1: Take address from Yreg and put it into Reg ADDR
					begin
						RSel = Yreg;
						ADDRin = 1;
					end
				3'b110: //mvnz instruction: move data from Yreg to Xreg only if contents in Reg G are not 0
					begin
						if (!reg_G_empty) begin
							RSel = Yreg; 
							Rin = Xreg;
						end
						Done = 1;
					end
			endcase
		T2: //define signals in time step 2
			case (Instruction)
				3'b001: //mvi instruction: Fetch new instruction now that mvi is complete (since last fetch was for Immediate data)
					begin
						DINsel = 1;
						Rin = Xreg;
						//ADDRin =  1;
						//RSel[7] = 1;
						//Done = 1;
					end
				3'b010: //add instruction part 2: Add Yreg data with Reg A data and put result into Reg G
					begin
						RSel = Yreg;
						Gin = 1;
						AddOrSub = 0;
					end	
				3'b011: //subtract instruction part 2: Subtract Yreg data from Reg A data and put result into Reg G
					begin
						RSel = Yreg;
						Gin = 1;
						AddOrSub = 1;
					end
				3'b100: //load instruction part 2: Will have to wait one cycle to get data from external memory
					begin
						Done = 0;
					end
				3'b101: //store instruction part 2: Take data from Xreg and put it into Reg DOUT, assert write enable (WEN)
					begin
						RSel = Xreg;
						DOUTin = 1;
						WENin = 1;
					end	
			endcase
		T3: //define signals in time step 3
			casez (Instruction)
				3'b001: //mvi instruction: Fetch new instruction now that mvi is complete (since last fetch was for Immediate data)
					begin
						ADDRin =  1;
						RSel[7] = 1;
						Done = 1;
					end				
				3'b011: //add instruction part 3: Put resulting Reg G data into Xreg and assert done for new instruction
					begin
						Rin = Xreg;
						GSel = 1;
						Done = 1;
					end
				3'b011: //subtract instruction part 3: Put resulting Reg G data into Xreg and assert done for new instruction
					begin
						Rin = Xreg;
						GSel = 1;
						Done = 1;
					end
				3'b100: //load instruction part 3: Put data from memory (DIN) into Xreg
					begin
						DINsel = 1;
						Rin = Xreg;
						Done = 1;
					end
				3'b101: //store instruction part 3: Assert done and fetch new instruction from memory at address in PC
					begin
						ADDRin =  1;
						RSel[7] = 1;
						Done = 1;
					end				
			endcase
		T4: //define signals in time step 4
			casez (Instruction)
				3'b100: //load instruction part 4: Assert done and fetch new instruction from memory at address in PC
					begin
						ADDRin =  1;
						RSel[7] = 1;
						Done = 1;
					end			
			endcase
			
	endcase
end


// Control FSM flip-flops
always @(posedge clk, negedge reset_n)
begin
	if (!reset_n)
		Tstep_Q <= T_LD;
	else
		Tstep_Q <= Tstep_D;
end	

//Instruction Register Instantiation
reg_enable reg_inst (DIN, IRin, clk, IR);

//Accumulator, Adder, and G Register Instantiation
reg_enable reg_A (BusWires, Ain, clk, A);
addsub Addsub (A, BusWires, AddOrSub, clk, AddSubOut); 
reg_enable reg_G (AddSubOut, Gin, clk, G);

//Reg0-6 Instantiation
reg_enable reg_0 (BusWires, Rin[0], clk, R0);
reg_enable reg_1 (BusWires, Rin[1], clk, R1);
reg_enable reg_2 (BusWires, Rin[2], clk, R2);
reg_enable reg_3 (BusWires, Rin[3], clk, R3);
reg_enable reg_4 (BusWires, Rin[4], clk, R4);
reg_enable reg_5 (BusWires, Rin[5], clk, R5);
reg_enable reg_6 (BusWires, Rin[6], clk, R6);

//ADDR Reg Instantiation
reg_enable reg_ADDR (BusWires, ADDRin, clk, ADDR);

//DOUT Reg Instantiation
reg_enable reg_DOUT (BusWires, DOUTin, clk, DOUT);


//Write enable Reg instantiation
reg_enable reg_WEN (1'b1, WENin, clk, WEN); 

//Program Counter Instantiation
assign clear = ~reset_n;
counterlpm ProgCount (
	.aclr   (clear),
	.clock  (clk),
	.cnt_en (incr_PC),
	.data   (BusWires),
	.sload  (Rin[7]),
	
	.q      (PC)
	);

//Mux instantiation for BusWires definition
assign select = {RSel[7:0], GSel, DINsel};

always @(select or RSel or GSel or DINsel) begin
	case(select)
		10'b0000000001: BusWires = DIN;
		10'b0000000010: BusWires = G;
		10'b0000000100: BusWires = R0;
		10'b0000001000: BusWires = R1;
		10'b0000010000: BusWires = R2;
		10'b0000100000: BusWires = R3;
		10'b0001000000: BusWires = R4;
		10'b0010000000: BusWires = R5;
		10'b0100000000: BusWires = R6;
		10'b1000000000: BusWires = PC;
	   default: BusWires = DIN;	
	endcase
end



endmodule