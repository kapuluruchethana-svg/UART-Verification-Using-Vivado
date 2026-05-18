 /*module uart_tx(
    input clk,
    input rst,
    input tx_start,
    input [7:0] tx_data,
    output reg tx,
    output reg tx_done
);

reg [3:0] bit_index;
reg [9:0] tx_shift;

always @(posedge clk or posedge rst)
begin
    if(rst)
    begin
        tx <= 1'b1;
        tx_done <= 0;
        bit_index <= 0;
        tx_shift <= 10'b1111111111;
    end

    else
    begin
        if(tx_start)
        begin
            // Frame format:
            // stop bit + data + start bit
            tx_shift <= {1'b1, tx_data, 1'b0};
            bit_index <= 0;
            tx_done <= 0;
        end

        else if(bit_index < 10)
        begin
            tx <= tx_shift[bit_index];
            bit_index <= bit_index + 1;

            if(bit_index == 9)
                tx_done <= 1;
        end
    end
end

endmodule */

module uart_tx_fsm(
    input clk,
    input rst,
    input baud_tick,
    input tx_start,
    input [7:0] tx_data,
    output reg tx,
    output reg tx_done
);

// State encoding
parameter IDLE  = 2'b00;
parameter START = 2'b01;
parameter DATA  = 2'b10;
parameter STOP  = 2'b11;

reg [1:0] state;
reg [2:0] bit_index;

always @(posedge clk or posedge rst)
begin
    if(rst)
    begin
        state <= IDLE;
        tx <= 1'b1;
        tx_done <= 0;
        bit_index <= 0;
    end

    else
    begin
        case(state)

        // IDLE STATE
        IDLE:
        begin
            tx <= 1'b1;
            tx_done <= 0;
            bit_index <= 0;

            if(tx_start)
                state <= START;
        end

        // START BIT
        START:
        begin
            if(baud_tick)
            begin
                tx <= 1'b0;
                state <= DATA;
            end
        end

        // DATA BITS
        DATA:
        begin
            if(baud_tick)
            begin
                tx <= tx_data[bit_index];

                if(bit_index < 7)
                    bit_index <= bit_index + 1;

                else
                begin
                    bit_index <= 0;
                    state <= STOP;
                end
            end
        end

        // STOP BIT
        STOP:
        begin
            if(baud_tick)
            begin
                tx <= 1'b1;
                tx_done <= 1'b1;
                state <= IDLE;
            end
        end

        default:
            state <= IDLE;

        endcase
    end
end

endmodule