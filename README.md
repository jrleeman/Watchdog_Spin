# Watchdog for the Propeller

A watchdog for the propeller microcontroller written in spin. Simply watches a
memory location and if it is not updated more frequently than the timeout
period, the processor is rebooted. See demo for example of starting, stopping,
and using the watchdog. Watch for counter rollovers as that corner case has
not been extensively tested.

This was based upon [a
discussion](http://forums.parallax.com/discussion/127346/simple-watchdog-i-hope)
on the  Propeller forum and a watchdog by Peter Burkett.
