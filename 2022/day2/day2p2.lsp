(require "asdf")

(defun read-line-or-nil (input) ;; supports Windows CRLF format 
    (let ((rawline (read-line input nil nil)))
        (if rawline (string-right-trim #.(string #\return) rawline) nil)))

(defun plist-key-for-value (plist value)
    (loop for cell = plist then (cddr cell) while cell
        if (eql (cadr cell) value) return (car cell)
        finally (return nil)))

(let* 
    ((decrypter '(A rock B paper C scissors X lose Y draw Z win))
     (point-mapping '(rock 1 paper 2 scissors 3 win 6 draw 3 lose 0))
     (winner-mapping '(rock scissors paper rock scissors paper))
     (rounds (loop with input = (open "input.txt")
        for line = (read-line-or-nil input) while line
        for strings = (uiop:split-string line)
        collect (loop for str in strings collect (getf decrypter (read-from-string str))))))

    (princ (loop for (opponent outcome) in rounds 
        for me = (case outcome 
            ('win (plist-key-for-value winner-mapping opponent))
            ('lose (getf winner-mapping opponent))
            ('draw opponent))
        summing (+ (getf point-mapping me) (getf point-mapping outcome)))))