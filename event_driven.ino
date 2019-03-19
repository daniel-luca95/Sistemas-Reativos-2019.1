#include "event_driven.h"
#include "app.h"
//#include "pindefs.h"
/* Funções de registro */

int buttonNumber;
int buttonState;
int countdown = -1;

#define N_OF_BUTTONS 4

int buttons[N_OF_BUTTONS];
int buttonsState[N_OF_BUTTONS];
int amount_of_buttons = 0;

void button_listen(int pin)
{
  buttons[amount_of_buttons] = pin;
  amount_of_buttons ++;
}

void timer_set(int ms)
{
  
}


/* Callbacks */

void button_changed(int pin, int v);
void timer_expired(void);

/* Programa principal */

void setup()
{
  int i;
  appinit();
  for(i =0; i < amount_of_buttons; i++)
    pinMode(buttons[i], INPUT_PULLUP);
  for(i=0; i < amount_of_buttons; i++)
    buttonsState[i] = digitalRead(buttons[i]);
}

void loop()
{
  int currentState;
  for(int i=0; i < amount_of_buttons; i++)
  {
    currentState = digitalRead(buttons[i]);
    if(currentState != buttonsState[i])
    {
      buttonsState[i] = currentState;
      button_changed(buttons[i], currentState);
    }
  }
  //
  // call timer_expired
}

