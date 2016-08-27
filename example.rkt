#lang racket

(require "libnotify.rkt"
         pict)

(define note
  (new notification%
       [summary "Hello World!"]
       [body "This is a <b>test</b> message"]
       [icon (pict->bitmap (colorize (disk 40) "white"))]
       [timeout 2]
       [urgency 'low]
       [category "presence"]))

(define racket-icon
  (new notification%
       [summary "Racket"]
       [icon (collection-file-path "plt-32x32.png" "icons")]
       [urgency 'critical]))

(send note show)
(send racket-icon show)
