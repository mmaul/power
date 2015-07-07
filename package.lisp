;;;; package.lisp

(defpackage #:power
  (:use #:cl #:dbus #:stumpwm)
  (:shadowing-import-from :dbus :message)
  (:export #:start-laptop-lid-watcher #:stop-laptop-lid-watcher #:*lid-state-path* #:*lid-state-open-pattern* #:*lid-state-closed-pattern* #:*laptop-lid-watcher-interval* #:do-suspend #:do-hibernate)
  )

