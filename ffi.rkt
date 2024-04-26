#lang racket/base

(require ffi/unsafe
         ffi/unsafe/define
         "exception.rkt")

(provide notification-new
         notification-update
         notification-show
         notification-set-app-name
         notification-set-timeout
         notification-set-category
         notification-set-urgency
         notification-set-image-from-pixbuf
         notification-clear-hints
         notification-close
         notify-init
         notify-uninit
         notify-get-app-name
         notify-set-app-name
         gdk-cairo-surface->pixbuf)

(define-ffi-definer define-notify (ffi-lib "libnotify" '("4" "")))

;; The pixbuf function we need below is only in Gdk 3
(define-ffi-definer define-gdk (ffi-lib "libgdk-3" '("0" "")))

;; g_error_free is loaded from libglib-2.0
(define-ffi-definer define-glib (ffi-lib "libglib-2.0"))

(define (handle-error ret err)
  (or ret
      (let* ((error-cstruct (ptr-ref err _GError))
             (message (GError-message error-cstruct)))
        (free-GError error-cstruct)
        (raise-libnotify-error message))))

(define-gdk gdk-cairo-surface->pixbuf
            (_fun _pointer _int _int _int _int -> _pointer)
            #:c-id gdk_pixbuf_get_from_surface)

(define-cpointer-type _NotifyNotification)

(define-cstruct _GError
  ([domain _uint32]
   [code _int]
   [message _string]))

(define-glib free-GError (_fun _GError -> _void) #:c-id g_error_free)

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
                     (err : (_ptr i _GError-pointer/null) = #f)
                     -> (ret : _bool)
                     -> (handle-error ret err))
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

(define-notify notification-set-image-from-pixbuf
               (_fun _NotifyNotification _pointer -> _void)
               #:c-id notify_notification_set_image_from_pixbuf)

(define-notify notification-clear-hints
               (_fun _NotifyNotification -> _void)
               #:c-id notify_notification_clear_hints)

(define-notify notification-close
               (_fun _NotifyNotification
                     (err : (_ptr i _GError-pointer/null) = #f)
                     -> (ret : _bool)
                     -> (handle-error ret err))
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
