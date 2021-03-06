CON
{{
This program demonstrates how to use the watchdog timer.
LEDs indicate if the watchdog is activated or not and allow you
to pet the watchdog to prevent it from timing out. It will also
display what is going on in the serial terminal.
}}

CON
  _clkmode = xtal1 + pll16x                           
  _xinfreq = 5_000_000

CON
' Define connections for test setup
' Buttons are pulled high and go low when pressed
PROCESS_LED = 0
WATCHDOG_STATUS_LED = 1
PET_BUTTON = 2
TOGGLE_BUTTON = 3

' Timeout when procesor will be reset
WATCH_DOG_TIMEOUT_MS = 5000

var
byte watchdog_status

OBJ
  WATCHDOG : "watchdog"             
  PST : "Parallax Serial Terminal"
  
PUB Start

  ' Setup the serial terminal and print a welcome message
  PST.Start(115200)
  PAUSE_MS(3000)
  PST.Str(String("Watchdog Demo Booted"))     
  PST.Str(String(13))

  ' Set the direction of pins for the buttons and LEDs
  dira[PROCESS_LED]~~
  dira[WATCHDOG_STATUS_LED]~~
  dira[PET_BUTTON]~
  dira[TOGGLE_BUTTON]~

  ' On bootup the watchdog is running by default
  watchdog_status := 1
  WATCHDOG.start(WATCH_DOG_TIMEOUT_MS)

  repeat
    ' Pet if the pet button is pressed
    if ina[PET_BUTTON]==0
      PST.Str(String("Petting"))     
      PST.Str(String(13))
      WATCHDOG.pet

    ' Check if the watchdog status needs to be toggled
    if ina[TOGGLE_BUTTON]==0
            
      if watchdog_status == 1
        PST.Str(String("Watchdog OFF"))     
        PST.Str(String(13))
        watchdog_status := 0
        WATCHDOG.stop
        
      elseif watchdog_status == 0
        PST.Str(String("Watchdog ON"))     
        PST.Str(String(13))
        watchdog_status := 1
        WATCHDOG.start(WATCH_DOG_TIMEOUT_MS)

    ' Make the LED reflect the watchdog status
    outa[WATCHDOG_STATUS_LED] := watchdog_status

    ' Dummy Process, blinking an LED to do something and
    ' so we can observe the resets              
    !outa[PROCESS_LED]               
    Pause_MS(100)

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