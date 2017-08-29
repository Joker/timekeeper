Time Keeper
===========
This plasmoid provides a clock and a calendar functions via steampunk interface.  

It is written entirely in QML + JavaScript and runs under Plasma 5.

![Time Keeper](tk.jpg)

Graphics in this plasmoid orginate from [Steampunk orrery](http://lightquick.co.uk/downloads/steampunk-orrery-xwidget.html)  

For the Moon, graphics from [Luna QML](http://kde-apps.org/content/show.php?content=140204) were used.  

[Video preview](http://vimeo.com/69154043)  

Create package
--------------

Run the following in the main directory of the project:

    $ cd plasmoid
    $ ./mkzip


Installation
------------

Run the following in the main directory of the project:

    plasmapkg2 -i timekeeper-0.5.plasmoid

Notes
-----

The Marble feature does not work. Having some problems with the Plasma 5 version,
so all this is turned off for now.
