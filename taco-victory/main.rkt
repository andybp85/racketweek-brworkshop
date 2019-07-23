#lang br/quicklang
;(require brag/support) ; imports `lexer`
(require brag/support "grammar.rkt")
(provide taco-program taco-leaf
         taco not-a-taco
         show
         #%module-begin)

(module+ reader
  (provide read-syntax))

(define lex
  (lexer
   ["#$" lexeme]
   ["%" lexeme]
   [any-char (lex input-port)]
   ))

(define (tokenize ip)
  (lex ip))

(define (taco-program . pieces)
  (map integer->char pieces))

(define (taco-leaf . pieces)
  (string->number
   (foldr
    (λ (a c) (string-append c (number->string a)))
    ""
    pieces)
   2))

(define (taco) 1)

(define (not-a-taco) 0)

(define (show pt)
  (display (apply string pt)))

(define (read-syntax src ip)
  (define token-thunk (λ () (tokenize ip)))
  (define parse-tree (parse src token-thunk))
  (println parse-tree)
  (strip-bindings
   (with-syntax ([PT parse-tree])
     #'(module winner taco-victory
         (show PT)))))