
# Build instructions

## *Nix using ninja

```sh
cd peterw-cplusplus
mkdir .build
cd .build
cmake -GNinja ..
ninja run | grep -E ^Day | sort -n
```

## *Nix using make

```sh
cd peterw-cplusplus
mkdir .build
cd .build
cmake -G"Unix Makefiles" ..
make -j8 run | grep -E ^Day | sort -n
```

## Visual Studio 2015 (Windows)

```cmd
cd peterw-cplusplus
md .build
cd .build
cmake -G"Visual Studio 14 2015 Win64"
cmake --build . --target run -- /clp:NoSummary /v:m /nologo /m | sort
```
