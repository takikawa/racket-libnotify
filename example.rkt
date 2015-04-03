#lang racket

(require "notify.rkt"
         pict)

(define note
  (new notification%
       [message "Hello World!"]
       [icon (pict->bitmap (disk 40))]))

(send note show)
