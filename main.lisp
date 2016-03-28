(eval-when (:compile-toplevel :load-toplevel :execute)
	(ql:quickload :ltk)
	(ql:quickload :chirp)
	(defpackage :ltk-user
		(:use :common-lisp :ltk ))
	(in-package :ltk-user)
)
(defun chirp-init ()
	(let ((keys (with-open-file (in ".twitter-oauth.lisp")
        		(read in))))
    	(setq 	chirp-extra:*oauth-api-key*
          	  	(second (assoc 'consumer-key keys))
	          	chirp-extra:*oauth-api-secret*
	        	(second (assoc 'consumer-secret keys))
	          	chirp-extra:*oauth-access-secret*
	          	(second (assoc 'access-secret keys))
	          	chirp-extra:*oauth-access-token*
	          	(second (assoc 'access-key keys))))
	(chirp:account/verify-credentials))

(defun tweetwindow ()
	(let ((top (make-instance 'toplevel :master nil)))
		(let ((entry (make-instance 'entry
									:master top))
			(tbut (make-instance 'button
								:master top
								:width 20
								:text "tweet")))
		(pack entry)
		(pack tbut)
		(format-wish "wm attribute . -topmost 1")
		(setf (command tbut) (lambda ()
									(chirp:statuses/update (text entry))
									(destroy top))))))

(with-ltk ()
	(wm-title *tk* "LTk-Twitterclient")
	(set-geometry-wh *tk* 300 800)
	(let ((but (make-instance 'button
								:master nil
								:width 20
								:text "tweet"
								:command (lambda () (tweetwindow))))
		(scroll (make-instance 'scrolled-frame)))
		(pack but)
		(pack scroll)
		;(format-wish "wm attribute . -topmost 1")
))

(chirp-init)
