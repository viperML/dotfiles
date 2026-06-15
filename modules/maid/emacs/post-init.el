;; Misc
(defun open-config ()
  "Open post-init.el"
  (interactive)
  (let ((project-switch-commands 'ignore))
    (project-switch-project "~/src/dotfiles/"))
  (find-file "~/src/dotfiles/modules/maid/emacs/post-init.el"))

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
  (setq evil-want-keybinding t)
  :config
  (define-key evil-normal-state-map (kbd "M-.") nil)
  (define-key evil-normal-state-map (kbd "C-.") nil))

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
(use-package all-the-icons)
(use-package doom-themes
  :custom
  (doom-themes-enable-bold t)
  (doom-themes-enable-italic t)
  ; (doom-themes-treemacs-theme "doom-gruvbox")
  :config
  (let ((inhibit-redisplay t))
    ;; Disable all active themes
    (mapc #'disable-theme custom-enabled-themes)
    ;; Load the built-in theme
    (load-theme 'doom-gruvbox t))
  ;; or for treemacs users
    ; (doom-themes-treemacs-config)
  ;; Corrects (and improves) org-mode's native fontification.
  ;; (doom-themes-org-config)
  )

;; Tabs
(use-package centaur-tabs
  :hook (after-init . centaur-tabs-mode)
  :config
  (setq centaur-tabs-style "chamfer")
  (setq centaur-tabs-icon-type 'all-the-icons)
  (setq centaur-tabs-set-icons t)
  (setq centaur-tabs-height 30)
  )

;; Modeline
(use-package doom-modeline
  :hook (after-init . doom-modeline-mode))

;; Project.el
(use-package project
  :config
  (setq project-switch-commands 'project-or-external-find-file)
  )

;; Nix support
(use-package nix-mode
  :hook (nix-mode . eglot-ensure)
  :mode ("\\.nix\\'" . nix-mode))

;; Cancel minibuffer prompts with ESC or C-c
(define-key minibuffer-local-map (kbd "<escape>") 'abort-minibuffers)
(define-key minibuffer-local-map (kbd "C-c") 'abort-minibuffers)
;;; esc always quits
(global-set-key [escape] 'keyboard-quit)

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
   "SPC" 'project-or-external-find-file
  ;;  "SPC" '(counsel-file-jump :which-key "Jump to file")
   ; "p" 'project-prefix-map
   "p" '(:keymap project-prefix-map :package counsel-projectile :which-key "Project")
   "b" '(treemacs :package treemacs)
  )
)

;; LSP Support
; (global-unset-key (kbd "C-."))
(use-package eglot
  :commands (eglot
             eglot-rename
             eglot-ensure)
  :config
  (add-to-list 'eglot-server-programs '(nix-mode . ("nil")))
  (global-set-key [f2] 'eglot-rename)
  (global-set-key (kbd "C-.") 'eglot-code-actions)
  :defer t)

;; Non-lsp checking
;(use-package flycheck
;  :hook (after-init . global-flycheck-mode))

;; Completions
(use-package company
  :hook ((after-init . global-company-mode))
  :bind (("C-SPC" . company-complete)
         :map company-active-map
              ("<return>" . company-complete-selection)
              ("RET" . company-complete-selection)
              ("TAB" . company-complete-selection)
              ("<tab>" . company-complete-selection)
              ("<escape>" . (lambda () (interactive) (company-abort) (evil-normal-state)))
              ("ESC" . (lambda () (interactive) (company-abort) (evil-normal-state)))))

;; Vertical complete replacement
(use-package vertico
  :hook (after-init . vertico-mode))

;; Fuzzy algo for vertico
(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles partial-completion))))
  (completion-pcm-leading-wildcard t)) ;; Emacs 31: partial-completion behaves like substring

;; Dired settings
(setq dired-hide-details-hide-symlink-targets nil)
(add-hook 'dired-mode-hook #'dired-hide-details-mode)

;; Tramp settings
;; For some reason, tramp doesn't use PATH set by bash -l by default.
(with-eval-after-load 'tramp
  (add-to-list 'tramp-remote-path 'tramp-own-remote-path))

;; Golang support
(use-package go-mode
  :mode ("\\.go\\'" . go-mode)
  :hook
  (go-mode . eglot-ensure)
  (before-save . gofmt-before-save))

;; YAML support
(use-package yaml-mode
  :commands yaml-mode
  :hook (yaml-mode . eglot-ensure)
  :mode (("\\.yaml\\'" . yaml-mode)
         ("\\.yml\\'" . yaml-mode)))

;; Dockerfile support
(use-package dockerfile-mode
  :commands dockerfile-mode
  :hook (dockerfile-mode . eglot-ensure)
  :mode ("Dockerfile[^/]*\\'" . dockerfile-mode))

;; Markdown support
(use-package markdown-mode
  :commands (markdown-mode
             gfm-mode)
  :mode ("\\.md\\'" . gfm-mode))

;; Tree-sitter
;; (use-package treesit-auto
;;   :hook
;;   (after-init . global-treesit-auto-mode)
;;   :init
;;   (setq treesit-auto-install 'prompt))
