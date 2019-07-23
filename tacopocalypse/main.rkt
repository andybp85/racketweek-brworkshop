#lang br/quicklang
(require brag/support) ; imports `lexer`

(module+ reader
  (provide read-syntax))

(define lex (lexer
             ["#$" 0]
             ["%" 1]
             ["$#" ","]
             [any-char (lex input-port)]))

(define (tokenize ip)
  (for/list ([tok (in-port lex ip)])
    tok))

(define (parse src toks)
  (foldl
   (λ (t)
     (if (equal? #R t )
         0
         1))
   ""
   #R toks)
  )

(define (read-syntax src ip)
  (define toks (tokenize ip))
  (define parse-tree (parse src toks))
  (strip-bindings
   (with-syntax ([PT parse-tree])
     #'(module taco-mod tacopocalypse
         PT))))

(define-macro (my-module-begin PT)
  #'(#%module-begin
     (display (list->string 'PT))))
(provide (rename-out [my-module-begin #%module-begin]))