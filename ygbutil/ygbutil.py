#!/usr/bin/env python
# 
# Copyright 2012 Yummy Melon Software LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http:#www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
#  Author: Charles Y. Choi <charles.choi@yummymelon.com>
#

import os
import sys
import getopt
import plistlib
import json
import shutil

usageString = '%s [-i <inputfile>][-h][-v][-o <outputfile>] <command>' % os.path.basename(sys.argv[0])
helpString = """

Utility to process property list (plist) files used by YmsGradientButton.

This utility can:
* convert a plist file to JSON format and vice-versa
* upgrade existing plist files from a previous release of YmsGradientButton.

The latest supported YmsGradientButton.plist version this utility supports is: %s.

## Command Line Options:

-h, --help                              help
-v, --version                           utility version
-i <inputfile>, --input=<inputfile>     input file
-o <outputfile>, --output=<outputfile>  output file; if not specified then
                                        the output file name will be auto-generated
                                        using the prefix of <inputfile>. The
                                        previous file will be copied to
                                        <inputfile>.backup

<command>                               supported commands are: 'convert', 'upgrade'

## Examples

* To upgrade a plist file named MyButton.plist
    $ ygbutil -i MyButton.plist upgrade

* To convert a plist file named MyButton.plist to a JSON file 
    $ ygbutil -i MyButton.plist convert

* To convert a JSON file named MyButton.js to a plist file
    $ ygbutil -i MyButton.js convert

"""

class YmsGradientButtonConvert:
    def __init__(self):
        self.version = "1.0"
        self.plistVersion = "1.3"
        self.options = {}
        self.options['input'] = None
        self.options['output'] = None
        self.inputBasename = None
        self.inputFileType = None
        self.outputFileType = None
        self.outputBasename = None
        self.command = 'convert'

    def validateOptions(self):
        result = True

        if not self.options['input']:
            sys.stderr.write("No input '-i' or '--input=' argument specified.")
            result = result & False

        return result
        
    def run(self, optlist, args):

        for o, i in optlist:
            if o in ('-h', '--help'):
                sys.stdout.write(usageString)
                sys.stdout.write(helpString % self.plistVersion)
                sys.exit(0)
        
            elif o in ('-v', '--version'):
                sys.stdout.write('%s\n' % self.version)
                sys.exit(0)

            elif o in ('-i', '--input'):
                self.options['input'] = i

            elif o in ('-o', '--output'):
                self.options['output'] = i

        if len(args) > 0:
            self.command = args[0]

        if not self.validateOptions():
            sys.stderr.write(" Exiting...\n")
            sys.exit(1)
        
        
        if self.command == 'convert':
            self.inputBasename, self.inputFileType = os.path.splitext(self.options['input'])

            if self.inputFileType == '.plist':
                self.convertPlist2Json()

            elif self.inputFileType in ('.js', '.json'):
                self.convertJs2Plist()
        
        elif self.command == 'upgrade':
            self.inputBasename, self.inputFileType = os.path.splitext(self.options['input'])
            if self.inputFileType == '.plist':
                self.upgradePlist()
            else:
                sys.stderr.write('ERROR: Only plist files can be upgraded. Exiting...\n')
                sys.exit(1)


    def convertJs2Plist(self):
        infileName = self.options['input']
        infile = open(infileName, 'r')

        try:
            jsonDict = json.load(infile)
        except ValueError as e:
            infile.close()
            sys.stderr.write("ERROR: can not process '%s': JSON syntax violation.\n" % infileName)
            sys.stderr.write("ERROR: %s\n" % e.args[0])
            sys.stderr.write("Exiting...\n")
            sys.exit(1)
        
        infile.close()

        for key in ('normal', 'highlighted', 'disabled', 'selected'):
            if jsonDict.has_key(key):
                for property in ('textColor', 'borderColor'):
                    jsonDict[key][property] = int(jsonDict[key][property][1:], 16)

                for gradient in jsonDict[key]['gradients']:
                    for i in range(len(gradient['colors'])):
                        gradient['colors'][i] = int(gradient['colors'][i][1:], 16)

        if jsonDict.has_key('shadow'):
            jsonDict['shadow']['shadowColor'] = int(jsonDict['shadow']['shadowColor'][1:], 16)

        outfileName = self.options['output']
        if outfileName is None:
            outfileName = self.inputBasename + '.plist'

        if os.path.exists(outfileName):
            shutil.copyfile(outfileName, outfileName + '.backup')
            
        plistlib.writePlist(jsonDict, outfileName)


    def convertPlist2Json(self):
        infileName = self.options['input']
        try:
            plistDict = plistlib.readPlist(infileName)
        except ValueError as e:
            sys.stderr.write("ERROR: can not process '%s' due to %s\n" % (infileName, e.args[0]))
            sys.stderr.write("Please convert base-16 values to base-10 values in '%s'\n" % infileName)
            sys.stderr.write("Exiting...\n")
            sys.exit(1)

        if not plistDict.has_key('version'):
            sys.stderr.write('Error: Please upgrade this file to convert to JSON\n')
            sys.exit(1)

        for key in ('normal', 'highlighted', 'disabled', 'selected'):
            if plistDict.has_key(key):
                for property in ('textColor', 'borderColor'):
                    plistDict[key][property] = '#%x' % plistDict[key][property]

                for gradient in plistDict[key]['gradients']:
                    for i in range(len(gradient['colors'])):
                        gradient['colors'][i] = '#%x' % gradient['colors'][i]

        if plistDict.has_key('shadow'):
            plistDict['shadow']['shadowColor'] = '#%x' % plistDict['shadow']['shadowColor']

        outfileName = self.options['output']
        if outfileName is None:
            outfileName = self.inputBasename + '.js'

        if os.path.exists(outfileName):
            shutil.copyfile(outfileName, outfileName + '.backup')

        outfile = open(outfileName, 'w')
        json.dump(plistDict, outfile, indent=4)
        outfile.close()


    def upgradePlist(self):
        infileName = self.options['input']

        try:
            plistDict = plistlib.readPlist(infileName)
        except ValueError as e:
            sys.stderr.write("ERROR: can not process '%s' due to %s\n" % (infileName, e.args[0]))
            sys.stderr.write("Please convert base-16 values to base-10 values in '%s'\n" % infileName)
            sys.stderr.write("Exiting...\n")
            sys.exit(1)
        

        if plistDict.has_key('version'):
            if str(plistDict['version']) == self.plistVersion:
                sys.stderr.write('Plist is already at current version %s. Exiting...\n' % self.plistVersion)
                sys.exit(1)
        else:
            plistDict['version'] = 1.3

            if plistDict['normal'].has_key('gradients'):
                # support for version 1.2
                for key in ('normal', 'highlighted', 'disabled', 'selected'):
                    if plistDict.has_key(key):                
                        for gradient in plistDict[key].gradients:
                            gradient['type'] = 'linear'

            else:
                # support for version 1.1
                for key in ('normal', 'highlighted', 'disabled', 'selected'):
                    if plistDict.has_key(key):
                        gradients = []
                        tempDict = {}
                        tempDict['type'] = 'linear'
                        for property in ('locations', 'colors', 'startPoint', 'endPoint'):
                            tempDict[property] = plistDict[key][property][:]
                            del(plistDict[key][property])
                        gradients.append(tempDict)
                        plistDict[key]['gradients'] = gradients


            if plistDict.has_key('shadow'):
                for key in ('normal', 'highlighted', 'disabled', 'selected'):
                    if plistDict.has_key(key):
                        plistDict[key]['shadow'] = dict.copy(plistDict['shadow'])

                del(plistDict['shadow'])

        outfileName = self.options['output']
        if outfileName is None:
            outfileName = self.options['input']            

        if os.path.exists(outfileName):
            shutil.copyfile(outfileName, outfileName + '.backup')
        
        plistlib.writePlist(plistDict, outfileName)
        
                
if __name__ == '__main__':

    try:
        optlist, args = getopt.getopt(sys.argv[1:], 'hvi:o:',
                                      ('help',
                                       'input=',
                                       'output=',
                                       'version'))
    except getopt.error, msg:
        sys.stderr.write(msg + '\n')
        sys.stderr.write(usageString)
        sys.exit(1)

    
    app = YmsGradientButtonConvert()
    app.run(optlist, args)
    
