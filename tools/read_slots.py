#!/usr/bin/python
__author__ = "archuser"

# Source: https://github.com/IlikePepsi/dt-overlays
# Maintainer: Arend Lammertink <lamare@gmail.com>
# License: GPL-2.0+, with permission from "IlikePepsi".


import argparse
import sys
import os

parser = argparse.ArgumentParser()
parser.add_argument("file", help="file to operate on")
parser.add_argument("name", help="name of the device-tree overlay")
parser.add_argument("--slot", help="return the slotnumber where the overlay was loaded")

args = parser.parse_args()


def open_file(filename):
    if not os.path.exists(filename):
        sys.exit("File not found.")
        return
    with open(filename, mode='r') as f:
        return f.readlines()


def main():
    lines = open_file(args.file)
    indices = [i for i, s in enumerate(lines) if s.find(args.name) is not -1]
    if len(indices) > 0:
        for i in indices:
            if args.slot:
                print(lines[i].split(':', 1)[0].strip()) # First character of the matching line == slotnumber
            else:
                print(lines[i].strip())
            sys.exit()
    else:
        sys.exit("Overlay not found.")
    return


if __name__ == '__main__':
    main()
