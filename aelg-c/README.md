
Advent of code solutions 2016
===

Dependencies: libcrypto (md5-hash calculation, gcc should support -lcrypto)

To build and run all do:
```bash
make
```
You will have to supply your session cookie so that input can be downloaded.
In chrome log into advent of code, goto Developer tools (Ctrl+Shift+J), click Application and find
the session cookie for *Advent of code*. Copy it (only the value) and paste when make asks you.

To build the executable for a specific day do: *(replace X with a number)*
```bash
make dayX
```

To build and run a specific day do: *(replace X with a number)*
```bash
make dayX-run
```

