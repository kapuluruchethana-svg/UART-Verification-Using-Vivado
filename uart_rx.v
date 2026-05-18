module uart_rx(
    input clk,
    input rst,
    input baud_tick,
    input rx,
    output reg [7:0] rx_data,
    output reg rx_done
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
        rx_data <= 8'b0;
        rx_done <= 0;
        bit_index <= 0;
    end

    else
    begin
        case(state)

        // ================= IDLE =================
        IDLE:
        begin
            rx_done <= 0;

            // Detect start bit
            if(rx == 0)
                state <= START;
        end

        // ================= START =================
        START:
        begin
            if(baud_tick)
            begin
                bit_index <= 0;
                state <= DATA;
            end
        end

        // ================= DATA =================
        DATA:
        begin
            if(baud_tick)
            begin
                rx_data[bit_index] <= rx;

                if(bit_index < 7)
                    bit_index <= bit_index + 1;

                else
                    state <= STOP;
            end
        end

        // ================= STOP =================
        STOP:
        begin
            if(baud_tick)
            begin
                rx_done <= 1;
                state <= IDLE;
            end
        end

        default:
            state <= IDLE;

        endcase
    end
end

endmodule