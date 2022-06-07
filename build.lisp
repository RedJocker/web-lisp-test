; -*- coding: utf-8; mode: Lisp; fill-column: 76; tab-width: 4; -*-
; Brief: Build system.

(in-package :cl-user)

(print "build.lisp")
(log-title "Building the system ...")
(ql:quickload :usocket)
(ql:quickload :hunchentoot)
(ql:quickload :cl-who)
(ql:quickload :drakma)
(log-footer "finish build.lisp")
