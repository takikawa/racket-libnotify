#lang racket/base

(require "ffi.rkt")

(notify-init "test")

(define notification (notification-new "foo" "bar" ""))

(notification-show notification)

(sleep 3)

(notification-close notification)
