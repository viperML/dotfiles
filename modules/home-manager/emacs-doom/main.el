(set-face-attribute 'default nil :font "JetBrainsMono Nerd Font-11" :weight 'medium)

(use-package! mixed-pitch
  :hook (text-mode . mixed-pitch-mode))
(use-package! good-scroll
  :init (good-scroll-mode 1))

(set-formatter! 'alejandra "alejandra" :modes '(nix-mode))
(setq-hook! 'nix-mode-hook +format-with :none)

(map!
 :leader
 "b" #'treemacs)
