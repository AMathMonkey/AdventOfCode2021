(require "asdf")

(defun read-line-or-nil (input) ;; supports Windows CRLF format 
    (let ((rawline (read-line input nil nil)))
        (if rawline (string-right-trim #.(string #\return) rawline) nil)))

(defparameter ranges (loop with input = (open "input.txt")
    for line = (read-line-or-nil input) while line
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