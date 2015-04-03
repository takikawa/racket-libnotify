#lang racket/base

(require ffi/unsafe
         ffi/unsafe/define)

(provide notification-new
         notification-update
         notification-show
         notification-set-app-name
         notification-set-timeout
         notification-set-category
         notification-set-urgency
         notification-clear-hints
         notification-close
         notify-init
         notify-uninit
         notify-get-app-name
         notify-set-app-name)

(define-ffi-definer define-notify (ffi-lib "libnotify" '("4" "")))

(define-cpointer-type _NotifyNotification)

(define _NotifyUrgency
  (_enum '(low normal critical)))

(define-notify notification-new
               (_fun _string _string _string
                     -> _NotifyNotification)
               #:c-id notify_notification_new)

(define-notify notification-update
               (_fun _NotifyNotification _string _string _string
                     -> _bool)
               #:c-id notify_notification_update)

(define-notify notification-show
               (_fun _NotifyNotification
                     ;; FIXME: return the error somehow
                     (_pointer = #f)
                     -> _bool)
               #:c-id notify_notification_show)

(define-notify notification-set-app-name
               (_fun _NotifyNotification _string -> _void)
               #:c-id notify_notification_set_app_name)

(define-notify notification-set-timeout
               (_fun _NotifyNotification _int -> _void)
               #:c-id notify_notification_set_timeout)

(define-notify notification-set-category
               (_fun _NotifyNotification _string -> _void)
               #:c-id notify_notification_set_category)

(define-notify notification-set-urgency
               (_fun _NotifyNotification _NotifyUrgency -> _void)
               #:c-id notify_notification_set_urgency)

(define-notify notification-clear-hints
               (_fun _NotifyNotification -> _void)
               #:c-id notify_notification_clear_hints)

(define-notify notification-close
               (_fun _NotifyNotification
                     (x : _pointer = #f)
                     -> _bool)
               #:c-id notify_notification_close)

(define-notify notify-init
               (_fun _string -> _bool)
               #:c-id notify_init)

(define-notify notify-uninit
               (_fun -> _void)
               #:c-id notify_uninit)

(define-notify notify-get-app-name
               (_fun -> _string)
               #:c-id notify_get_app_name)

(define-notify notify-set-app-name
               (_fun _string -> _void)
               #:c-id notify_set_app_name)
