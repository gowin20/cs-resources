#!/usr/bin/python

"""
Output lines selected randomly from a file

Copyright 2005, 2007 Paul Eggert.
Copyright 2010 Darrell Benjamin Carbajal.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

Please see <http://www.gnu.org/licenses/> for a copy of the license.

$Id: randline.py,v 1.4 2010/04/05 20:04:43 eggert Exp $
"""

import random, sys
from optparse import OptionParser

class randline:
    def __init__(self, filename):
        f = open(filename, 'r')
        self.lines = f.readlines()
        f.close()

    def chooseline(self):
        return random.choice(self.lines)

def inputList():
    userInput = []
    while True:
        try: 
            i = input()
            userInput.append(i + "\n")
        except EOFError:
            return userInput

def main():
    version_msg = "%prog 2.0"
    usage_msg = """%prog [OPTION]... FILE

Output randomly selected lines from FILE."""

    parser = OptionParser(version=version_msg,
                          usage=usage_msg)
    parser.add_option("-n", "--head-count",
                      action="store", dest="numlines",
                      help="output at most COUNT lines")

    parser.add_option("-r", "--repeat",
                      action="store_true", dest="repeat", default=False,
                      help="output lines can be repeated (default False)")

    parser.add_option("-i", "--input-range",
                      action="store", dest="range", default=-1,
                      help="treat each number LO through HI as an input line")
    
    options, args = parser.parse_args(sys.argv[1:]) #change to 0 to read from stdin

#nLines is the list that we pick items from
    nLines = []

#if the -i option is specified, nLines is a list of numbers
    try:
        irange = options.range.split('-')
    except:
        irange = "-"

    if (len(irange) == 2):
        start = int(irange[0])
        end = int(irange[1])
        if (start < 0 or end < start):
            parser.error("invalid range")
        for i in range(start,end):
            nLines.append(str(i) + "\n")
    elif irange != "-":
        parser.error("-i operand takes an input LO-HI")
        quit()
#if the -i option is not specified, either read from a file or from stdin
    else:
        try:
            #read from stdin with no other args
            if len(args) == 0:
                nLines = inputList()
                #read from stdin
            else:
                if len(args) > 1:
                    parser.error("wrong number of operands")
            
                input_file = args[0]

                #read from stdin with a single '-' arg
                if input_file == "-":
                    nLines = inputList()
                #otherwise, read from the file
                else:    
                    generator = randline(input_file)
                    nLines = generator.lines

        except IOError as err:
            (errno, strerror) = err.args
            parser.error("I/O error({0}): {1}".
                         format(errno, strerror))



#option for headCount
    try:
        numlines = int(options.numlines)
        headCount = True
    except:
        numlines = 0
        headCount = False

    if numlines < 0:
        parser.error("negative count: {0}".
                     format(numlines))


    #option for repeat
    repeat = bool(options.repeat)


    try:
        while nLines: #while there' still stuff in the file
            line = random.choice(nLines)
            sys.stdout.write(line)

            if not repeat:
                nLines.remove(line) #remove the line we selected, if we said lines cannot be repeated
          

            if headCount:
                numlines -= 1
                if numlines <= 0:
                    break            

#        for index in range(len(generator.lines)):
    except IOError as err:
        (errno, strerror) = err.args
        parser.error("I/O error({0}): {1}".
                     format(errno, strerror))

if __name__ == "__main__":
    main()
