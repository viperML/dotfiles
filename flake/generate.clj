#!/usr/bin/env bb
(require '[cheshire.core :as json])
(require '[clojure.java.io :as io])

(def flake_root
  (let [my_path *file*
        my_path_io (io/as-file my_path)]
    (.getParentFile (.getParentFile my_path_io))))

(def template_file
  (io/file flake_root "flake" "template.nix"))

(def output_file
  (io/file flake_root "flake.nix"))

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
                (clojure.string/replace #"%([a-zA-Z]+)%" #(get_version %))))

(with-open [w (io/writer output_file)]
  (.write w output))
