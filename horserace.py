#!/usr/bin/python3
# -*- coding: utf8 -*-

import curses 
import time
import random

def winer(horses_position):
    return str(horses_position.index(max(horses_position)))

def status(win, msg):
    curses.setsyx(10,0)
    win.deleteln()
    win.clrtoeol()
    win.refresh()
    win.addstr(10,0, msg)
    win.refresh()
    time.sleep(0.2)
def print_horses(horses, horses_position):
    horses_string=""
    for horse in zip(horses,horses_position):
        n=horse[0]
        p=horse[1]
        horses_string+="Horse "+str(n)+": "+" "*p+"🐴\n"
    return horses_string

while True:
    horses=range(0,10)
    horses_position=[0]*10

    win=curses.initscr()
    curses.noecho()
    while (max(horses_position) < 50):
        horses_position=list(map(lambda x: x+random.randint(0,3), horses_position))
        win.addstr (0,0,print_horses(horses, horses_position))
        win.refresh()
        status(win, "Horses are running ... "+winer(horses_position)+" is first now!")
    status(win, "Horse "+str(horses_position.index(max(horses_position)))+" winer!\n(press 'a' for play again, other key for exit)")
    if (win.getkey() != "a"):
        break
curses.echo()
curses.endwin()
