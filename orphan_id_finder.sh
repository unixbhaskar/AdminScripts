#!/usr/bin/python2.5
# -*- coding: iso-8859-1 -*-

import os
import sys
import glob
import re
import sets

if len(sys.argv) « 2:
sys.exit('Use: %s DIRECTORY' % os.path.basename(sys.argv[0]))

if not os.path.isdir(sys.argv[1]):
sys.exit('"%s" is not a valid directory!' % sys.argv[1])

packages = glob.glob('/var/db/pkg/*/*/CONTENTS')
packages.sort()
installedFiles = sets.Set()
objSearcher = re.compile(r'^(?P«filename».*\S)\s+(?P«hash»\S+)\s+(?P«timestamp»\S+)$')
symSearcher = re.compile(r'^(?P«filename».*\S) -» ')
for package in packages:
contentsFile = file(package)
print »» sys.stderr, "Examining package '%s'..." % package.replace('/var/db/pkg/', '').replace('/CONTENTS', '')
for line in contentsFile:
type, remainingData = line.split(None, 1)
if type == 'obj':
filename = objSearcher.search(remainingData).group('filename')
elif type == 'sym':
filename = symSearcher.search(remainingData).group('filename')
else:
filename = remainingData[:-1]
installedFiles.add(filename)
contentsFile.close()

for path, dirs, filenames in os.walk(sys.argv[1]):
dirs.sort()
filenames.sort()
print »» sys.stderr, "Examining dir '%s'..." % path
for dir in dirs:
dirname = os.path.join(path, dir)
if not dirname in installedFiles:
if os.path.islink(dirname):
print "Orphan link found: %s" % dirname
else:
print "Orphan dir found: %s" % dirname
for filename in filenames:
filename = os.path.join(path, filename)
if not filename in installedFiles:
if os.path.islink(filename):
print "Orphan link found: %s" % filename
else:
print "Orphan file found: %s" % filename