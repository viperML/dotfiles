(use-modules (gnu home)
             (gnu home services)
             (gnu home services guix)
             (gnu services)
             (gnu packages)
             (gnu packages base)
             (gnu packages guile)
             (gnu packages guile-xyz)
             (gnu packages package-management)
             (gnu packages gnupg)
             (gnu packages certs)
             (guix gexp))

(home-environment
  (packages
    (list
      guile-3.0
      guile-readline
      guile-colorized
      guile-gcrypt
      glibc-locales
      nss-certs))

  (services
    (list
      ;; (simple-service
      ;;   'channels
      ;;   home-xdg-configuration-files-service-type
      ;;   (list
      ;;     `("guix/channels.scm" "/dev/null")))

      (simple-service
        'guileconf
        home-files-service-type
        (list
          `(".guile"
            ,(with-extensions (list
                                guile-readline
                                guile-colorized)
                (scheme-file
                  "guileconf"
                  #~(begin
                      (use-modules (ice-9 readline)
                                   (ice-9 colorized))
                      (activate-readline)
                      (activate-colorized)))))))

      (simple-service
        'env-vars
        home-environment-variables-service-type
        `(("GUIX_LOCPATH" . "$HOME/.guix-profile/lib/locale:$HOME/.guix-home/profile/lib/locale"))))))

