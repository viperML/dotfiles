;; https://www.reddit.com/r/DoomEmacs/comments/sm0m0k/my_variable_space_font_is_looking_much_smaller/
;; (use-package! mixed-pitch
;;   :hook (text-mode . mixed-pitch-mode))
(setq mixed-pitch-set-height t)
(setq doom-font (font-spec :family "JetBrainsMono Nerd Font" :size 15 :weight 'medium)
      doom-variable-pitch-font (font-spec :family "Roboto" :size 12)
      doom-unicode-font (font-spec :family "Roboto" :size 14)
      doom-big-font (font-spec :family "JetBrainsMono Nerd Font"))
(add-hook 'text-mode-hook #'+zen/toggle)
;; (add-hook 'text-mode-hook display-line-numbers nil)



(set-formatter! 'alejandra "alejandra" :modes '(nix-mode))
(setq-hook! 'nix-mode-hook +format-with :none)

(map!
 :leader
 "b" #'treemacs)

(map!
 "C-v" #'paste-from-clipboard)
(map!
 "C-c" #'copy-to-clipboard)

(setq confirm-kill-emacs nil)
;; (setq doom-theme 'spacemacs-light)

(setq user-full-name "Fernando Ayats"
      user-mail-address "ayatsfer@gmail.com")

(setq auto-save-default t)
(setq doom-modeline-enable-word-count t)

(defun synchronize-theme ()
  (let* ((light-theme 'doom-tomorrow-day)
         (dark-theme 'doom-tomorrow-night)
         (start-time-light-theme 6)
         (end-time-light-theme 17)
         (hour (string-to-number (substring (current-time-string) 11 13)))
         (next-theme (if (member hour (number-sequence start-time-light-theme end-time-light-theme))
                         light-theme dark-theme)))
    (load-theme next-theme t)))
;; (use-package! spacemacs-theme
;;   :config
;;   (synchronize-theme))
(synchronize-theme)


(setq markdown-fontify-code-blocks-natively t)
(setq pixel-scroll-precision-mode t)
(setq pixel-scroll-precision-large-scroll-height 40.0)
(setq pixel-scroll-precision-interpolation-factor 30)
