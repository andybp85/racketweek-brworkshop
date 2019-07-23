#lang br
(module reader br
  (provide read-syntax)
  (define (read-syntax name port)
    (define s-exprs port->list)
    (strip-bindings
     #`(module read-only br
         #,@s-exprs))))