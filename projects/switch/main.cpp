#include "WProgram.h"

char buf[DENNAO_RX_SIZE];
uint16_t len = 0;
void CreateOutput(char *buf, uint16_t *len);
void ProcessInput(char *buf, uint16_t len);

const uint8_t pin = 0;

long lastDebounceTime = 0;  // the last time the output pin was toggled
const long debounceDelay = 50;    // the debounce time; increase if the output flickers
int lastButtonState = LOW;   // the previous reading from the input pin
int buttonState = LOW;             // the current reading from the input pin



void setup()
{
    pinMode(pin, INPUT);
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

    int reading = digitalRead(pin);
    if (reading != lastButtonState)
    {
        lastDebounceTime = millis();
    }
    if ((millis() - lastDebounceTime) > debounceDelay)
    {
        buttonState = reading;
    }
    lastButtonState = reading;
}

void CreateOutput(char *buf, uint16_t *len)
{
    sprintf(buf, "%d\n", buttonState);
    *len = strlen(buf);
}

void ProcessInput(char *buf, uint16_t len)
{

}