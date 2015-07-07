;;;; laptop-lid.lisp

(in-package #:power)

(defparameter *lid-state-path* "/proc/acpi/button/lid/LID/state")
(defparameter *lid-state-open-pattern* "state:\\s+open")
(defparameter *lid-state-closed-pattern* "state:\\s+closed")
(defparameter *laptop-lid-watcher* nil)
(defparameter *laptop-lid-watcher-interval* 5)
(defparameter *upower-conn* nil)
(defparameter *upower-service* "org.freedesktop.UPower")

(defun upower-method (cmd)
  (progn
    (when (not *upower-conn*) (setf *upower-conn*
                 (open-connection
                  (make-instance 'iolib.multiplex:event-base) (system-server-addresses)))
          (authenticate (supported-authentication-mechanisms *upower-conn*) *upower-conn*)
          (hello *upower-conn*))
    
    (dbus:invoke-method *upower-conn*
                        cmd
                        :path "/org/freedesktop/UPower"
                        :interface "org.freedesktop.UPower"
                        :destination *upower-service*
                        :signature ())
    )
  )

(defun do-suspend () (upower-method "Suspend"))

(defun do-hibernate () (upower-method "Hibernate"))

(defun do-about-to-sleep () (upower-method "AboutToSleep"))

(defun laptop-lid-watcher (scanner)
  (with-open-file (f *lid-state-path*)
    (let* ((l (read-line f)) (r (cl-ppcre:scan scanner l)))
      (when r
        ;(about-to-sleep)
        (do-suspend)))
    )
  )

(defun start-laptop-lid-watcher ()
  (let ((scanner (cl-ppcre:create-scanner *lid-state-closed-pattern*)))
    (setf *laptop-lid-watcher*
          (stumpwm:run-with-timer 1 *laptop-lid-watcher-interval* #'laptop-lid-watcher scanner))
    ))

(defun stop-laptop-lid-watcher ()
  (when *laptop-lid-watcher* (stumpwm:cancel-timer *laptop-lid-watcher*)))

(defcommand suspend () ()
  "Suspend computer"
  (power:do-suspend))

(defcommand hibernate () ()
  "Suspend computer"
  (power:do-hibernate))
