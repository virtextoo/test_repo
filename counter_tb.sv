module counter_tb;
    logic clk;
    logic reset;
    logic [3:0] count;

    counter uut (
        .clk(clk),
        .reset(reset),
        .count(count)
    );

    // Clock generation: 10 time unit period
    initial clk = 0;
    always #5 clk = ~clk;

    // Expected count for comparison
    logic [3:0] expected;

    initial begin
        expected = 4'b0000;
        reset = 1;
        repeat (2) @(posedge clk);
        reset = 0;
        repeat (20) @(posedge clk); // count past wrap-around
        reset = 1;
        @(posedge clk);
        reset = 0;
        repeat (2) @(posedge clk);
        $display("Testbench completed.");
        $finish;
    end

    // Reference model for expected value
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            expected <= 4'b0000;
        end else begin
            expected <= expected + 1'b1;
        end
    end

    // Compare DUT output with expected value
    always @(posedge clk) begin
        if (count !== expected) begin
            $display("Mismatch at time %0t: count=%b expected=%b", $time, count, expected);
            $finish;
        end
    end

endmodule
