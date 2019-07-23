#lang br/quicklang

(module+ reader
  (provide read-syntax))

(define (tokenize ip)
  (for/list ([tok (in-port read-char ip)])
    tok))

(define (tok->taco bin)
  (map
   (λ (b)
     (if (equal? b #\1)
         "taco"
         null))
   (string->list 
    (format "~b" (char->integer bin)))))

(define (parse src toks)
  (map tok->taco #R toks))

(define (read-syntax src ip)
  (define toks (tokenize ip))
  (define parse-tree (parse src toks))
  (strip-bindings
   (with-syntax ([PT parse-tree])
     #'(module tacofied taco-compiler
         PT))))

(define-macro (mb PT)
  #'(#%module-begin
     (for-each displayln 'PT)))
(provide (rename-out [mb #%module-begin]))