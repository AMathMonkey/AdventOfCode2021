
(require "asdf")

(let* 
    ((decrypter '(A :rock B :paper C :scissors X :rock Y :paper Z :scissors))
     (point-mapping '(:rock 1 :paper 2 :scissors 3 :win 6 :draw 3))
     (winner-mapping '(:rock :scissors :paper :rock :scissors :paper))
     (rounds (loop for line in (uiop:read-file-lines "input.txt")
        for strings = (uiop:split-string line)
        collect (loop for str in strings collect (getf decrypter (read-from-string str))))))

    (princ (loop for (opponent me) in rounds
        sum (getf point-mapping me)
        sum (cond 
                ((equal me opponent) (getf point-mapping :draw))
                ((equal (getf winner-mapping me) opponent) (getf point-mapping :win))
                (t 0)))))