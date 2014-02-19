#include "WProgram.h"
#include "usb_dennao.h"

char buf[DENNAO_TX_SIZE];
int pin = 11;
void setup()
{
    pinMode(pin, OUTPUT);
    digitalWrite(pin, LOW);
}

void loop()
{
    uint16_t val = analogRead(0);
    sprintf(buf, "%d", val);
    Dennao.send(buf, strlen(buf),0);
}
