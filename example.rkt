#lang racket

(require "notify.rkt"
         pict)

(define note
  (new notification%
       [summary "Hello World!"]
       [body "This is a test message"]
       [icon (pict->bitmap (colorize (disk 40) "white"))]
       [timeout 2]))

(send note show)
