module fifomem # (parameter DATASIZE = 8, // 数据位宽
                  parameter ADDRSIZE = 4, // 地址宽度
                  parameter DEPTH = 1 << ADDRSIZE)  //FIFO Depth
   (output  [DATASIZE-1 : 0]  rdata,
    input   [DATASIZE-1 : 0]  wdata,
    input   [ADDRSIZE-1 : 0]  waddr, raddr,
    input                     wclken, wfull, wclk);
    
      // RTL 模型模拟   
      reg  [DATASIZE-1 : 0] MEM [0 : DEPTH-1]; // 定义16个8位寄存器

      assign  rdata = MEM[raddr];

      always @(posedge wclk)
         if (wclken) 
            MEM[waddr] <= wdata;
endmodule
