
;;; emacs-wget site-lisp configuration

(add-to-list 'load-path "@SITELISP@")
(autoload 'wget "wget" "wget interface for Emacs." t)
(autoload 'wget-web-page "wget" "wget interface to download whole web page." t)
(load "w3m-wget")
(add-hook 'w3m-mode-hook '(lambda () (require 'w3m-wget)))
