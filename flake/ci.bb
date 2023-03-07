(ns ci
  (:require [babashka.process :refer [process]]
            [cheshire.core :as json]
            [clojure.string :refer [join]]
            [lib]
            [org.httpkit.client :as hk-client]
            [babashka.cli :as cli]))

(defn flakeref->outpath [flakeref]
  (-> (process ["nix" "eval" "--raw" (str flakeref ".outPath")])
      deref
      :out
      slurp))

(defn path->hash [path]
  (second (re-find #"\/nix\/store\/(\w+)-" path)))

(defn hash->narinfo [hash]
  (str "https://viperml.cachix.org/" hash ".narinfo"))

(defn narinfo-online? [narinfo]
  (-> (hk-client/get narinfo (fn [{:keys [status]}] status))
      deref
      (== 200)))

(def my-filter ["checks" (lib/current-system)])

(defn filter-outputs [filter' outputs]
  (as-> outputs o
    (get-in o filter')
    (keys o)
    (mapv (fn [element]
            (->> element
                 (conj filter')
                 (join ".")))
          o)))

(comment

  (def output-online
    (pmap (fn [output]
            (let [flakeref (str flake-root "#" output)]
              (-> flakeref
                  flakeref->outpath
                  path->hash
                  hash->narinfo
                  narinfo-online?)))
          test-outputs))
  output-online
  (def to-build  (zipmap test-outputs output-online))
  to-build
  (vec (keys (filter (fn [[_ v]] (not v)) to-build)))

  ;;
  )

(defn main [flake-root]
  (let
   [foo flake-root]
    nil))


(defn -main [& args]
  (let
   [opts (cli/parse-opts args {:require [:flake]})
    flake-root (opts :flake)

    all-flake-outputs (-> (process ["nix" "flake" "show" "--json" flake-root])
                          deref
                          :out
                          slurp
                          json/parse-string)

    flake-outputs (filter-outputs my-filter all-flake-outputs)
    ;;
    ]

    (prn flake-outputs)

    ;;
    ))


(defn -main [argument]
  (let [result1 (fn1 argument)
        result2 (fn2 result1)
        result3 (fn3 result2)]
    result3))

(comment
  (def argument "foo")
  (-> argument XXXX YYYY)
  )
