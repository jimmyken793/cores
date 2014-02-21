#include "WProgram.h"
extern uint32_t boot_token;

char buf[DENNAO_TX_SIZE];
void setup()
{
    pinMode(LED_BUILTIN, OUTPUT);
    digitalWrite(LED_BUILTIN, HIGH);
}

void loop()
{
    uint16_t val = analogRead(0);
    sprintf(buf, "%d", val);
    Dennao.send(buf, strlen(buf), 5);
}
