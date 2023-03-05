(ns generate
  (:require [cheshire.core :as json]
            [clojure.java.io :as io]
            [clojure.string :refer [replace]]
            [lib]))

(def template_file
  (io/file lib/flake_root "flake" "template.nix"))

(def output_file
  (io/file lib/flake_root "flake.nix"))


(def inputs
  (->> (io/file lib/flake_root "flake" "generated.json")
       slurp
       json/parse-string))

(defn get_version [input]
  (let [match (second input)]
    (get-in inputs [match "src" "rev"])))


(def output (-> template_file
                io/file
                slurp
                (replace #"%([a-zA-Z]+)%" #(get_version %))))

(defn -main []
  (with-open [w (io/writer output_file)]
    (.write w output))
  (lib/shell_vec ["nix" "flake" "lock" lib/flake_root]))
