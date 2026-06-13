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

;; Show line numbers in buffers
(add-hook 'prog-mode-hook 'display-line-numbers-mode)
;; (global-display-line-numbers-mode 1)

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

;; Visual style
(set-face-attribute 'default nil :font "iosevka-normal-11" :weight 'medium)
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
   :states '(normal emacs)
   :prefix "SPC"
  ;;  "SPC" '(counsel-file-jump :which-key "Jump to file")
  ;;  "p" '(:keymap projectile-command-map :package counsel-projectile :which-key "Projectile")
  ;;  "b" '(treemacs :package treemacs)
  )
)

;; LSP Support
(use-package eglot
  :defer t)

;; Completions
(use-package company
  :ensure t
  :hook ((prog-mode . company-mode))
  :bind (("C-SPC" . company-complete)
         :map company-active-map
              ("<return>" . company-complete-selection)
              ("RET" . company-complete-selection)
              ("TAB" . company-complete-selection)
              ("<tab>" . company-complete-selection)
              ("<escape>" . (lambda () (interactive) (company-abort) (evil-normal-state)))
              ("ESC" . (lambda () (interactive) (company-abort) (evil-normal-state)))))

;; (use-package company-box
;;   :ensure t
;;   :hook (company-mode . company-box-mode))

;; Golang support
(use-package go-mode
  :mode ("\\.go\\'" . go-mode)
  :hook
  (go-mode . eglot-ensure)
  (before-save . gofmt-before-save))
