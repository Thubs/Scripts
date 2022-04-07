#!/bin/python3

import sys
import socket
from datetime import datetime
import argparse

#define target

if len(sys.argv) == 2:
    target = socket.gethostbyname(sys.argv[1]) #translate hostname to IPV4
else:
    print("Invalid amount of arguments.")
    print("Syntax: python3 scanner.py <ip>")
    sys.exit()

#add a pretty banner
print("-" * 50)
print("Scanning target "+target)
print("Time started: "+str(datetime.now()))
print("-" * 50)

#scan ports using argparse and a try/except

try:
    for port in range(1,65535):
        s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        socket.setdefaulttimeout(1.5)
        result = s.connect_ex((target,port)) #returns an error indicator
        print("Checking port {}".format(port))
        if result == 0:
            print("Port {} is open".format(port))
        s.close()
        
except KeyboardInterrupt:
    print("\nExiting program.")
    sys.exit()
except socket.gaierror:
    print("Hostname could not be resolved.")
    sys.exit()
except socket.error:
    print("Couldn't connect to server.")
    sys.exit()
