(require "asdf")

(defparameter ranges (loop for line in (uiop:read-file-lines "input.txt")
    collect (mapcar 'parse-integer (uiop:split-string line :separator ",-"))))

(format t "Part 1: ~a~%Part 2: ~a~%"
    (loop for (start1 end1 start2 end2) in ranges
        count (or
            (and (>= start1 start2) (<= end1 end2))
            (and (>= start2 start1) (<= end2 end1))))
    (loop for (start1 end1 start2 end2) in ranges
        count (or
            (<= start2 start1 end2) (<= start2 end1 end2)
            (<= start1 start2 end1) (<= start1 end2 end1))))