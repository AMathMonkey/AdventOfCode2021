(require "asdf")

(defparameter elves
    (loop for remaining-lines on (uiop:read-file-lines "input.txt")
        collect (loop for line = (car remaining-lines)
            until (or (null line) (equal line ""))
            sum (parse-integer line)
            do (setf remaining-lines (cdr remaining-lines)))))

(format t "Part 1: ~a~%Part 2: ~a~%"
    (apply 'max elves)
    (apply '+ (subseq (sort elves '>) 0 3)))