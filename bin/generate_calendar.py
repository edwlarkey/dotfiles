#!/usr/bin/env python3

"""
This generates a text calendar for a year.

Usage:
    ./generate_calendar.py YEAR

    To write the calendar to a txt file, redirect the output to file.txt
    e.g.: ./generate_calendar.py 2014 > 2014.txt

Author: Edward G. Larkey (edwlarkey at mac dot com)
Copyright: Copyright (c) 2014 Edward G. Larkey
License: GPLv3

"""

import calendar
import sys
import datetime

# year from arguments
YEAR = int(sys.argv[1])

# Month start at January
MONTH = 1


def print_calendar(year, month):
    """Prints a text calendar of the year and month supplied."""

    cal = calendar.month(year, month)
    print(cal)


def print_days(year, month):
    """
    Prints each day in a month in the format:
    YYYY-MM-DD  A[:1]  :
    """
    day = 1
    last_day = calendar.monthrange(year, month)[1]

    while day <= last_day:
        # date
        date = datetime.date(year, month, day)

        # string date
        strdate = date.strftime('%Y-%m-%d')

        # full day of week
        dow = date.strftime('%A')

        # convert day of week(dow) into single character dayofweek
        if dow == "Monday":
            dayofweek = 'M'
        elif dow == "Tuesday":
            dayofweek = 'T'
        elif dow == "Wednesday":
            dayofweek = 'W'
        elif dow == "Thursday":
            dayofweek = 'R'
        elif dow == "Friday":
            dayofweek = 'F'
        else:
            dayofweek = 'S'

        # if it is the beginning of the week, print a new line first.
        if dayofweek == 'M':
            print()
            print("%s  %s  :" % (strdate, dayofweek))
        else:
            print("%s  %s  :" % (strdate, dayofweek))

        day += 1

    # print ^^ at the end of the month (used for gawk printing stop pattern)
    print("^^\n")


# for each month of the year, print calendar and then list of dates.
while MONTH <= 12:
    print_calendar(YEAR, MONTH)
    print_days(YEAR, MONTH)
    MONTH += 1
