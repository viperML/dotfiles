(ns update
  (:require [lib]
            [generate]
            [babashka.fs :as fs]
            [babashka.cli :as cli]))

(defn update-file
  [^sun.nio.fs.UnixPath file]
  (let [parent (fs/parent file)]
    (lib/shell-vec ["nvfetcher"
                    "--build-dir" parent
                    "--config" file])))


(comment
  (def flake-root (System/getenv "FLAKE"))
  (fs/glob flake-root "**/Cargo.lock"))


(defn -main [& args]
  (let [opts (cli/parse-opts args {:require [:flake]})
        flake-root (opts :flake)]
    (prn opts)
    ;; (lib/shell-vec ["nix flake update" flake-root])
    (mapv fs/delete (fs/glob flake-root "**/Cargo.lock"))
    (mapv update-file (fs/glob flake-root "**/{nvfetcher,sources}.toml"))
    (generate/main flake-root)))
