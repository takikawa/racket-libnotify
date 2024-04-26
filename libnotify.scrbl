#lang scribble/manual

@title{libnotify: an FFI binding for libnotify}

@(require (for-label racket/base
                     racket/class
                     racket/draw
                     libnotify))

@defmodule[libnotify]

This library provides an FFI binding to the
@hyperlink["https://developer.gnome.org/libnotify/" "libnotify"]
library which provides support for the desktop notifications API.

@defclass[notification% object% ()]{
  @defconstructor[([summary string?]
                   [body (or/c string? #f) #f]
                   [icon (or/c (is-a?/c bitmap%) path-string? #f) #f]
                   [timeout (or/c (>=/c 0) #f) #f]
                   [urgency (or/c 'low 'normal 'critical) 'normal]
                   [category (or/c string? #f) #f])]{
    Constructs a new notification object.

    The @racket[summary], @racket[body], and @racket[icon] describe the
    content of the notification when displayed. If @racket[icon] describes a
    file system path, an icon will be loaded from that path. If it is a
    @racket[bitmap%] object, it will be rendered directly.

    The @racket[timeout] argument specifies a timeout in seconds. Note that
    if the Racket process exits before the timeout triggers, it will have no
    effect and the timeout will be ignored.

    See the @hyperlink["https://developer.gnome.org/notification-spec/" "Desktop Notification"]
    specification for details on the meaning and recommended use of the @racket[urgency] and
    @racket[category] arguments.
  }

  @defmethod[(show) void?]{
    Displays the notification on the screen.

    If the display fails, then an instance of @racket[exn:fail:libnotify]
    is raised.
  }

  @defmethod[(close) void?]{
    Closes the notification and removes it from the screen.

    If the close operation fails, then an instance of
    @racket[exn:fail:libnotify] is raised.
  }
}

@defstruct[(exn:fail:libnotify exn:fail) ()]{
  An exception structure type for reporting errors from the underlying
  libnotify library.
}

@defproc[(init-libnotify (name string? "Racket")) any]{
  Initializes the library and registers the uninitialization procedure
  as a @tech[#:doc '(lib "scribblings/reference/reference.scrbl")]{flush callback}
  in @racket[(current-plumber)].
}
