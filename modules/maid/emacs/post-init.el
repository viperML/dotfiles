;; Misc

;; Smooth scrolling
(use-package ultra-scroll
  :init
  (setq scroll-conservatively 3 ; or whatever value you prefer, since v0.4
        scroll-margin 0)        ; important: scroll-margin>0 not yet supported
  :config
  (ultra-scroll-mode 1))

;; Display the current line and column numbers in the mode line
(setq line-number-mode t)
(setq column-number-mode t)
(setq mode-line-position-column-line-format '("%l:%C"))

;; Vim emulation
(use-package evil
  :commands (evil-mode evil-define-key)
  :hook (after-init . evil-mode)
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding t))

;; Print keys being pressed
(use-package which-key
  :ensure nil ; builtin
  :commands which-key-mode
  :hook (after-init . which-key-mode)
  :custom
  (which-key-idle-delay 1.5)
  (which-key-idle-secondary-delay 0.25)
  (which-key-add-column-padding 1)
  (which-key-max-description-length 40))

;; LSP Support with Eglot
(use-package eglot
  :ensure nil
  :commands (eglot-ensure
             eglot-rename
             eglot-format-buffer))

;; Visual style
(set-face-attribute 'default nil :font "iosevka-normal-13" :weight 'medium)
(use-package doom-themes
  :custom
  (doom-themes-enable-bold t)
  (doom-themes-enable-italic t)
  ;; (doom-themes-treemacs-theme "doom-gruvbox")
  :config
  (let ((inhibit-redisplay t))
    ;; Disable all active themes
    (mapc #'disable-theme custom-enabled-themes)
    ;; Load the built-in theme
    (load-theme 'doom-gruvbox t))
  ;; or for treemacs users
  ;; (doom-themes-treemacs-config)
  ;; Corrects (and improves) org-mode's native fontification.
  ;; (doom-themes-org-config)
  )

;; Modeline
(use-package doom-modeline
  :hook (after-init . doom-modeline-mode))

(use-package which-key
  :ensure nil ; builtin
  :commands which-key-mode
  :hook (after-init . which-key-mode)
  :custom
  (which-key-idle-delay 1.5)
  (which-key-idle-secondary-delay 0.25)
  (which-key-add-column-padding 1)
  (which-key-max-description-length 40))

;; Nix support
(use-package nix-mode
  :mode ("\\.nix\\'" . nix-mode))

(use-package general
  :after (evil)
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
