#include "WProgram.h"

char buf[DENNAO_TX_SIZE];
int pin = 13;
void setup()
{
    pinMode(pin, OUTPUT);
    digitalWrite(pin, HIGH);
}

void loop()
{
    uint16_t val = analogRead(0);
    sprintf(buf, "%d", val);
    Dennao.send(buf, strlen(buf), 20);
}
