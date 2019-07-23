#lang br/quicklang
(require brag/support "grammer.rkt")
(provide top fun expr app)

(module+ reader
  (provide read-syntax))

(define-lex-abbrev reserved-toks
  (:or "fun" "(" "," ")" "=" "+")) ; TODO: fix

(define-lex-abbrev digits
  (:+ (char-set "0123456789")))

(define tokenize
  (lexer
   [whitespace (token 'SP lexeme #:skip? #t)]
   [(from/stop-before "#" "\n")
    (token 'COMMENT lexeme #:skip? #t)]
   [reserved-toks lexeme]
   [(:+ alphabetic) (token 'ID (string->symbol lexeme))]
   [digits (token 'INT (string->number lexeme))]))

(define-macro top #'#%module-begin)

(define-macro-cases fun
  [(_ NAME ARG EXPR) #'(define (NAME ARG) EXPR)]
  [(_ NAME ARG ARG1 EXPR) #'(define (NAME ARG ARG1) EXPR)])

(define-macro-cases expr
  [(_ ARG ARG1) #'(+ ARG ARG1)]
  [(_ APP) #'APP])

(define-macro app #'#%app)

;(define-macro-cases app
;  [(_ NAME ARG) #'(NAME ARG)]
;  [(_ NAME ARG ARG1) #'(NAME ARG ARG1)])

(define (read-syntax src ip)
  (define parse-tree (parse src (λ () (tokenize ip))))
  (strip-bindings
   (with-syntax ([PT parse-tree])
     #'(module algebra-mod algebra
         PT))))
