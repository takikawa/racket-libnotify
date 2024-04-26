#lang info
(define collection "libnotify")

(define deps '("base" "draw-lib"))
(define build-deps '("scribble-lib" "racket-doc" "draw-doc"))

(define scribblings '(("libnotify.scrbl" () (gui-library))))

(define compile-omit-paths '("example.rkt"))
