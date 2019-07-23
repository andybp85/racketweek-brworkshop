#lang br
(module reader br
  (provide read-syntax)
  (define (read-syntax name port)
    (define s-exprs port->list)
    (strip-bindings
     (with-syntax ([(EXPR ...) s-exprs])
       #'(module dsl-mod-name conjuction 
           EXPR ...)))))

;(define-macro (my-module-begin EXPR ...)
;  #'(#%module-begin
;     (convert-expr 'EXPR) ...))
;;(provide (rename-out [my-module-begin #%module-begin]))
;
;(define (convert-expr exp)
;  (cond
;    [(string? exp) "whee"]
;    [(number? exp) 42]
;    [(equal? null exp) null]
;    [(list? exp) (cons (convert-expr (car exp)) (convert-expr (cdr exp)))]
;    [else "kaboom"]))