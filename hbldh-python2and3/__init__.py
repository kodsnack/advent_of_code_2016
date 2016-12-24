#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os

try:
    from urllib.request import build_opener
except ImportError:
    from urllib2 import build_opener

root_dir = os.path.dirname(os.path.abspath(__file__))


def main(which_days):
    for day in which_days:
        day_input_file = os.path.join(root_dir, 'input_{0:02d}.txt'.format(day))
        if not os.path.exists(day_input_file):
            session_token = os.environ.get("AOC_SESSION_TOKEN")
            if session_token is None:
                raise ValueError("Must set AOC_SESSION_TOKEN environment variable!")
            url = 'https://adventofcode.com/2016/day/{0}/input'.format(day)
            opener = build_opener()
            opener.addheaders.append(('Cookie', 'session={0}'.format(session_token)))
            response = opener.open(url)
            with open(day_input_file, 'w') as f:
                f.write(response.read().decode("utf-8"))

        print("Solutions to Day {0:02d}\n-------------------".format(day))
        # Horrible way to run scripts, but I did not want to rewrite old solutions.
        day_module = __import__('{0:02d}'.format(day))
        print('')


if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser("Advent of Code 2016 - hbldh")
    parser.add_argument('day', nargs='*', default=None, help="Run only specific day's problem")
    parser.add_argument('--token', type=str, default=None, help="AoC session token. Needed to download data automatically.")
    args = parser.parse_args()

    if args.token:
        os.environ["AOC_SESSION_TOKEN"] = args.token

    if args.day:
        days = map(int, args.day)
    else:
        days = range(1, 26)

    main(days)
