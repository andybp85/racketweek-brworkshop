#lang br/quicklang
(require brag/support "grammer.rkt")
(provide top fun add-or-sub mult-or-div app)

(module+ reader
  (provide read-syntax))

(define-lex-abbrev reserved-toks
  (:or "fun" "(" "," ")" "="))

(define-lex-abbrev digits
  (:+ (char-set "0123456789")))

(define tokenize
  (lexer
   [whitespace (token 'SP lexeme #:skip? #t)]
   [(:or (from/stop-before "#" "\n")
         (from/to "/*" "*/"))
    (token 'COMMENT lexeme #:skip? #t)]
   ["+" (token 'ADD lexeme)]
   ["-" (token 'MINUS lexeme)]
   ["*" (token 'TIMES lexeme)]
   ["/" (token 'DIV lexeme)]
   [reserved-toks lexeme]
   [(:+ alphabetic) (token 'ID (string->symbol lexeme))]
   [(:seq (:? "-") digits) (token 'INT (string->number lexeme))]))

(define-macro top #'#%module-begin)

(define-macro (fun NAME (ARG ...) EXPR)
  #'(define (NAME ARG ...) EXPR))

(define-macro-cases add-or-sub
  [(_ LEFT "+" RIGHT) #'(+ LEFT RIGHT)]
  [(_ LEFT "-" RIGHT) #'(- LEFT RIGHT)]
  [(_ APP) #'APP])

(define-macro-cases mult-or-div
  [(_ LEFT "*" RIGHT) #'(* LEFT RIGHT)]
  [(_ LEFT "/" RIGHT) #'(/ LEFT RIGHT)]
  [(_ APP) #'APP])

(define-macro app #'#%app)

(define (read-syntax src ip)
  (define parse-tree (parse src (λ () (tokenize ip))))
  (println parse-tree)
  (strip-bindings
   (with-syntax ([PT parse-tree])
     #'(module algebra-mod precalc
         PT))))
