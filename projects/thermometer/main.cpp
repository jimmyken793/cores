#include "WProgram.h"

char buf[DENNAO_RX_SIZE];
uint16_t len = 0;
void CreateOutput(char *buf, uint16_t *len);
void ProcessInput(char *buf, uint16_t len);

const double resistor = 50000; // 100k
const double beta = 4100;
const double thermo_r = 5000; //5k

void setup(){

}

void loop(){
    if (Dennao.available() > 0)
    {
        len = Dennao.recv(buf, DENNAO_RX_SIZE, 0);
        ProcessInput(buf, len);
    }
    CreateOutput(buf, &len);
    Dennao.send(buf, len, 0);
}

void CreateOutput(char* buf, uint16_t *len)
{
    uint16_t val = analogRead(0);
    double r = (1024 - val) * resistor / val ;
    double t = 1.0 / (log(r / thermo_r) / beta + 1.0 / (273.15 + 25.0)) - 273.15;
    sprintf(buf, "%.3f\n", t);
    *len = strlen(buf);
}

void ProcessInput(char* buf, uint16_t len)
{
}