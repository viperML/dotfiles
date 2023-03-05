(ns update
  (:require [lib]
            [babashka.fs :as fs]))

(def flake_root
  (->> *file*
       fs/file
       fs/parent
       fs/parent))

(defn update-file 
  [^sun.nio.fs.UnixPath file]
  (let [parent (fs/parent file)]
    (lib/shell_vec ["nvfetcher"
                    "--build-dir" parent
                    "--config" file])))


(defn flake_update []
  (lib/shell_vec ["nix flake update" lib/flake_root]))

(defn -main [& _args]
  (flake_update)
  (pmap update-file (fs/glob flake_root "**/{nvfetcher}.toml")))
