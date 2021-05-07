`timescale 1ns / 1ps


/////////////////////////////////////////////////////////////////////////////////
//  NOTE: This testbench tests the entire setup including the program memory
/////////////////////////////////////////////////////////////////////////////////


`define CLK_PERIOD 10

module tb_main();
    reg             clk;
    reg             nrst;
    wire    [31:0]  inst;
    wire    [31:0]  pc;
    wire    [31:0]  addr;
    wire            wr_en;
    wire    [63:0]  wdata;
    wire    [7:0]   wmask;
    wire    [63:0]  rdata;
    
    
    //data memory module parameters
    parameter       MEM_DATA_DEPTH      = 512;
    parameter       MEM_DATA_ADDR_WIDE  = 29;
    
    //instruction memory module parameters
    parameter       INST_MEM_DEPTH      = 512;
    parameter       INST_MEM_ADDR_WIDE  = 30;

    
    //Instantiating processor module
    processor UUT(
        .clk(clk),
        .nrst(nrst),
        .inst(inst),
        .pc(pc),
        .addr(addr),
        .wr_en(wr_en),
        .wdata(wdata),
        .wmask(wmask),
        .rdata(rdata)
    );
    
    
    //Instatiating data memory module
    mem_model #(MEM_DATA_DEPTH,MEM_DATA_ADDR_WIDE) 
        data_mem(
        .clk(clk),
        .addr(addr[31:3]),
        .rdata(rdata),
        .wr_en(wr_en),
        .wdata(wdata),
        .wmask(wmask)
    );
    
    
    
    //Instantiating instruction memory module
    mem_model #(INST_MEM_DEPTH,INST_MEM_ADDR_WIDE) 
        inst_mem(
        .addr(pc[31:2]),
        .rdata(inst)
    );
    
    
     //Generate clock 
    always #(`CLK_PERIOD/2) clk = ~clk;
    
    
    initial begin
        clk <= 0;
        nrst <= 0;
        #(`CLK_PERIOD / 2);
        nrst <= 1;
        #(`CLK_PERIOD * 20);    //run for 20 clock cycles
    end
    
    
endmodule