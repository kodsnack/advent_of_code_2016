(ns pirfalt.advent_of_code-day3
  (:require [clojure.string :as string]))


; Problem 1

(def input (slurp "./resources/day3-input.txt"))

(defn parse-int [str] (Integer/parseInt str))

(defn triangle? [[a b c]]
    (not (or (>= a (+ b c))
             (>= b (+ a c))
             (>= c (+ a b)))))

(defn problem-1 [input]
  (->> input
    (re-seq #"([ \d]{5})([ \d]{5})([ \d]{5})\n")
    (map (fn [[_ a b c]]
          (map (comp parse-int string/trim) [a b c])))
    (filter triangle?)
    count))

(println "Problem 1: " (problem-1 input))


; Problem 2

(defn swap-col-row [[[a b c] [d e f] [g h i]]]
    [[a d g] [b e h] [c f i]])

(defn problem-2 [input]
  (->> input
    (re-seq #"([ \d]{5})([ \d]{5})([ \d]{5})\n")
    (map (fn [[_ a b c]]
          (map (comp parse-int string/trim) [a b c])))
    (partition 3)
    (mapcat swap-col-row)
    (filter triangle?)
    (count)))

(print "Problem 2: " (problem-2 input))
