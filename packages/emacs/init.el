;;; My Emacs configuration
;;; Commentary:
;;; -
;;; Code:

(set-fontset-font t 'unicode (font-spec :family "all-the-icons") nil 'append)
(set-fontset-font t 'unicode (font-spec :family "file-icons") nil 'append)
(set-fontset-font t 'unicode (font-spec :family "Material Icons") nil 'append)
(set-fontset-font t 'unicode (font-spec :family "github-octicons") nil 'append)
(set-fontset-font t 'unicode (font-spec :family "FontAwesome") nil 'append)
(set-fontset-font t 'unicode (font-spec :family "Weather Icons") nil 'append)

;; (setq package-user-dir "~/.config/emacs/elpa")

;; (eval-and-compile
;;   (require 'package)
;;   (setq package-archives '(
;;                            ;; ("elpa" . "https://elpa.gnu.org/packages/")
;;                            ;; ("marmalade" . "https://marmalade-repo.org/packages/")
;;                            ;; ("melpa" . "https://melpa.org/packages/")
;;                            ))
;;   (package-initialize)
;;   ;; i always fetch the archive contents on startup and during compilation, which is slow
;;   (package-refresh-contents)
;;   (unless (package-installed-p 'use-package)
;;     (package-install 'use-package))
;;   (require 'use-package)
;;   ;; i don't really know why this isn't the default...
;;   (setf use-package-always-ensure t))

(eval-when-compile
  (require 'use-package))

(use-package no-littering)

(setq
 make-backup-files nil
 inhibit-startup-screen t
 create-lockfiles nil
 ring-bell-function 'ignore
 confirm-kill-processes nil
 confirm-kill-emacs nil
    ;; Sane defaults
    ;; increase garbage collection during startup
    gc-cons-threshold 100000000
    read-process-output-max (* 1024 1024) ;; 1mb
    initial-scratch-message ""         ; Make *scratch* buffer blank

    scroll-conservatively 101)

(defalias 'yes-or-no-p 'y-or-n-p)



(add-hook 'after-init-hook #'(lambda ()
           ;; restore after startup
                                (setq gc-cons-threshold 800000)))

(fset 'yes-or-no-p 'y-or-n-p)             ; y-or-n-p makes answering questions faster
(global-auto-revert-mode t)               ; Auto-update buffer if file has changed on disk

(if (fboundp 'tool-bar-mode)
    (tool-bar-mode -1))
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(if (fboundp 'scroll-bar-mode)
    (scroll-bar-mode -1))


;; (use-package smooth-scrolling
;;     :config
;;     (smooth-scrolling-mode 1)
;;     (setq smooth-scroll-margin 3))

;; use asynchronous processes wherever possible
;;(use-package async
;;  :init (dired-async-mode 1))

(setq locale-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

;; set default tab display width to 4 spaces
(setq-default tab-width 4)
(setq tab-width 4)

;; set indent commands to always use space only
(progn (setq-default indent-tabs-mode nil))


(set-face-attribute 'default nil :font "iosevka-normal-13" :weight 'medium)


(recentf-mode 1)
(unless (display-graphic-p)
    (xterm-mouse-mode 1))

;; (defun synchronize-theme ()
;;   (let* ((light-theme 'doom-one-light)
;;          (dark-theme 'doom-one)
;;          (start-time-light-theme 6)
;;          (end-time-light-theme 18)
;;          (hour (string-to-number (substring (current-time-string) 11 13)))
;;          (next-theme (if (member hour (number-sequence start-time-light-theme end-time-light-theme))
;;                          light-theme dark-theme)))
;;     (load-theme next-theme)))

(setq select-enable-clipboard nil)

; (run-with-timer 0 900 'synchronize-theme)

;; Padding
(setq header-line-format " ")
; (lambda () (progn
;              (setq left-margin-width 10)
;              (setq right-margin-width 10)
;

(add-hook 'prog-mode-hook (lambda () (electric-pair-mode)))


;; Pkgs
(use-package evil
  :init
  (setq evil-want-integration t) ;; This is optional since it's already set to t by default.
  (setq evil-want-keybinding nil)
  :config
  (evil-mode 1))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(use-package evil-terminal-cursor-changer
    :after evil
    :config
    (unless (display-graphic-p)
        (evil-terminal-cursor-changer-activate)))

(use-package direnv
  :config (direnv-mode))

(use-package mixed-pitch
    :hook (text-mode . mixed-pitch-mode))

(use-package which-key
             :diminish which-key-mode
             :init
             (which-key-mode)
             (setq which-key-idle-delay 0.2))

(use-package markdown-mode
             :mode ("\\.md\\'" . gfm-mode)
             :init (setq markdown-command "multimarkdown"))

(use-package ivy)
(use-package projectile)
;; (setq projectile-cache-file "~/.config/emacs/projectile.cache")
;; (setq projectile-known-projects-file "~/.config/emacs/projectile.eld")
(setq projectile-project-search-path '("~/Documents/" "~/Projects/"))
(use-package counsel
  :init (counsel-mode 1))
(use-package counsel-projectile
  :init (counsel-projectile-mode 1))

(use-package doom-themes
             :init
             (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
                   doom-themes-enable-italic t) ; if nil, italics is universally disabled
             (load-theme 'doom-tomorrow-night t)
             (doom-themes-org-config))

(use-package solaire-mode
  :after (doom-themes)
  :init (solaire-global-mode 1))

(use-package dashboard
  :init
  (dashboard-setup-startup-hook)
  (setq dashboard-startup-banner 'logo)
  (setq dashboard-set-heading-icons t)
  (setq dashboard-set-file-icons t)
  (setq dashboard-items '((recents . 10)
                          (projects . 5)
                          (bookmarks . 5)))

  (setq dashboard-set-footer nil)
  (setq dashboard-center-content t)
  (setq dashboard-projects-switch-function 'counsel-projectile-switch-project-by-name))

(use-package all-the-icons)

(use-package general
  :config
  (general-define-key
   :keymaps 'global
   "C-S-v" 'clipboard-yank
   "C-S-c" 'clipboard-kill-ring-save)
  (general-define-key
   :states '(normal visual insert emacs)
   :prefix "SPC"
   :non-normal-prefix "C-SPC"
   "SPC" '(counsel-file-jump :which-key "Jump to file")
   "p" '(:keymap projectile-command-map :package counsel-projectile :which-key "Projectile")
   "b" '(treemacs :package treemacs)))



(use-package doom-modeline
  :init
  (doom-modeline-mode 1))

(use-package treemacs
  :defer t)

(use-package treemacs-nerd-icons
  :after treemacs
  :config
  (treemacs-load-theme "nerd-icons"))

(use-package treemacs-projectile
  :after (treemacs projectile))

(use-package treemacs-evil
  :after (treemacs evil))

(use-package centaur-tabs
  :demand
  :config
  (setq centaur-tabs-style "chamfer")
  (setq centaur-tabs-set-icons t)
  (setq centaur-tabs-height 30)
  (centaur-tabs-mode t))

;; (use-package smartparens-config
;;   :ensure smartparens
;;   :config
;;   (progn
;;     (show-smartparens-global-mode t)
;;     (add-hook 'prog-mode-hook 'turn-on-smartparens-strict-mode)
;;     (add-hook 'markdown-mode-hook 'turn-on-smartparens-strict-mode)))

(use-package paredit
  :init
  (add-hook 'clojure-mode-hook #'enable-paredit-mode)
  (add-hook 'cider-repl-mode-hook #'enable-paredit-mode)
  (add-hook 'emacs-lisp-mode-hook #'enable-paredit-mode)
  (add-hook 'eval-expression-minibuffer-setup-hook #'enable-paredit-mode)
  (add-hook 'ielm-mode-hook #'enable-paredit-mode)
  (add-hook 'lisp-mode-hook #'enable-paredit-mode)
  (add-hook 'lisp-interaction-mode-hook #'enable-paredit-mode)
  (add-hook 'scheme-mode-hook #'enable-paredit-mode)
  :config
  (show-paren-mode t)
  ;; :bind (("M-[" . paredit-wrap-square)
  ;;        ("M-{" . paredit-wrap-curly))
  :diminish nil)

(use-package evil-cleverparens
  :config
  (add-hook 'paredit-mode-hook #'evil-cleverparens-mode))


;; LSP
(use-package lsp-mode
  :hook
  (lsp-mode . lsp-enable-which-key-integration)
  :commands (lsp lsp-deferred))
(use-package lsp-ui
  :commands lsp-ui-mode)
(use-package lsp-ivy
  :commands lsp-ivy-workspace-symbol)
(use-package lsp-treemacs
  :commands lsp-treemacs-errors-list)
(use-package flycheck
  :init (global-flycheck-mode))
(use-package company
  :init (global-company-mode))

;; Nix
(use-package nix-mode
  :mode "\\.nix\\'")

;; Last to override keybinds
(use-package ergoemacs-mode
  :config
  (setq ergoemacs-theme nil)
  (setq ergoemacs-keyboard-layout "us")
  (ergoemacs-mode 1))


;;; init.el ends here
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages nil))
(custom-set-faces)
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.


(use-package geiser-guile)
(setq geiser-active-implementations '(guile))
(use-package geiser)
(use-package guix
  :config
  (add-hook 'scheme-mode-hook 'guix-devel-mode))
