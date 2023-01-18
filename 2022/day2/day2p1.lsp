
(require "asdf")

(defun read-line-or-nil (input) ;; supports Windows CRLF format 
    (let ((rawline (read-line input nil nil)))
        (if rawline (string-right-trim #.(string #\return) rawline) nil)))

(let* 
    ((decrypter '(A :rock B :paper C :scissors X :rock Y :paper Z :scissors))
     (point-mapping '(:rock 1 :paper 2 :scissors 3 :win 6 :draw 3))
     (winner-mapping '(:rock :scissors :paper :rock :scissors :paper))
     (rounds (loop with input = (open "input.txt")
        for line = (read-line-or-nil input) while line
        for strings = (uiop:split-string line)
        collect (loop for str in strings collect (getf decrypter (read-from-string str))))))

    (princ (loop for (opponent me) in rounds
        sum (getf point-mapping me)
        sum (cond 
                ((equal me opponent) (getf point-mapping :draw))
                ((equal (getf winner-mapping me) opponent) (getf point-mapping :win))
                (t 0)))))