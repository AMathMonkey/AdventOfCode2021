#lang racket

;;; (define passports
;;;   (let recur ([lines (port->lines (open-input-file "input.txt") #:close? #t)]
;;;               [result (list)]
;;;               [sublist (list)])
;;;     (if (null? lines) (reverse (cons (string-join sublist) result))
;;;       (if (non-empty-string? (car lines))
;;;         (recur (cdr lines) result (cons (car lines) sublist))
;;;         (recur (cdr lines) (cons (string-join sublist) result) (list))))))

;;; Weird alternative using splitf-at instead of sublist building
(define passports
  (let recur ([lines (port->lines (open-input-file "input.txt") #:close? #t)]
              [result (list)])
    (let*-values ([(next-passport remaining-lines) (splitf-at lines non-empty-string?)]
                  [(remaining-lines) (dropf remaining-lines (negate non-empty-string?))]
                  [(result) (cons (string-join next-passport) result)])
      (if (null? remaining-lines) (reverse result)
        (recur remaining-lines result)))))


(printf "Part 1: ~a~%"
  (let ([required (list "ecl:" "pid:" "eyr:" "hcl:" "byr:" "iyr:" "hgt:")])
    (count
      (λ (passport) (andmap (λ (req-str) (string-contains? passport req-str)) required))
      passports)))


(printf "Part 2: ~a~%"
  (let ([capture-group-n-in-range (λ (regex string n low high)
          (let ([m (regexp-match regex string)])
            (and m (<= low (string->number (list-ref m n)) high))))])
    (count
      (λ (passport)
        (let ([match-in-range (λ (regex low high)
                (capture-group-n-in-range regex passport 1 low high))])
          (and
            (match-in-range #px"\\bbyr:(\\d{4})\\b" 1920 2002)
            (match-in-range #px"\\biyr:(\\d{4})\\b" 2010 2020)
            (match-in-range #px"\\beyr:(\\d{4})\\b" 2020 2030)
            (or
              (match-in-range #px"\\bhgt:(\\d{3})cm\\b" 150 193)
              (match-in-range #px"\\bhgt:(\\d{2})in\\b" 59 76))
            (regexp-match #px"\\bhcl:#[0-9a-f]{6}\\b" passport)
            (regexp-match #px"\\becl:(amb|blu|brn|gry|grn|hzl|oth)\\b" passport)
            (regexp-match #px"\\bpid:\\d{9}\\b" passport))))
      passports)))