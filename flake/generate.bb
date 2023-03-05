(ns generate
  (:require [cheshire.core :as json]
            [clojure.string :refer [replace split-lines]]
            [babashka.fs :as fs]
            [lib]))

(def template_file
  (fs/file lib/flake-root "flake" "template.nix"))

(def output_file
  (fs/file lib/flake-root "flake.nix"))

(def inputs
  (->> (fs/file lib/flake-root "flake" "generated.json")
       slurp
       json/parse-string))

(defn get_version [input]
  (let [match (second input)]
    (get-in inputs [match "src" "rev"])))


(def output (-> template_file
                fs/file
                slurp
                (replace #"%([a-zA-Z]+)%" #(get_version %))))

(defn -main []
  (fs/write-lines output_file (split-lines output))
  (lib/shell-vec ["nix" "flake" "lock" lib/flake-root]))
