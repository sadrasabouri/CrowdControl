# CrowdControl
Bank Crowd Control (Turn Rating) System Simulator - AVR

Bank Crowd Control/Turn Rating Simulator is a AVR - ATMEAG32 - project which aims to simulate a specefic sysmtem of turn rating.
In this system counters from `#1` to `#5` do the same works while `#6` and `#7` do different special works.

Each customer will choose a key (between `1` - `3`):

+ `1` for submiting a turn in `#1` to `#5` counters

+ `2` for submiting a turn in `#6` counter

+ `3` for submiting a turn in `#7` counter

In each case turn will be given to the customer iff there is at leat one counter empty in desired counters, then cusomer will be informed to go to which counter by the message that will be shown in LCD.

At the end of the process of each counter one should push it's key so that new customer will be informed by new empty space, keys are assigned as bellow:

+ `0` for end of `#7` counter

+ `4` for end of `#6` counter

+ `5` for end of `#5` counter

+ `6` for end of `#4` counter

+ `7` for end of `#3` counter

+ `8` for end of `#2` counter

+ `9` for end of `#1` counter

When there is no message to be informed, LCD should show current time. Work hour is between `7:30 AM` to `1:30 PM` and new turn submissions won't be accepted since `1:30 PM` but earlier turn submissions would be given to customers after that time.

<img src="https://github.com/sadrasabouri/CrowdControl/blob/main/Others/Shematic.PNG">

## Developers

* **Mohammad Sina Hassan Nia** [Mohammad Sina Hassan Nia](https://github.com/sinahsnn)
* **Sadra Sabouri** [Sadra Sabouri](https://github.com/sadrasabouri)
* **Mohammad Qumi** [Mohammad Qumi](https://github.com/Mohammad-Qumi)

## Technical Detail

There is interrupt service routine wich handles inputted keys (which can be easily understand how it's work from above picture - pressing on any key will fall `INT0` from `VCC` to `GND` so interuppt will be called and it will figure out which key has been pressed by changing the input/output side of the keypad -).

Also LCD system is widely used in any microprocessor project.

For controling the turning submissions we need a memory for remembering which customer submited turn for which type of counters, so we used `que` type memory wich is just like `stack` but `FIFO`.
By this structure we will save any turn request after all the desired type of counters are full (`push`ing into que), then `pop`ing from it after each counter keypress.

Also for each turn submission in `#1` to `#5` set, there is a mechanism that checks counters from `#1` to `#5` and inform if one of them is empty, if not early consideration will be taken.
