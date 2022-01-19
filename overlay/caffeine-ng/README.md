> 2022-01-19T13:58:52Z

- To build the package with Nix:

    ```bash
    git clone https://github.com/viperML/dotfiles
    cd overlay/caffeine-ng
    nix-build -A caffeine-ng ./shell.nix
    ```

    The output dir will be printed after finishing the build. To run it, `/nix/store/<hash>-caffeine-ng-<versiobn>/bin/caffeine-ng`.

- To change the python version, modify line 8 at `shell.nix`: `python38Packages`, `python39Packages`, etc.
