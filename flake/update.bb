(ns update
  (:require [lib]
            [babashka.fs :as fs]))

(defn update-file 
  [^sun.nio.fs.UnixPath file]
  (let [parent (fs/parent file)]
    (lib/shell-vec ["nvfetcher"
                    "--build-dir" parent
                    "--config" file])))

(defn -main []
  (lib/shell-vec ["nix flake update" lib/flake-root])
  (mapv update-file (fs/glob lib/flake-root "**/{nvfetcher}.toml")))
