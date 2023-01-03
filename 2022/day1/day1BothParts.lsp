(defun read-line-or-nil (input) ;; supports Windows CRLF format 
    (let ((rawline (read-line input nil nil)))
        (if rawline (string-right-trim (string #\return) rawline) nil)))

(defparameter elves
    (loop with input = (open "input.txt")
        for elf = (loop for line = (read-line-or-nil input)
                    until (or (null line) (string= line ""))
                    collect (parse-integer line))
        while elf collect elf))

(format t "Part 1: ~a
Part 2: ~a~%"
    (loop for elf in elves maximize (apply '+ elf))
    (apply '+ (subseq (sort (loop for elf in elves collect (apply '+ elf)) '>) 0 3)))