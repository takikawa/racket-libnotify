#lang info

(define deps '("base" "draw-lib"))
(define build-deps '("scribble-lib" "racket-doc" "draw-doc"))

(define scribblings '(("notify.scrbl")))

(define compile-omit-paths '("example.rkt"))
