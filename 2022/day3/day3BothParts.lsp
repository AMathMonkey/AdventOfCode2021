(defun read-line-or-nil (input) ;; supports Windows CRLF format 
    (let ((rawline (read-line input nil nil)))
        (if rawline (string-right-trim #.(string #\return) rawline) nil)))

(defun score (letter) 
    (- (char-code letter) (if (upper-case-p letter) 38 96)))

(format t "Part 1: ~a~%Part 2: ~a~%" 
    (loop with input = (open "input.txt")
        for chars = (coerce (read-line-or-nil input) 'list) while chars
        for halfway = (floor (length chars) 2)
        sum (score (car (nintersection (subseq chars 0 halfway) (subseq chars halfway)))))
    (loop with input = (open "input.txt")
        for lines = (loop repeat 3
            for line = (coerce (read-line-or-nil input) 'list) while line
            collect line) while lines
        sum (score (car (reduce 'nintersection lines)))))
