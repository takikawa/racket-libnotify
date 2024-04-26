#lang racket/base

;; The high-level API for libnotify

(require "ffi.rkt"
         racket/class
         racket/contract
         racket/draw)

(provide (contract-out
          [notification%
           (class/c
            (init [summary string?]
                  [body (or/c string? #f)]
                  [icon (or/c (is-a?/c bitmap%) path-string? #f)]
                  [timeout (or/c (>=/c 0) #f)]
                  [urgency (or/c 'low 'normal 'critical)]
                  [category (or/c string? #f)])
            [show (->m any)]
            [close (->m any)])]))

(define initialized? #f)

(define notification%
  (class object%
    (super-new)
    (init summary
          [body #f]
          [icon #f]
          [(_timeout timeout) #f]
          [urgency 'normal]
          [category #f])

    ;; Initialize libnotify unless it already has been
    ;; unlikely to work if the module is instantiated multiple times
    (unless initialized?
      (notify-init "Racket"))

    (define icon-path-arg
      (cond [(path? icon) (path->string icon)]
            [(string? icon) icon]
            [else #f]))

    ;; A handle on the C object
    (define handle (notification-new summary body icon-path-arg))
    (notification-set-urgency handle urgency)

    ;; Handle a bitmap icon
    (when (is-a? icon bitmap%)
      (define pixbuf (gdk-cairo-surface->pixbuf (send icon get-handle)
                                                0 0
                                                (send icon get-width)
                                                (send icon get-height)))
      (notification-set-image-from-pixbuf handle pixbuf))

    ;; Handle timeout in Racket-land because the libnotify timer doesn't
    ;; seem to do anything on some systems.
    (define timeout _timeout)
    (define timeout-thunk
      (λ () (sleep timeout) (close)))

    ;; See https://developer-old.gnome.org/notification-spec/ (Table 2)
    (when category
      (notification-set-category handle category))

    (define/public (show)
      (notification-show handle)
      (cond [timeout (thread timeout-thunk) (void)]))

    (define/public (close)
      (notification-close handle))))
