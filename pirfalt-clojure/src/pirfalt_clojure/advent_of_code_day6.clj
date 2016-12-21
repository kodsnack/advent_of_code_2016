(ns pirfalt-clojure.advent_of_code-day6
  (:require [clojure.string :as string]
            [clojure.repl :as repl]))

(def input "eedadn
drvtee
eandsr
raavrd
atevrs
tsrnev
sdttsa
rasrtv
nssdts
ntnada
svetve
tesnvt
vntsnd
vrdear
dvrsen
enarar")

(def output "easter")

(defn problem-1 [lines]
  (->> (apply map vector lines)       ; [1 2] [3 4] [5 6] [7 8] -> [1 3 5 7] [2 4 6 8]
    (map (fn [column]                 ; do to each column
          (->> column
            (sort)
            (partition-by identity)   ; partition repeted input, on sorted list
            (sort-by count)           ; least repeted first
            (last)                    ; most repeted, as partitioned list
            (first))))                ; result for this column, any element that is most repeted, first is easy
    (apply str)))                     ; transform the list of results to a string

(defn problem-2 [lines]
  (->> (apply map vector lines)
    (map (fn [column]
          (->> column
            (sort)
            (partition-by identity)
            (sort-by count)
            (first)                   ; least repeted
            (first))))
    (string/join)))                   ; also works

(println "Problem 1: " 
  (problem-1 (string/split-lines (slurp "./resources/day6-input.txt"))))

(println "Problem 2: "
  (problem-2 (string/split-lines (slurp "./resources/day6-input.txt"))))
