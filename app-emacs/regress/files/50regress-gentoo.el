
;;; regress site-lisp configuration

(add-to-list 'load-path "@SITELISP@")
(autoload 'regress-insert-suite "regress" nil t)
(autoload 'regress-insert-call "regress" nil t)
(autoload 'regress-forget "regress" nil t)
(autoload 'regress "regress" nil t)
