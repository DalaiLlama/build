#!/usr/bin/env python
#
import os
import sys
from distutils.version import StrictVersion

min="0.0.0"
max="0.0.0"
version="0.0.0"

def usage():
  sys.stderr.write("""Usage: %(progName)s [<options>]
Options:
   --min=<minimum version>
       Minimum version number required.
   --version=<version number>
       Actual version number
   --max=<maximum version>
       Maximum version number allowed. (Optional)
""" % {
      "progName": os.path.split(sys.argv[0])[1],
    })
  sys.exit(1)


def arguments(argv):
  if len(argv)-1 < 2 or len(argv)-1 > 3: # Only expecting two or three parameters
    usage()
  i=1
  while i<len(argv):
    arg = argv[i]
    if arg.startswith("--min="):
      try:
        global min
        min = arg[len("--min="):]
      except ValueError:
        usage()
    elif arg.startswith("--version="):
      try:
        global version
        version = arg[len("--version="):]
      except ValueError:
        usage()
    elif arg.startswith("--max="):
      try:
        global max
        max = arg[len("--max="):]
      except ValueError:
        usage()
    else:
      usage()
    i += 1


def main(argv):
  arguments(argv)
  if max == "0.0.0": # Max version not defined
    print ( StrictVersion(min) < StrictVersion(version) )
  else:
    print ( StrictVersion(min) < StrictVersion(version) and StrictVersion(version) < StrictVersion(max) )


if __name__ == "__main__":
  main(sys.argv)
