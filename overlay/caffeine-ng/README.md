2022-01-19T13:58:52Z

- To build the package:

    ```bash
    nix-build -A caffeine-ng ./shell.nix
    ```

    The output dir will be printed after finishing the build.

- To change the python version, modify line 8 at `shell.nix`, `python38Packages`, `python39Packages`, etc.
