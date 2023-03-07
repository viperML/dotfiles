(ns lib
  (:require
   [babashka.process :refer [shell]]
   [clojure.string :refer [join]]
   [babashka.process :refer [process]]))

(defn shell-vec [args]
  (let [cmd (join " " args)]
    (println (str "$ " cmd))
    (shell cmd)))

(defn current-system []
  (-> (process ["nix" "eval" "--raw" "--impure" "--expr" "builtins.currentSystem"])
      deref
      :out
      slurp))
