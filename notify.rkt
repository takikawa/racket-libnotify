#lang racket/base

;; The high-level API for libnotify

(require "ffi.rkt"
         racket/class
         racket/contract
         racket/draw)

(provide (contract-out
          [notification%
           (class/c
            (init [message string?]
                  [body (or/c string? #f)]
                  [icon (or/c (is-a?/c bitmap%) #f)])
            [show (->m any)]
            [close (->m any)])])
         (struct-out exn:fail:libnotify))

(struct exn:fail:libnotify exn:fail ())

(define initialized? #f)

(define (raise-libnotify-error msg)
  (raise (exn:fail:libnotify msg (current-continuation-marks))))

(define notification%
  (class object%
    (super-new)
    (init message
          [body #f]
          [icon #f])

    ;; Initialize libnotify unless it already has been
    ;; unlikely to work if the module is instantiated multiple times
    (unless initialized?
      (notify-init "Racket"))

    ;; A handle on the C object
    (define handle (notification-new message body #f))

    ;; Handle a bitmap icon
    (when (is-a? icon bitmap%)
      (define pixbuf (gdk-cairo-surface->pixbuf (send icon get-handle)
                                                0 0
                                                (send icon get-width)
                                                (send icon get-height)))
      (notification-set-image-from-pixbuf handle pixbuf))

    (define/public (show)
      (define-values (ok? err)
        (notification-show handle))
      (unless ok?
        (raise-libnotify-error (GError-message err))))

    (define/public (close)
      (define-values (ok? err)
        (notification-close handle))
      (unless ok?
        (raise-libnotify-error (GError-message err))))))
