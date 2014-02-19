#include "WProgram.h"

uint8_t buf[DENNAO_RX_SIZE];
uint16_t len = 0;
void CreateOutput(uint8_t *buf, uint16_t *len);
void ProcessInput(uint8_t *buf, uint16_t len);

const int pin = 0;


void setup()
{
    pinMode(pin, OUTPUT);
}
bool state = false;
void loop()
{
    digitalWrite(pin, state ? HIGH : LOW);
    if (Dennao.available() > 0)
    {
        len = Dennao.recv(buf, DENNAO_RX_SIZE, 0);
        ProcessInput(buf, len);
    }
    CreateOutput(buf, &len);
    Dennao.send(buf, len, 0);
}

void CreateOutput(uint8_t *buf, uint16_t *len)
{
    *len = 1;
    buf[0] = state ? 1 : 0;
}

void ProcessInput(uint8_t *buf, uint16_t len)
{
    if (len >= 1)
    {
        switch (buf[0])
        {
        case '1':
            state = true;
            break;
        case '0':
            state = false;
            break;
        }
    }
}
