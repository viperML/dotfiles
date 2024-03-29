(use-modules (guix ci))

(list (channel-with-substitutes-available
       %default-guix-channel
       "https://ci.guix.gnu.org")
      (channel
        (name 'nonguix)
        (url "https://gitlab.com/nonguix/nonguix")
        (branch "master")
        (introduction
          (make-channel-introduction
            "897c1a470da759236cc11798f4e0a5f7d4d59fbc"
            (openpgp-fingerprint
              "2A39 3FFF 68F4 EF7A 3D29  12AF 6F51 20A0 22FB B2D5")))))
      ;; (channel
      ;;   (name 'guix-hpc)
      ;;   (url "https://gitlab.inria.fr/guix-hpc/guix-hpc.git")
      ;;   (branch "master")
      ;; (channel
      ;;   (name 'guix-hpc-non-free)
      ;;   (url "https://gitlab.inria.fr/guix-hpc/guix-hpc-non-free.git")
      ;;   (branch "master")
      ;; (channel
      ;;   (name 'guix-science)
      ;;   (url "https://github.com/guix-science/guix-science.git")
      ;;   (branch "master")
      ;;   (introduction
      ;;     (make-channel-introduction
      ;;       "b1fe5aaff3ab48e798a4cce02f0212bc91f423dc"
      ;;       (openpgp-fingerprint
      ;;         "CA4F 8CF4 37D7 478F DA05  5FD4 4213 7701 1A37 8446")))))
      ;; (channel
      ;;   (name 'guix-science-nonfree)
      ;;   (url "https://github.com/guix-science/guix-science-nonfree.git")
      ;;   (branch "master")
      ;;   (introduction
      ;;     (make-channel-introduction
      ;;       "58661b110325fd5d9b40e6f0177cc486a615817e"
      ;;       (openpgp-fingerprint
      ;;         "CA4F 8CF4 37D7 478F DA05  5FD4 4213 7701 1A37 8446"))))
