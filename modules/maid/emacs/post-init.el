;; Misc
(defun open-config ()
  "Open post-init.el"
  (interactive)
  (let ((project-switch-commands 'ignore))
    (project-switch-project "~/src/dotfiles/"))
  (find-file "~/src/dotfiles/modules/maid/emacs/post-init.el"))

(global-set-key (kbd "C-+") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)

;; Size of fringe
(set-fringe-mode 3)

;; Smooth scrolling
(use-package ultra-scroll
  :init
  (setq scroll-conservatively 5 ; or whatever value you prefer, since v0.4
        scroll-margin 0) ;; Must be 0
  :config
  (ultra-scroll-mode 1))

;; Display the current line and column numbers in the mode line
(setq line-number-mode t)
(setq column-number-mode t)
(setq mode-line-position-column-line-format '("%l:%C"))
(dolist (hook '(prog-mode-hook text-mode-hook conf-mode-hook))
  (add-hook hook #'display-line-numbers-mode))

;; Show line numbers in buffers
(add-hook 'prog-mode-hook 'display-line-numbers-mode)

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

;; Fix broken cursor on emacs -nw
(use-package evil-terminal-cursor-changer
  :after (evil)
:config
(unless (display-graphic-p)
    (evil-terminal-cursor-changer-activate)))

;; Toggle comment blocks
(use-package evil-commentary
  :after (evil)
  :config (evil-commentary-mode))

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
(set-face-attribute 'default nil :font "Iosevka Viper Medium 11")
(set-face-attribute 'variable-pitch nil :family "Inter")
(use-package all-the-icons)
(use-package doom-themes
  :custom
  (doom-themes-enable-bold t)
  (doom-themes-enable-italic t)
  :config
  (let ((inhibit-redisplay t))
    ;; Disable all active themes
    (mapc #'disable-theme custom-enabled-themes)
    ;; Load the built-in theme
    (load-theme 'doom-gruvbox t)))

;; Tabs
(use-package centaur-tabs
  :hook (after-init . centaur-tabs-mode)
  :config
  (setq centaur-tabs-style "chamfer")
  (setq centaur-tabs-icon-type 'all-the-icons)
  (setq centaur-tabs-set-icons t)
  (setq centaur-tabs-height 30))

;; Modeline
(use-package doom-modeline
  :hook (after-init . doom-modeline-mode))

;; Project.el
(use-package project
  :config
  (setq project-switch-commands 'project-or-external-find-file)
  )

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
   ;; Buffers
   "b"  '(:ignore t :which-key "Buffer")
   "bb" '(consult-buffer :which-key "Switch buffer")
   "bd" '(kill-current-buffer :which-key "Kill buffer")
   "bn" '(next-buffer :which-key "Next buffer")
   "bp" '(previous-buffer :which-key "Previous buffer")
   "bs" '(save-buffer :which-key "Save buffer")
   "br" '(revert-buffer :which-key "Revert buffer")
   "bN" '(evil-buffer-new :which-key "New empty buffer")
   "b[" '(previous-buffer :which-key "Previous buffer")
   "b]" '(next-buffer :which-key "Next buffer")
   ;; Windows
   "w"  '(:ignore t :which-key "Window")
   "ww" '(other-window :which-key "Other window")
   "wd" '(delete-window :which-key "Delete window")
   "wD" '(delete-other-windows :which-key "Delete other windows")
   "ws" '(split-window-below :which-key "Split below")
   "wv" '(split-window-right :which-key "Split right")
   "w=" '(balance-windows :which-key "Balance windows")
   "wh" '(evil-window-left :which-key "Window left")
   "wj" '(evil-window-down :which-key "Window down")
   "wk" '(evil-window-up :which-key "Window up")
   "wl" '(evil-window-right :which-key "Window right")
   "wH" '(evil-window-move-far-left :which-key "Move window left")
   "wJ" '(evil-window-move-very-bottom :which-key "Move window down")
   "wK" '(evil-window-move-very-top :which-key "Move window up")
   "wL" '(evil-window-move-far-right :which-key "Move window right")
   ;; Treemacs (moved from "b")
   "e"  '(treemacs :package treemacs :which-key "Explorer")
  )
)

;; Completions
(use-package corfu
  :hook
  (after-init . global-corfu-mode)
  :bind (("C-SPC" . completion-at-point)
         :map corfu-map
              ("<return>" . corfu-insert)
              ("RET" . corfu-insert)
              ("TAB" . corfu-insert)
              ("<tab>" . corfu-insert)
              ("<escape>" . (lambda () (interactive) (corfu-quit) (evil-normal-state)))
              ("ESC" . (lambda () (interactive) (corfu-quit) (evil-normal-state)))))
(setq tab-always-indent 'complete
      text-mode-ispell-word-completion nil)

;; Vertical complete replacement
(use-package vertico
  :hook (after-init . vertico-mode))

(use-package vertico-mouse
  :ensure nil
  :after vertico
  :config
  (vertico-mouse-mode))

;; Fuzzy algo for vertico
(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles partial-completion))))
  (completion-pcm-leading-wildcard t)) ;; Emacs 31: partial-completion behaves like substring

;; Search more stuff
(use-package consult
  :bind (("C-S-f" . consult-ripgrep))
  :commands (consult-ripgrep
             consult-buffer))

;; savehist is an Emacs feature that preserves the minibuffer history between
;; sessions. It saves the history of inputs in the minibuffer, such as commands,
;; search strings, and other prompts, to a file. This allows users to retain
;; their minibuffer history across Emacs restarts.
(use-package savehist
  :ensure nil
  :commands (savehist-mode savehist-save)
  :hook
  (after-init . savehist-mode)
  :init
  (setq history-length 300)
  (setq savehist-autosave-interval 600))

;; save-place-mode enables Emacs to remember the last location within a file
;; upon reopening. This feature is particularly beneficial for resuming work at
;; the precise point where you previously left off.
(use-package saveplace
  :ensure nil
  :commands (save-place-mode save-place-local-mode)
  :hook
  (after-init . save-place-mode)
  :init
  (setq save-place-limit 400))

;; Dired settings
(setq dired-hide-details-hide-symlink-targets nil)
(add-hook 'dired-mode-hook #'dired-hide-details-mode)

;; Tramp settings
;; For some reason, tramp doesn't use PATH set by bash -l by default.
(with-eval-after-load 'tramp
  (add-to-list 'tramp-remote-path 'tramp-own-remote-path))

;; Auto-close parenthesis
(use-package smartparens
  :hook ((prog-mode text-mode config-mode) . smartparens-mode)
  :config
  (require 'smartparens-config))

(use-package dashboard
  :init
  (setq dashboard-items '((recents   . 5)
                        (projects  . 5)
                        (bookmarks . 5)))
  (setq dashboard-startupify-list '(dashboard-insert-banner
                                    dashboard-insert-navigator
                                    dashboard-insert-items
                                    ;; dashboard-insert-newline
                                    dashboard-insert-init-info
                                    ))
  (setq dashboard-startup-banner 'logo)
  (setq dashboard-set-heading-icons t)
  (setq dashboard-set-file-icons t)
  (setq dashboard-icon-type 'all-the-icons)
  (setq dashboard-icon-file-height 0.75)
  (setq dashboard-heading-icon-height 0.75)
  (setq dashboard-center-content t)
  :config
  (dashboard-setup-startup-hook))

;; Auto-revert in Emacs is a feature that automatically updates the
;; contents of a buffer to reflect changes made to the underlying file
;; on disk.
(use-package autorevert
  :ensure nil
  :commands (auto-revert-mode global-auto-revert-mode)
  :hook
  (after-init . global-auto-revert-mode)
  :init
  (setq auto-revert-interval 3)
  (setq auto-revert-remote-files nil)
  (setq auto-revert-use-notify t)
  (setq auto-revert-avoid-polling nil))

;; Treemacs
(use-package treemacs
  :after (project)
  ;; :hook (after-init . treemacs-start-on-boot)
  :config
  (treemacs-resize-icons 16)
  ;; (set-face-attribute 'treemacs-directory-face nil :family "Inter")
  ;; Use the variable-pitch (sans-serif) font in the treemacs buffer.
  ;; buffer-face-mode applies the face remapping buffer-locally so it
  ;; does not affect the rest of Emacs.
  (add-hook 'treemacs-mode-hook #'variable-pitch-mode))

(use-package treemacs-evil
  :after (treemacs evil))

(use-package treemacs-icons-dired
  :hook (dired-mode . treemacs-icons-dired-enable-once))

;; Synchronise treemacs workspaces with project.el.
;;
;; Each project gets its own named treemacs workspace (named after the
;; project's root directory).  Switching projects via project.el
;; automatically creates the workspace when needed and switches to it.
;;
;; The project is added to the workspace *before* switching so that
;; treemacs never renders an empty workspace, which would otherwise
;; trigger an interactive prompt asking for a project root.
(defun my/treemacs-sync-workspace (dir)
  "Switch to a per-project treemacs workspace for the project at DIR.

Called as :after advice on `project-switch-project'.  DIR is the
project root directory passed by project.el.

Looks up an existing workspace whose name matches the directory
basename.  Creates one if it does not exist.  Ensures the path is
present as a project in the workspace, then switches treemacs to it."
  (when (featurep 'treemacs)
    (require 'treemacs)
    (let* ((path (directory-file-name (expand-file-name dir)))
           (name (file-name-nondirectory path))
           ;; Reuse an existing workspace or create a fresh one.
           (ws (or (treemacs--find-workspace-by-name name)
                   (pcase (treemacs-do-create-workspace name)
                     (`(success ,w) w)))))
      (when ws
        ;; Add the project to the workspace while it is not yet the active
        ;; one.  Temporarily override the current workspace so that
        ;; `treemacs-do-add-project-to-workspace' writes into the right
        ;; workspace without touching the treemacs buffer.
        (unless (treemacs-is-path path :in-workspace ws)
          (let ((prev-ws (treemacs-current-workspace)))
            (unwind-protect
                (progn
                  (setf (treemacs-current-workspace) ws)
                  (treemacs-do-add-project-to-workspace path name))
              (setf (treemacs-current-workspace) prev-ws))))
        ;; Workspace is non-empty now; switch without triggering a prompt.
        (treemacs-do-switch-workspace ws)))))

;; Kill file-visiting buffers that do not belong to the incoming project.
;;
;; Only buffers with an associated file path are considered; scratch
;; buffers, REPLs, compilation windows and the like are left untouched.
;; Buffers whose file falls under DIR (i.e. the new project root) are
;; kept.  Everything else is killed.
(defun my/project-kill-foreign-buffers (dir)
  "Kill file-visiting buffers whose file is not under DIR.

Called as :after advice on `project-switch-project'.  DIR is the
project root directory of the project being switched to."
  (let ((root (expand-file-name dir)))
    (dolist (buf (buffer-list))
      (when-let ((file (buffer-file-name buf)))
        (unless (string-prefix-p root (expand-file-name file))
          (kill-buffer buf))))))

;; Ensure the treemacs window is visible after switching projects so the
;; new workspace is immediately shown, without stealing focus from the
;; current window.
(defun my/project-open-treemacs (&rest _)
  "Show the treemacs window after switching projects without stealing focus.
Does nothing if treemacs is already visible."
  (unless (eq (treemacs-current-visibility) 'visible)
    (save-selected-window
      (treemacs))))

(with-eval-after-load 'project
  (advice-add 'project-switch-project :after #'my/treemacs-sync-workspace)
  (advice-add 'project-switch-project :after #'my/project-kill-foreign-buffers)
  (advice-add 'project-switch-project :after #'my/project-open-treemacs))

;; Git support
(use-package magit
  :after (diff-hl)
  :commands (magit-status magit-dispatch magit-file-dispatch magit-blame)
  :config
  (add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh))

;; Git diffs in gutter
(use-package diff-hl
  :commands (diff-hl-mode
             global-diff-hl-mode)
  :hook (prog-mode . diff-hl-mode)
  :init
  (setq diff-hl-flydiff-delay 0.4)  ; Faster
  (setq diff-hl-show-staged-changes nil)  ; Realtime feedback
  (setq diff-hl-update-async t)  ; Do not block Emacs
  (setq diff-hl-global-modes '(not pdf-view-mode image-mode)))

;; LSP Support
(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :init
  (setq lsp-completion-provider :none) ;; Use corfu via capf instead of company
  (setq lsp-auto-guess-root t)
  :config
  (require 'lsp-mode)
  (require 'lsp-lens)
  (require 'lsp-modeline)
  (require 'lsp-headerline)
  (require 'lsp-diagnostics)
  (require 'lsp-completion)
  (require 'lsp-semantic-tokens))

(use-package lsp-ui
  :after (lsp-mode)
  :commands (lsp-ui-mode)
  :hook (lsp-mode . lsp-ui-mode))

;; Nix support
(use-package nix-mode
  ;; :hook (nix-mode . (lambda () (lsp-deferred)))
  ;; :hook (nix-mode . #'lsp-deferred)
  :hook (nix-mode . lsp-deferred)
  :mode ("\\.nix\\'" . nix-mode))

;; Golang support
(use-package go-mode
  :mode ("\\.go\\'" . go-mode)
  :hook (go-mode . lsp-deferred)
  (before-save . gofmt-before-save))

;; YAML support
(use-package yaml-mode
  :commands yaml-mode
  :hook (yaml-mode . lsp-deferred)
  :mode (("\\.yaml\\'" . yaml-mode)
         ("\\.yml\\'" . yaml-mode)))

;; Dockerfile support
(use-package dockerfile-mode
  :commands dockerfile-mode
  :hook (dockerfile-mode . lsp-deferred)
  :mode ("Dockerfile[^/]*\\'" . dockerfile-mode))

;; Shell script support
(add-hook 'sh-mode-hook #'lsp-deferred)

;; Markdown support
(use-package markdown-mode
  :commands (markdown-mode
             gfm-mode)
  :mode ("\\.md\\'" . gfm-mode))
