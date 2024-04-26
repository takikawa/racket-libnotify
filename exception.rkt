#lang racket/base
(provide (struct-out exn:fail:libnotify) raise-libnotify-error)

(struct exn:fail:libnotify exn:fail ())
(define (raise-libnotify-error msg)
  (raise (exn:fail:libnotify msg (current-continuation-marks))))
