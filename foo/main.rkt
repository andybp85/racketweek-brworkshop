#lang br/quicklang
(provide (rename-out [mb #%module-begin]))

(define-macro (mb . _)
  #'(#%module-begin (displayln "You did it")))

(module reader syntax/module-reader
  foo)

