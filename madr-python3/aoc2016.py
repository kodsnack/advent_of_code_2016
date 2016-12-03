for i in [str(n).zfill(2) for n in range(1, 5)]:
    try:
        with open('puzzles/%s.txt' % i, 'r') as puzzle_input:
            puzzle = puzzle_input.read()
        print('\n--- %s ---' % __import__('day_%s' % i).run.__doc__)
        __import__('day_%s' % i).run(puzzle)
    except IOError:
        pass
    except ImportError:
        pass
