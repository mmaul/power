;;;; power.asd

(asdf:defsystem #:power
  :description "power"
  :author "Mike Maul <mike.maul@gmail.com>"
  :license "BSD"
  :depends-on (#:stumpwm #:cl-ppcre #:dbus)
  :serial t
  :components ((:file "package")
               (:file "power")))

