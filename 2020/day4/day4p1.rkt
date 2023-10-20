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

(writeln (count (λ (thing) (andmap (λ (s) (string-contains? thing s)) required)) passports))
