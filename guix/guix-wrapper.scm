(use-modules (guix build utils)
             (gnu packages base)
             (gnu packages xorg)
             (guix gexp)
             (guix packages)
             (guix build-system trivial)
             (guix modules))

(define lndir_bin
  #~(string-append #$lndir "/bin/lndir"))

(define guix-wrapped
  (package
    (name "guix-wrapped")
    (version "0.1.0")
    (source #f)
    (build-system trivial-build-system)
    (synopsis "")
    (description "")
    (license #f)
    (home-page #f)
    (arguments
      (list
        #:builder
        (with-imported-modules (source-module-closure
                                '((guix build utils)))
          #~(begin
              (invoke #$lndir_bin "-h")))))))

(define g
  (with-imported-modules (source-module-closure
                          '((guix build utils)))
      #~(begin
          (use-modules ((guix build utils)))
          (mkdir #$output)
          (invoke #$lndir_bin #$hello #$output))))

(computed-file "g" g)
