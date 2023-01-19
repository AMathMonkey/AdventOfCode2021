(require "asdf")

(defun plist-key-for-value (plist value)
    (loop for (k v) on plist by 'cddr
        if (eql v value) return k))

(let* 
    ((decrypter '(A :rock B :paper C :scissors X :lose Y :draw Z :win))
     (point-mapping '(:rock 1 :paper 2 :scissors 3 :win 6 :draw 3 :lose 0))
     (winner-mapping '(:rock :scissors :paper :rock :scissors :paper))
     (rounds (loop for line in (uiop:read-file-lines "input.txt")
        for strings = (uiop:split-string line)
        collect (loop for str in strings collect (getf decrypter (read-from-string str))))))

    (princ (loop for (opponent outcome) in rounds 
        for me = (case outcome 
            (:win (plist-key-for-value winner-mapping opponent))
            (:lose (getf winner-mapping opponent))
            (:draw opponent))
        sum (getf point-mapping me) 
        sum (getf point-mapping outcome))))