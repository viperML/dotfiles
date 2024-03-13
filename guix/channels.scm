(list (channel
        (name 'guix)
        (url "https://git.savannah.gnu.org/git/guix.git")
        (branch "master")
        (commit
          "75bad75367fcf2c289fae3b40dbcc850f92177be")
        (introduction
          (make-channel-introduction
            "9edb3f66fd807b096b48283debdcddccfea34bad"
            (openpgp-fingerprint
              "BBB0 2DDF 2CEA F6A8 0D1D  E643 A2A0 6DF2 A33A 54FA"))))
      ;; (channel
      ;;   (name 'nonguix)
      ;;   (url "https://gitlab.com/nonguix/nonguix")
      ;;   (branch "master")
      ;;   (commit
      ;;     "f6121e161d3c5414e3829560b4517c7ba6af89bc")
      ;;   (introduction
      ;;     (make-channel-introduction
      ;;       "897c1a470da759236cc11798f4e0a5f7d4d59fbc"
      ;;       (openpgp-fingerprint
      ;;         "2A39 3FFF 68F4 EF7A 3D29  12AF 6F51 20A0 22FB B2D5"))))
      (channel
        (name 'guix-hpc)
        (url "https://gitlab.inria.fr/guix-hpc/guix-hpc.git")
        (branch "master")
        (commit
          "a19669df48e36b954b5806d38856510b5ad6ed12"))
      ;; (channel
      ;;   (name 'guix-hpc-non-free)
      ;;   (url "https://gitlab.inria.fr/guix-hpc/guix-hpc-non-free.git")
      ;;   (branch "master")
      ;;   (commit
      ;;     "6e27b7e828b6b15057e8ab6700480694434f6756"))
      (channel
        (name 'guix-science)
        (url "https://github.com/guix-science/guix-science.git")
        (branch "master")
        (commit
          "26fba1a759f67f2c6c22049994db328550d45e30")
        (introduction
          (make-channel-introduction
            "b1fe5aaff3ab48e798a4cce02f0212bc91f423dc"
            (openpgp-fingerprint
              "CA4F 8CF4 37D7 478F DA05  5FD4 4213 7701 1A37 8446")))))
      ;; (channel
      ;;   (name 'guix-science-nonfree)
      ;;   (url "https://github.com/guix-science/guix-science-nonfree.git")
      ;;   (branch "master")
      ;;   (commit
      ;;     "77cc77097e66d8246e4ff8d9048f14d3181d4119")
      ;;   (introduction
      ;;     (make-channel-introduction
      ;;       "58661b110325fd5d9b40e6f0177cc486a615817e"
      ;;       (openpgp-fingerprint
      ;;         "CA4F 8CF4 37D7 478F DA05  5FD4 4213 7701 1A37 8446"))))
      ;; (channel
      ;;   (name 'guix-past)
      ;;   (url "https://gitlab.inria.fr/guix-hpc/guix-past")
      ;;   (branch "master")
      ;;   (commit
      ;;     "921f845dc0dec9f052dcda479a15e787f9fd5b0a")
      ;;   (introduction
      ;;     (make-channel-introduction
      ;;       "0c119db2ea86a389769f4d2b9c6f5c41c027e336"
      ;;       (openpgp-fingerprint
      ;;         "3CE4 6455 8A84 FDC6 9DB4  0CFB 090B 1199 3D9A EBB5")))))
