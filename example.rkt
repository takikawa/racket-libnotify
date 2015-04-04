#lang racket

(require "notify.rkt"
         pict)

(define note
  (new notification%
       [summary "Hello World!"]
       [body "This is a <b>test</b> message"]
       [icon (pict->bitmap (colorize (disk 40) "white"))]
       [timeout 2]
       [urgency 'critical]
       [category "presence"]))

(send note show)
