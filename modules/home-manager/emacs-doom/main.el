;; https://github.com/nix-community/nix-doom-emacs/issues/88
(add-hook! 'emacs-startup-hook #'doom-init-ui-h)

(setq mixed-pitch-set-height t)
(setq doom-font (font-spec :family "JetBrainsMono Nerd Font" :size 15 :weight 'medium)
      doom-variable-pitch-font (font-spec :family "Roboto" :size 12)
      ;; doom-unicode-font (font-spec :family "Roboto" :size 14)
      doom-big-font (font-spec :family "JetBrainsMono Nerd Font" :size 20))
(add-hook 'text-mode-hook #'+zen/toggle)
;; (add-hook 'text-mode-hook display-line-numbers nil)


(set-formatter! 'alejandra "alejandra" :modes '(nix-mode))
(setq-hook! 'nix-mode-hook +format-with :none)

(map!
 :leader
 "d" #'treemacs)

(simpleclip-mode t)

(setq confirm-kill-emacs nil)
;; (setq auto-save-default t)

(setq user-full-name "Fernando Ayats"
      user-mail-address "ayatsfer@gmail.com")


(defun synchronize-theme ()
  (let* ((light-theme 'doom-tomorrow-day)
         (dark-theme 'doom-tomorrow-night)
         (start-time-light-theme 6)
         (end-time-light-theme 17)
         (hour (string-to-number (substring (current-time-string) 11 13)))
         (next-theme (if (member hour (number-sequence start-time-light-theme end-time-light-theme))
                         light-theme dark-theme)))
    (load-theme next-theme t)))
(synchronize-theme)

;; (setq markdown-fontify-code-blocks-natively t)
;; (setq pixel-scroll-precision-mode t)
;; (setq pixel-scroll-precision-large-scroll-height )
;; (setq pixel-scroll-precision-interpolation-factor 4.)

;; (setq initial-buffer-choice (lambda() (get-buffer "*dashboard*")))

(setq fancy-splash-image
      (concat (getenv "FLAKE") "/modules/home-manager/emacs-doom/logo"))

(setq projectile-project-search-path '("~/Documents"))

(provide 'main)
;;; main.el ends here
