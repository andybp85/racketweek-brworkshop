#lang br/quicklang
(require brag/support "grammer.rkt")
(provide top)

(module+ reader
  (provide read-syntax))

(define-lex-abbrev reserved-toks
  (:or "(" "," ")" "=" ";"))

(define-lex-abbrev digit
  (:+ (char-set "0123456789")))

(define tokenize
  (lexer-srcloc
   [whitespace (token 'SP lexeme #:skip? #t)]
   [(:or (from/stop-before "//" "\n")
         (from/to "/*" "*/"))
    (token 'COMMENT lexeme #:skip? #t)]
   [reserved-toks lexeme]
   [(:+ alphabetic) (token 'ID (string->symbol lexeme))]
   [(:seq (:? "-") digit) (token 'INT (string->number lexeme))]))

(define-macro top #'#%module-begin)

(define (read-syntax src ip)
  (port-count-lines! ip) ; this turns on line counting for the input port
  (lexer-file-path ip) ; this tells the lexer the file path
  (define parse-tree (parse src (λ () (tokenize ip))))
  (println parse-tree)
  (strip-bindings
   (with-syntax ([PT parse-tree])
     #'(module scriptish-mod scriptish
         PT))))
