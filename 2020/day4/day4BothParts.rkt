#lang racket

(define required (list "ecl:" "pid:" "eyr:" "hcl:" "byr:" "iyr:" "hgt:"))

(define passports
  (let recur ([lines (port->lines (open-input-file "input.txt") #:close? #t)]
              [result (list)]
              [sublist (list)])
    (if (null? lines) (reverse (cons (string-join sublist) result))
      (if (equal? (car lines) "") 
        (recur (cdr lines) (cons (string-join sublist) result) (list))
        (recur (cdr lines) result (cons (car lines) sublist))))))

(printf "Part 1: ~a~%" 
  (count (λ (passport)
    (andmap (λ (req-str) (string-contains? passport req-str)) required)) 
    passports))

(printf "Part 2: ~a~%" (count (λ (passport)
  (and 
    (let ([m (regexp-match #px"\\bbyr:(\\d{4})\\b" passport)])
      (and m (<= 1920 (string->number (second m)) 2002)))
    (let ([m (regexp-match #px"\\biyr:(\\d{4})\\b" passport)])
      (and m (<= 2010 (string->number (second m)) 2020)))
    (let ([m (regexp-match #px"\\beyr:(\\d{4})\\b" passport)])
      (and m (<= 2020 (string->number (second m)) 2030)))
    (or
      (let ([m (regexp-match #px"\\bhgt:(\\d{3})cm\\b" passport)])
        (and m (<= 150 (string->number (second m)) 193)))
      (let ([m (regexp-match #px"\\bhgt:(\\d{2})in\\b" passport)])
        (and m (<= 59 (string->number (second m)) 76))))
    (regexp-match #px"\\bhcl:#[0-9a-f]{6}\\b" passport)
    (regexp-match #px"\\becl:(amb|blu|brn|gry|grn|hzl|oth)\\b" passport)
    (regexp-match #px"\\bpid:\\d{9}\\b" passport)))
  passports))