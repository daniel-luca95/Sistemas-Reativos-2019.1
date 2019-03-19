#include "event_driven.h"
#include "app.h"
//#include "pindefs.h"

int LED =11;

void appinit(void) 
{
  pinMode(LED, OUTPUT);
  digitalWrite(LED, HIGH);
  button_listen(A1);
}

void button_changed(int p, int v) 
{
  digitalWrite(LED, v);
}

void timer_expired(void) 
{
  // Empty
}
