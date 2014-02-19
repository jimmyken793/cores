#include "WProgram.h"

uint8_t buf[DENNAO_RX_SIZE];
uint16_t len = 0;
void CreateOutput(uint8_t *buf, uint16_t *len);
void ProcessInput(uint8_t *buf, uint16_t len);

const int states[4][4] =
{
    {1, 0, 0, 1},
    {1, 0, 1, 0},
    {0, 1, 1, 0},
    {0, 1, 0, 1}
};

const int pins[4] = {0, 1, 2, 3};
int state = 0;
const int step_buf_len = 64;
int step_buf[64][3];
int step_buf_head = 0;
int step_buf_tail = 0;

inline static void enable()
{
    digitalWrite(4, HIGH);
}
inline static void disable()
{
    digitalWrite(4, LOW);
}
inline static void step(int direction)
{
    // _delay_ms(200);
    state += direction > 0 ? 1 : -1;
    state = (state + 4) % 4;
    for (int i = 0; i < 4; i++)
    {
        digitalWrite(pins[i], states[state][i] == 0 ? LOW : HIGH);
    }
}

void setup()
{
    for (int i = 0; i < 4; i++)
    {
        pinMode(pins[i], OUTPUT);
    }
    pinMode(4, OUTPUT);
    disable();
}

void loop()
{
    if (Dennao.available() > 0)
    {
        len = Dennao.recv(buf, DENNAO_RX_SIZE, 0);
        ProcessInput(buf, len);
    }
    CreateOutput(buf, &len);
    Dennao.send(buf, len, 0);
    if (step_buf_head != step_buf_tail)
    {
        enable();
        for (int i = 0; i < step_buf[step_buf_head][1]; i++)
        {
            step(step_buf[step_buf_head][0]);
            delay(step_buf[step_buf_head][2]);
        }
        disable();
        step_buf_head = (step_buf_head + 1) % step_buf_len;
    }
}
bool done = false;
void CreateOutput(uint8_t* buf, uint16_t *len)
{
    *len = 1;
    if (step_buf_tail >= step_buf_head)
    {
        buf[0] = step_buf_len - (step_buf_tail - step_buf_head);
    }
    else
    {
        buf[0] = step_buf_len - (step_buf_tail + step_buf_len - step_buf_head);
    }
}

void ProcessInput(uint8_t* buf, uint16_t len)
{
    step_buf[step_buf_tail][0] = (buf[0] > 0 ? 1 : -1);
    step_buf[step_buf_tail][1] = buf[1] ;
    step_buf[step_buf_tail][2] = buf[2];
    step_buf_tail = (step_buf_tail + 1) % step_buf_len;
}
