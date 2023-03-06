(ns update
  (:require [lib]
            [babashka.fs :as fs]
            [babashka.cli :as cli]))

(defn update-file
  [^sun.nio.fs.UnixPath file]
  (let [parent (fs/parent file)]
    (lib/shell-vec ["nvfetcher"
                    "--build-dir" parent
                    "--config" file])))

(defn -main [& args]
  (let [opts (cli/parse-opts args {:require [:flake]})
        flake-root (opts :flake)]
    (prn opts)
    (lib/shell-vec ["nix flake update" flake-root])
    (mapv update-file (fs/glob flake-root "**/{nvfetcher,sources}.toml"))))
