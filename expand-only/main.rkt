#lang br

(define-macro (my-module-begin EXPR ...)
  #'(#%module-begin
     (convert-expr 'EXPR) ...))
(provide (rename-out [my-module-begin #%module-begin]))

(define (convert-expr exp)
  (cond
    [(string? exp) "whee"]
    [(number? exp) 42]
    [(equal? null exp) null]
    [(list? exp) (cons (convert-expr (car exp)) (convert-expr (cdr exp)))]
    [else "kaboom"]))