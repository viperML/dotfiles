(setq
  make-backup-files nil
  display-line-numbers-type 'relative
  inhibit-startup-screen t
  create-lockfiles nil)

(defalias 'yes-or-no-p 'y-or-n-p)

(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)



;; Sane defaults
;; increase garbage collection during startup
(setq gc-cons-threshold 100000000)
(setq read-process-output-max (* 1024 1024)) ;; 1mb

(add-hook 'after-init-hook #'(lambda ()
           ;; restore after startup
           (setq gc-cons-threshold 800000)))

(setq initial-scratch-message "")         ; Make *scratch* buffer blank
(fset 'yes-or-no-p 'y-or-n-p)             ; y-or-n-p makes answering questions faster
(setq linum-format "%4d ")                ; Line number format
(global-auto-revert-mode t)               ; Auto-update buffer if file has changed on disk

(if (fboundp 'tool-bar-mode)
    (tool-bar-mode -1))
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))

;; use asynchronous processes wherever possible
(use-package async
  :ensure t
  :init (dired-async-mode 1))

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


(set-face-attribute 'default nil :font "JetBrainsMono Nerd Font-10")


(recentf-mode 1)


;; Pkgs
(use-package evil
             :config (evil-mode 1))

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

(use-package good-scroll
             :init (good-scroll-mode 1))

(use-package ivy)
(use-package projectile)
(use-package counsel
  :init (counsel-mode 1))
(use-package counsel-projectile
  :init (counsel-projectile-mode 1))

(use-package doom-themes
             :config
             (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
                   doom-themes-enable-italic t) ; if nil, italics is universally disabled
             (load-theme 'doom-one t)
             (doom-themes-org-config))

(use-package dashboard
             :init
             (dashboard-setup-startup-hook)
             (setq dashboard-startup-banner 'logo)
             (setq dashboard-set-heading-icons t)
             (setq dashboard-set-file-icons t)
             (setq dashboard-items '((recents . 10)
                                     ;; (projects .5)
                                     (bookmarks . 5)
                                     ))
             (setq dashboard-set-footer nil)
             (setq dashboard-center-content t)
             (setq dashboard-projects-switch-function 'counsel-projectile-switch-project-by-name))

(use-package all-the-icons)

(use-package general
  :config
  (general-define-key
   :states '(normal visual insert emacs)
   :prefix "SPC"
   :non-normal-prefix "C-SPC"
   "SPC" '(counsel-find-file :which-key "Find file")
   "p" '(:keymap projectile-command-map :package counsel-projectile :which-key "Projectile")
   ))


(use-package doom-modeline
  :init (doom-modeline-mode 1))
