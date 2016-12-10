
Advent of code solutions 2016
===

Dependencies: libcrypto (md5-hash calculation, gcc should support -lcrypto), curl (when downloading inputs).

To build and run all do:
```bash
make
make # Make again for less noisy output.
```
You will have to supply your session cookie so that input can be downloaded.
In chrome log into advent of code, goto Developer tools (Ctrl+Shift+J), click Application and find
the session cookie for *Advent of code*. Copy it (only the value) and paste when make asks you.

If you don't want to supply your session cookie you can still do the following

To build the executable for a specific day do: *(replace X with a number)*
```bash
make dayX
```

To build and run a specific day do: *(replace X with a number)*
```bash
touch session-cookie                   # Skip if you supplied a cookie
cat your_input_file > input-dayX.txt   # Skip if you supplied a cookie
make dayX-run
```

To manually run a built binary (X is the day, Y is the part (1 or 2))
```bash
make dayX
./dayX Y < your_input_file
```
