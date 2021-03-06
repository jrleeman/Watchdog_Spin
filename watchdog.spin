VAR
byte watchDogCogId
long watchDogTimer, timeout_ms
long watchDogStack[16]

PUB WATCHDOG
  {
   Main watchdog function that gets started in a new cog. Every 10 ms
   (can be changed to suit) it looks at how long it has been since
   the watchdog was pet. If it is longer than the timeout value
   the processor is rebooted. Otherwise, it just loops again. Be wary
   of counter rollover issues for very long timeout times.
  }
  watchDogTimer := CNT ' Initialize the timer count

  repeat
    PAUSE_MS(10)
    if (CNT - watchDogTimer) > (clkfreq/1000 * timeout_ms) 
      REBOOT

PUB start(timeout)
  {
  Starts a watchdog timer in a new cog and returns the ID of that
  cog.
  }
  timeout_ms := timeout
  watchDogCogId := cognew(WATCHDOG, @watchDogStack)
  return watchDogCogId

PUB stop
  {
  Stops the watchdog if it is running. If the watchdog has been previously
  stopped, the cogid will be -1.
  }

  if watchDogCogId == -1
    return watchDogCogId
    
  cogstop(watchDogCogId)
  watchDogCogId := -1
  return watchDogCogId

PUB pet
  {
  Pets the watchdog by putting the current value of the system
  counter into the watchDogTimer variable.
  }
  watchDogTimer := CNT

PUB PAUSE_MS(mS)
  {
  Pauses the processor for the given number of milli-seconds.
  }
  waitcnt(clkfreq/1000 * mS + cnt)

DAT
{{
┌─────────────────────────────────────────────────────────────────────────────────────────┐
│                                TERMS OF USE: MIT License                                │                                                            
├─────────────────────────────────────────────────────────────────────────────────────────┤
│Permission is hereby granted, free of charge, to any person obtaining a copy of this     │
│software and associated documentation files (the "Software"), to deal in the Software    │
│without restriction, including without limitation the rights to use, copy, modify, merge,│
│publish, distribute, sublicense, and/or sell copies of the Software, and to permit       │
│persons to whom the Software is furnished to do so, subject to the following conditions: │
│                                                                                         │
│The above copyright notice and this permission notice shall be included in all copies or │
│substantial portions of the Software.                                                    │
│                                                                                         │
│THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESSED OR IMPLIED,    │
│INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR │
│PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE│
│FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR     │
│OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER   │
│DEALINGS IN THE SOFTWARE.                                                                │
└─────────────────────────────────────────────────────────────────────────────────────────┘
}}   