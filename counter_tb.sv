`timescale 1ns/1ps
module counter_tb;
    logic clk;
    logic reset;
    logic [3:0] count;

    // Instantiate the counter
    counter dut(
        .clk(clk),
        .reset(reset),
        .count(count)
    );

    // Clock generation: 10ns period
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Main test sequence
    initial begin
        // Apply reset for two cycles
        reset = 1;
        @(posedge clk);
        if (count !== 4'd0) $error("Count should be 0 during reset");
        @(posedge clk);
        if (count !== 4'd0) $error("Count should remain 0 while reset is asserted");
        reset = 0;

        // Verify counting and wrap-around
        for (int i = 1; i <= 16; i++) begin
            @(posedge clk);
            if (count !== (i % 16))
                $error("Mismatch: expected %0d got %0d at cycle %0d", i % 16, count, i);
        end

        // Assert reset again
        reset = 1;
        @(posedge clk);
        if (count !== 4'd0) $error("Counter did not reset to 0");
        $display("All counter tests passed");
        $finish;
    end
endmodule
