(require "asdf")

(defun score (letter)
    (- (char-code letter) (if (upper-case-p letter) 38 96)))

(defparameter lines (uiop:read-file-lines "input.txt"))

(format t "Part 1: ~a~%Part 2: ~a~%"
    (loop for line in lines
        for chars = (coerce line 'list)
        for halfway = (floor (length chars) 2)
        sum (score (car (nintersection (subseq chars 0 halfway) (subseq chars halfway)))))
    (loop for remaining-lines on lines by 'cdddr
        for three-charlists = (loop for l in (subseq remaining-lines 0 3) collect (coerce l 'list))
        sum (score (car (reduce 'nintersection three-charlists)))))
