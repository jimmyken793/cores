#include "WProgram.h"


uint8_t read_buf[DENNAO_RX_SIZE];
int read_buf_len = 0;
uint8_t out_buf[DENNAO_TX_SIZE];
int out_buf_len = 0;
bool btn_state = false;
const int debounce_len = 10;
int debounce_state[10];
int debounce_index = 0;


inline static void enable()
{
}

void setup()
{
    pinMode(0, INPUT);
    pinMode(1, OUTPUT);
    digitalWrite(1, LOW);

    for (int i = 0; i < 10; i++)
    {
        debounce_state[i] = digitalRead(0);
    }
}
void loop()
{
    if (Dennao.available() > 0) {
        read_buf_len = Dennao.recv(read_buf, DENNAO_RX_SIZE, 0);
        digitalWrite(1, read_buf[0] == '1' ? HIGH : LOW);
    }
    debounce_state[debounce_index] = digitalRead(0);
    debounce_index = (debounce_index + 1) % debounce_len;
    static int sum;
    sum = 0;
    for (int i = 0; i < debounce_len; i++)
    {
        if (debounce_state[i] == 1)
        {
            sum++;
        }
    }
    if (sum >= debounce_len - 3)
    {
        btn_state = true;
    }
    else
    {
        btn_state = false;
    }
    out_buf[0] = btn_state ? '1' : '0';
    out_buf_len = 1;
    Dennao.send(out_buf, out_buf_len, 0);
}