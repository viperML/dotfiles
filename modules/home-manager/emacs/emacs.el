
;;;; init.el --- Peel's Essential Emacs Lisp

;;; Commentary:
;;; Work in progress.  An attempt for a clean start of nix-managed config.

;;; Code:
;;; ▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂

(add-hook 'after-init-hook (lambda () (setq gc-cons-threshold 800000)))

;; package.el ▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁
(require 'package)
(package-initialize 'noactivate)

(eval-when-compile
  (require 'use-package))


(use-package emacs
  :defer 0
  :init
  (setq gc-cons-threshold (* 2 100000000)
        inhibit-startup-screen t
        initial-scratch-message nil
        make-backup-files nil
        frame-resize-pixelwise t
        pop-up-windows nil
        column-number-mode t
        confirm-kill-emacs 'yes-or-no-p
        echo-keystrokes 0.1
        visible-bell nil
        hl-line-mode t
        xwidget-webkit-enable-plugins nil)
  (setq-default show-trailing-whitespace t)
  (setq-default indicate-empty-lines t)
  (setq-default indicate-buffer-boundaries 'left)
  :bind (("C-z" . kill-whole-line)
         ("M-n" . forward-paragraph)
         ("M-p" . backward-paragraph)))

;; (use-package modeline
;;   :defer 0
;;   :init
;;   (setq auto-revert-check-vc-info t)
;;   (defun vc-status-mode-line ()
;;     "Builds a source control string or nil."
;;     (when vc-mode
;;       `(" "
;;         ,(s-trim (substring-no-properties vc-mode 5))
;;         " ")))
;;   (setq-default
;;    mode-line-format
;;    (list
;;     '(:eval (propertize " %b " 'face 'font-lock-keyword-face)) ;; buffer
;;     '(:eval (propertize "%* " 'face 'font-lock-warning-face)) ;; ! ro | * mod | - clean
;;     "%l:%c "
;;     '(:eval (propertize (pragmatapro-get-mode-icon) 'face 'font-lock-comment-face)) ;; major
;;     '(:eval (vc-status-mode-line))
;;     '(global-mode-string global-mode-string))))

;; (setq backup-by-copying t
;;       backup-directory-alist '((".*" . "~/.emacs.d/saves/"))
;;       delete-old-versions t
;;       kept-new-versions 6
;;       kept-old-versions 2
;;       version-control t)

;; (setq create-lockfiles nil)

;; (fset 'yes-or-no-p 'y-or-n-p)

;; (setq ring-bell-function (lambda ()
;;                            (invert-face 'mode-line)
;;                            (run-with-timer 0.1 nil 'invert-face 'mode-line)))
