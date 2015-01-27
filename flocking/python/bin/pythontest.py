#!/usr/bin/python
""" Test importing of numpy and scipy 
"""

import os
import platform
import sys
import time
import numpy
from scipy import sqrt, pi

print >> sys.stderr, __doc__
print "Version :", platform.python_version()
print "Program :", sys.executable
print 'Script  :', os.path.abspath(__file__)
print 'Args    :', sys.argv[1:]
print

a = numpy.arange(10000000)
b = numpy.arange(10000000)
c = a + b


h1 = sqrt(pi/2)

print a,b
print c
print h1
print 

f = open('DONE','w')
print >>f,'all','done'
sys.exit(0)

