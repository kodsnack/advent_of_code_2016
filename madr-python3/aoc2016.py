print("""
   _  _                    ____   ___  _  __
 _| || |_  __ _  ___   ___|___ \ / _ \/ |/ /_
|_  ..  _|/ _` |/ _ \ / __| __) | | | | | '_ \\
|_      _| (_| | (_) | (__ / __/| |_| | | (_) |
  |_||_|  \__,_|\___/ \___|_____|\___/|_|\___/
    """)
for i in [str(n).zfill(2) for n in range(1, 26)]:
    try:
        with open('inputs/%s.txt' % i, 'r') as puzzle_input:
            puzzle = puzzle_input.read()
        print('\n--- %s ---' % __import__('day_%s' % i).run.__doc__)
        __import__('day_%s' % i).run(puzzle)
    except IOError:
        pass
    except ImportError:
        pass
