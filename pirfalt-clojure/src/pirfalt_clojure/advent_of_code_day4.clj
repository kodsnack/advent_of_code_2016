(ns pirfalt-clojure.advent_of_code-day4
  (:require [clojure.string :as str]
            [clojure.pprint :refer [pprint]]
            [clojure.test :as t]
            [clojure.repl :refer [doc]]))


(defn add-to-charmap [charmap char]
  (assoc charmap char (inc (or (charmap char) 0))))

(defn partition-count [str]
  (dissoc (reduce add-to-charmap {} str) \-))

(defn alt-partition-count [str]
  ; (map (juxt first count) (partition-by identity (sort str))))
  (->> str
    (sort)
    (filter (partial not= \-))
    (partition-by identity)
    (map (juxt first count))))

(defn calc-hash [str]
  (->> (partition-count str)
    (seq)
    (sort-by first)
    (sort-by second >)
    (map first)
    (take 5)
    (str/join)))


(defn problem-1 [input]
  (transduce
    (comp
      (map #(re-matches #"(.+)-(\d+)\[(\w{5})\]$" %))
      (map (fn [[_ src roomnumber hash]]
            [src (Integer/parseInt roomnumber) hash (calc-hash src)]))
      (filter (fn [[_ _ hash real-hash]]
                (= hash real-hash)))
      (map second))
    (completing +)
    (str/split-lines input)))


(defn char-shift [len c]
  (case c
    \- \space
    (let [alpha-len 26
          a (int \a)
          shifted (+ (int c) len)
          target (+ a (mod (- shifted a) alpha-len))]
      (char target))))

(defn char-shift-string [len str] (str/join (map (partial char-shift len) str)))


(defn problem-2 [input]
  (sort
    (transduce
      (comp
        (map #(re-matches #"(.+)-(\d+)\[(\w{5})\]$" %))
        (map (fn [[_ src roomnumber hash]]
              [src (Integer/parseInt roomnumber) hash (calc-hash src)]))
        (filter (fn [[_ _ hash real-hash]]
                  (= hash real-hash)))
        (map (fn [[src id _]]
              [(char-shift-string id src) id])))
      conj
      []
      (str/split-lines input))))



; TESTS

(t/deftest day4
  (t/testing "Problem 1"
    (let [input "aaaaa-bbb-z-y-x-123[abxyz]
a-b-c-d-e-f-g-h-987[abcde]
not-a-real-room-404[oarel]
totally-real-room-200[decoy]"]
      (t/is (= 1514 (problem-1 input)))))


  (t/testing "Problem 2"
    (t/testing "char-shift"
      (t/is (= (char-shift 1 \a) \b))
      (t/is (= (char-shift 2 \a) \c))
      (t/is (= (char-shift 25 \a) \z))

      (t/is (= (char-shift 26 \a) \a))
      (t/is (= (char-shift 1 \z) \a))

      (t/is (= (char-shift 1 \-) \space))
      (t/is (= (char-shift 25 \-) \space)))))



(defn main- []
  (let [input (slurp "./resources/day4-input.txt")]
    (println "Problem 1: " (problem-1 input))
    (print "Problem 2: ") (pprint (problem-2 input))))

(main-)
