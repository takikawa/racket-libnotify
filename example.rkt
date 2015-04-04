#lang racket

(require "notify.rkt"
         pict)

(define note
  (new notification%
       [message "Hello World!"]
       [body "This is a test message"]
       [icon (pict->bitmap (colorize (disk 40) "white"))]))

(send note show)
(sleep 2)
(send note close)
