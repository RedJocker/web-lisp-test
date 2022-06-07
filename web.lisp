;;; load library for rest
;(ql:quickload "hunchentoot")

;; load libray for creating http
;(ql:quickload :cl-who)

;; load libary -  https://parenscript.common-lisp.dev/
;(ql:quickload :parenscript)

;;load library for files  - https://edicl.github.io/cl-fad/
;(ql:quickload  :cl-fad)

;; load all above libraries at once
(mapc #'ql:quickload '(:cl-fad :cl-who :hunchentoot :parenscript))

(defpackage :web-test
  (:use :cl :cl-who :hunchentoot :parenscript)
  (:export standard-page))

(defvar *port* (parse-integer (asdf::getenv "PORT")))

;;; start web service at "http://127.0.0.1:4242/"
(defvar server (make-instance 'hunchentoot:easy-acceptor :port *port*))
(hunchentoot:start server)
;; stop web service
;(hunchentoot:stop server)

;;;  see what happens at "http://127.0.0.1:4242/yo" or "http://127.0.0.1:4242/yo?name=Dude" 
(hunchentoot:define-easy-handler (say-yo :uri "/yo") (name)
  (setf (hunchentoot:content-type*) "text/plain")
  (format nil "Hey~@[ ~A~]!" name))


;;; example using cl-who to produce html
(cl-who:with-html-output (*standard-output* nil :indent t)
  (:html
   (:head
    (:title "Test page"))
   (:body
    (:p "CL-WHO is really easy to use"))))

;; macro to define endpoints
(defmacro define-url-fn ((name) &body body)
	 `(progn
	    (defun ,name ()
	      ,@body)
	    (push
             (hunchentoot:create-prefix-dispatcher
              ,(format nil "/~(~a~).htm" name)
              ',name) hunchentoot:*dispatch-table*)))

;; macro to create templated html - customize it to your needs 
(defmacro standard-page ((&key title) &body body)
	 `(cl-who:with-html-output-to-string (*standard-output* nil :prologue t :indent t)
	   (:html :xmlns "http://www.w3.org/1999/xhtml"
		  :xml\:lang "en" 
		  :lang "en"
		  (:head 
		   (:meta :http-equiv "Content-Type" 
			  :content    "text/html;charset=utf-8")
		   (:title ,title)
		   (:link :type "text/css" 
			  :rel "stylesheet"
			  :href "/retro.css"))
		  (:body 
		   (:div :id "header" ; Retro games header
			 (:img :src "/logo.jpg" 
			       :alt "Commodore 64" 
			       :class "logo")
			 (:span :class "strapline" 
				"Vote on your favourite Retro Game"))
		   ,@body))))


 (define-url-fn (retro-games)
	 (standard-page (:title "Retro Games")
			(:h1 "Top Retro Games")
			(:p "We'll write the code later...")))

(define-url-fn (my-page)
  (standard-page (:title "My Page")
    (:h1 "This is my page")
    (:p "here is some paragraph")
    (:ul (:li "hey")
         (:li "you"))))




