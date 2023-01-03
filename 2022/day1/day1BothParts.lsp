(defun read-line-or-nil (input) ;; supports Windows CRLF format 
    (let ((rawline (read-line input nil nil)))
        (if rawline (string-right-trim (string #\return) rawline) nil)))

(defparameter elves
    (loop with input = (open "input.txt")
        and elves = '()
        and current-elf = '()
        for line = (read-line-or-nil input)
        while line
        if (string= line "") do (progn (push current-elf elves) (setf current-elf '()))
        else do (push (parse-integer line) current-elf)
        finally (return (push current-elf elves))))

(format t "Part 1: ~a~%" (loop for elf in elves maximize (apply '+ elf)))
(format t "Part 2: ~a~%" (apply '+ (subseq (sort (loop for elf in elves collect (apply '+ elf)) '>) 0 3)))