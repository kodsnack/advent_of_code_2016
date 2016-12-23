(ns pirfalt-clojure.advent_of_code-day5
  (:require [clojure.string :as string]))

(defn md5-old [in]
  (let [md (java.security.MessageDigest/getInstance "MD5")
        _ (.reset md)
        raw (BigInteger. 1 (.digest md (.getBytes in)))
        string (.toString raw 16)
        padding (apply str (repeat (- 32 (count string)) "0"))]
    (str padding string)))

(defn md5 [in]
  (javax.xml.bind.DatatypeConverter/printHexBinary
    (.digest
      (java.security.MessageDigest/getInstance "MD5")
      (.getBytes in))))

(defn starts-with-00000 [s] (string/starts-with? s "00000"))





(defn brute [prefix len]
  (take len
    (for [i (range)
          :let [test (md5 (str prefix i))]
          :when (starts-with-00000 test)]
      [(str prefix i) test])))


(time (println "Problem 1: "
        (->> (brute "ojvtpuvg" 8)
          (map (fn [[_ hash]] (nth hash 5)))
          (apply str)
          (clojure.string/lower-case))))





(defn brute [prefix]
  (->> (for [i (range)
              :let [test (md5 (str prefix i))]
              :when (starts-with-00000 test)]
        [(str prefix i) test])

    (map (fn [[in hash]]
          (let [i (- (int (nth hash 5)) 0x30)
                v (nth hash 6)]
            [i v])))

    (reduce (fn [to [i v]]
              (cond
                (not-any? nil? to)    (reduced to)
                (<= (count to) i)   to
                (not= nil (nth to i)) to
                :else                 (assoc to i v)))
            (vec (map (constantly nil) (range 8))))))


(time (println "Problem 2: "
        (->> (brute "ojvtpuvg")
          (apply str)
          (clojure.string/lower-case))))
