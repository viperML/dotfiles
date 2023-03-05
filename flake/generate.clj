#!/usr/bin/env bb
(require '[cheshire.core :as json])
(require '[clojure.java.io :as io])
(require '[clojure.string :refer [replace join]])
(require '[babashka.process :refer [shell]])

(def flake_root
  (let [my_path *file*
        my_path_io (io/as-file my_path)]
    (.getParentFile (.getParentFile my_path_io))))

(def template_file
  (io/file flake_root "flake" "template.nix"))

(def output_file
  (io/file flake_root "flake.nix"))

(defn shell_vec [args]
  (shell (join " " args)))

(shell_vec ["nvfetcher"
            "-c" (io/file flake_root "flake" "nvfetcher.toml")
            "-o" (io/file flake_root "flake")])

(def inputs
  (->> (io/file flake_root "flake" "generated.json")
       slurp
       json/parse-string))

(defn get_version [input]
  (let [match (second input)]
    (get-in inputs [match "src" "rev"])))


(def output (-> template_file
                io/file
                slurp
                (replace #"%([a-zA-Z]+)%" #(get_version %))))

(with-open [w (io/writer output_file)]
  (.write w output))

(shell_vec ["nix" "flake" "lock"])
