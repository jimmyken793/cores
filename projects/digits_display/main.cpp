#include "WProgram.h"
#include <stdlib.h>
#define PIN_0 0
#define PIN_g 1
#define PIN_c 2
#define PIN_h 3
#define PIN_d 4
#define PIN_e 5
#define PIN_b 6
#define PIN_1 7
#define PIN_2 8
#define PIN_f 9
#define PIN_a 10
#define PIN_3 12

#define POS_NUM 4
#define SEG_NUM 8
const char pos_pins[POS_NUM] = {PIN_3, PIN_2, PIN_1, PIN_0};
const char seg_pins[SEG_NUM] = {PIN_a, PIN_b, PIN_c, PIN_d, PIN_e, PIN_f, PIN_g, PIN_h};

bool input_avaliable = false;
uint8_t input_text_buf[DENNAO_RX_SIZE];
uint16_t input_text_len = 0;

#define t true
#define f false
const bool data[10][SEG_NUM] =
{
    {t, t, t, t, t, t, f, f}, // 0
    {f, t, t, f, f, f, f, f}, // 1
    {t, t, f, t, t, f, t, f}, // 2
    {t, t, t, t, f, f, t, f}, // 3
    {f, t, t, f, f, t, t, f}, // 4
    {t, f, t, t, f, t, t, f}, // 5
    {t, f, t, t, t, t, t, f}, // 6
    {t, t, t, f, f, f, f, f}, // 7
    {t, t, t, t, t, t, t, f}, // 8
    {t, t, t, t, f, t, t, f}, // 9
};
void parse_new_text();

void setDigit(int pos, int n, bool dot)
{
    for (int p = 0; p < POS_NUM; p++)
    {
        if (p == pos)
            digitalWrite(pos_pins[p], LOW);
        else
            digitalWrite(pos_pins[p], HIGH);
    }

    if (0 <= n && n <= 9)
    {
        for (int i = 0; i < SEG_NUM; i++)
        {
            digitalWrite(seg_pins[i], data[n][i] == t ? HIGH : LOW);
        }
        digitalWrite(PIN_h, dot == true ? HIGH : LOW);
    }
    else
    {
        for (int i = 0; i < SEG_NUM; i++)
        {
            digitalWrite(seg_pins[i], LOW);
        }
        digitalWrite(PIN_h, dot == true ? HIGH : LOW);
    }
}
char txt[5] = {0, 0, 0, 0};
bool dot[4] = {f, f, f, f};
// 設定整個四合一型七段顯示器想要顯示的數字
// 參數number的範圍應是0~9999
void setNumber(char txt[4], bool dot[4])
{
    // 求出每個位數的值後，分別更新
    // 注意，此處以delay(5)隔開每個位數的更新
    for (int i = 0; i < 4; i++)
    {
        setDigit(i, txt[i] - '0', dot[i]); delay(2);
    }
}
void parse_new_text(uint8_t *buf, uint16_t len)
{
    for (int i = 0; i < 4; i++)
    {
        txt[i] = 0;
        dot[i] = false;
    }
    int digit_count = 0;
    for (int i = len - 1; i >= 0 && digit_count < 4; i--)
    {
        if (isdigit(buf[i]))
        {
            txt[3 - digit_count] = buf[i];
            digit_count++;
        }
        else if (buf[i] == '.')
        {
            dot[3 - digit_count] = true;
        }
    }
}

unsigned long time_previous;
void setup()
{
    for (int i = 0; i < POS_NUM; i++)
    {
        pinMode(pos_pins[i], OUTPUT);
        digitalWrite(pos_pins[i], HIGH);
    }
    for (int i = 0; i < SEG_NUM; i++)
    {
        pinMode(seg_pins[i], OUTPUT);
        digitalWrite(seg_pins[i], LOW);
    }

    time_previous = millis();
}

int number = 0;
void loop()
{

    if (Dennao.available() > 0)
    {
        input_text_len = Dennao.recv(input_text_buf, DENNAO_RX_SIZE, 0);
        parse_new_text(input_text_buf, input_text_len);
    }
    setNumber(txt, dot);
    Dennao.send(input_text_buf, input_text_len, 0);
}
