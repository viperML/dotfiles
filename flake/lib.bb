(ns lib
  (:require
   [babashka.process :refer [shell]]
   [clojure.string :refer [join]]
   [babashka.fs :as fs]))

(defn shell-vec [args]
  (let [cmd (join " " args)]
    (println (str "$ " cmd))
    (shell cmd)))
