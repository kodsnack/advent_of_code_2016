(ns pirfalt-clojure.advent_of_code-day4-test
  (:require [clojure.test :refer :all]
            [pirfalt-clojure.advent_of_code-day4 :refer :all]))


(deftest problem-1-test
  (let [input "aaaaa-bbb-z-y-x-123[abxyz]
a-b-c-d-e-f-g-h-987[abcde]
not-a-real-room-404[oarel]
totally-real-room-200[decoy]"
        result 1514]

    (testing "Problem 1"
      (is (= result (problem-1 input))))))
