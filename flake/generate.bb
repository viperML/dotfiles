(ns generate
  (:require [cheshire.core :as json]
            [clojure.string :refer [replace split-lines]]
            [babashka.fs :as fs]
            [lib]))

(defn get-inputs [root]
  (->> (fs/file root "flake" "generated.json")
       slurp
       json/parse-string))

(defn get-version [inputs input-name]
  (get-in inputs [input-name "src" "rev"]))

(defn replace-matches [inputs flake-text]
  (replace flake-text #"%([a-zA-Z]+)%" #(get-version inputs (second %))))

(comment
  (get-inputs (System/getenv "FLAKE"))
  (get-version (get-inputs (System/getenv "FLAKE")) "hyprland"))

(defn -main [flake-root]
  (let [inputs (json/parse-string (slurp (fs/file flake-root "flake" "generated.json")))
        old-text (slurp (fs/file flake-root "flake" "template.nix"))
        new-text (replace-matches inputs old-text)]
    (fs/write-lines (fs/file flake-root "flake.nix") (split-lines new-text)))
  (lib/shell-vec ["nix" "flake" "lock" flake-root]))
