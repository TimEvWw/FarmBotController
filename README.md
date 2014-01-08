FarmBotController
=================

This are control classes to send all the necessary commands to the farm bot hardware. It it developed to use the Raspberry Pi as platform, connect to an arduino mega using the firmata protocol to drive the RAMPS 1.4 board.

Prerequisits
============

Rapsberry PI
------------

Update the RPi, install ruby, firmate and the arduino IDE

sudo apt-get update

sudo apt-get install ruby

gem install firmata

sudo apt-get install arduino

Arduino
-------

Start the arduino IDE in the graphic environment under the start menu / programming / Arduino IDE
Open File / Examples / Firmata / StandardFirmata
Upload to the arduino

FarmBotController
-----------------

use "git clone" to copy the code to the RPi

Usage
=====

Use "ruby menu.rb" to start the software. A menu will appear. Type the command needed and press enter. It is also possible to add a list of commands to the file 'testcommands.csv' and use the menu to execute the file.

Still to do
===========

* A lot of the settings for pins, sleep times, timeouts and motor inversions have to be moved to configuration.
* Check if it works with the nema 17 motor from OpenBuilds

