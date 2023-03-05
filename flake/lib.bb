(ns lib
  (:require 
   [babashka.process :refer [shell]]
   [clojure.string :refer [join]]
   [clojure.java.io :as io]))

(defn shell_vec [args]
  (shell (join " " args)))

(def flake_root
  (-> *file*
      io/as-file
      .getParentFile
      .getParentFile))
