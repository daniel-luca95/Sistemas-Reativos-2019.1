#include "event_driven.h"
#include "app.h"

#define ON LOW
#define OFF HIGH

int button1 = A1;
int button1State = HIGH;
int button2 = A2;
int button2State = HIGH;

int LED = 10;
int period = 1000;

void appinit(void)
{
  pinMode(LED, OUTPUT);
  digitalWrite(LED, OFF);
  button_listen(button1);
  button_listen(button2);
}

void button_changed(int p, int v)
{
  if(p==button1)
	button1State = v;
  else // is button 2
	button2State = v;
  if ( button1State == ON && buton2State == ON)
    
}


