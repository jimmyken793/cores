#include "WProgram.h"
#include "HardwareSerial.h"

uint8_t read_buf[DENNAO_RX_SIZE];
int read_buf_len = 0;
uint8_t out_buf[DENNAO_TX_SIZE];
int out_buf_len = 0;

HardwareSerial Uart = HardwareSerial();

void setup()
{        
    Uart.begin(38400);
    Uart.print("\rE\r");
}

void loop()
{
    if (Dennao.available() > 0) {
        read_buf_len = Dennao.recv(read_buf, DENNAO_RX_SIZE, 0);
        for(int i=0;i<read_buf_len;i++){
            Uart.print((char)read_buf[i]);
        }
    }
    if (Uart.available() > 0) {
        uint8_t incomingByte = Uart.read();
        if(incomingByte=='\r'){
            Dennao.send(out_buf, out_buf_len, 0);
        }else{
            out_buf[out_buf_len++] = incomingByte;
        }
    }
}
