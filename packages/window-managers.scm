(define-module (gnu packages wm)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  ;; #:use-module (guix download)
  #:use-module (guix git-download)
  ;; #:use-module (guix build-system asdf)
  ;; #:use-module (guix build-system cmake)
  ;; #:use-module (guix build-system gnu)
  ;; #:use-module (guix build-system haskell)
  ;; #:use-module (guix build-system meson)
  ;; #:use-module (guix build-system perl)
  #:use-module (guix build-system python)
  ;; #:use-module (guix build-system trivial)
  ;; #:use-module (guix utils)
  ;; #:use-module (gnu packages)
  ;; #:use-module (gnu packages bash)
  ;; #:use-module (gnu packages autotools)
  ;; #:use-module (gnu packages base)
  ;; #:use-module (gnu packages bison)
  ;; #:use-module (gnu packages build-tools)
  ;; #:use-module (gnu packages calendar)
  ;; #:use-module (gnu packages check)
  ;; #:use-module (gnu packages datastructures)
  ;; #:use-module (gnu packages docbook)
  ;; #:use-module (gnu packages documentation)
  ;; #:use-module (gnu packages fontutils)
  ;; #:use-module (gnu packages freedesktop)
  ;; #:use-module (gnu packages fribidi)
  ;; #:use-module (gnu packages gawk)
  ;; #:use-module (gnu packages gcc)
  ;; #:use-module (gnu packages gl)
  ;; #:use-module (gnu packages glib)
  ;; #:use-module (gnu packages gperf)
  ;; #:use-module (gnu packages gtk)
  ;; #:use-module (gnu packages haskell-check)
  ;; #:use-module (gnu packages haskell-web)
  ;; #:use-module (gnu packages haskell-xyz)
  ;; #:use-module (gnu packages image)
  ;; #:use-module (gnu packages imagemagick)
  ;; #:use-module (gnu packages libevent)
  ;; #:use-module (gnu packages libffi)
  ;; #:use-module (gnu packages linux)
  ;; #:use-module (gnu packages lisp-check)
  ;; #:use-module (gnu packages lisp-xyz)
  ;; #:use-module (gnu packages logging)
  ;; #:use-module (gnu packages lua)
  ;; #:use-module (gnu packages m4)
  ;; #:use-module (gnu packages man)
  ;; #:use-module (gnu packages maths)
  ;; #:use-module (gnu packages mpd)
  ;; #:use-module (gnu packages pcre)
  ;; #:use-module (gnu packages perl)
  ;; #:use-module (gnu packages pkg-config)
  ;; #:use-module (gnu packages pretty-print)
  ;; #:use-module (gnu packages pulseaudio)
  ;; #:use-module (gnu packages python)
  ;; #:use-module (gnu packages python-crypto)
  ;; #:use-module (gnu packages python-xyz)
  ;; #:use-module (gnu packages readline)
  ;; #:use-module (gnu packages serialization)
  ;; #:use-module (gnu packages sphinx)
  ;; #:use-module (gnu packages suckless)
  ;; #:use-module (gnu packages texinfo)
  ;; #:use-module (gnu packages textutils)
  ;; #:use-module (gnu packages time)
  ;; #:use-module (gnu packages video)
  ;; #:use-module (gnu packages web)
  ;; #:use-module (gnu packages xdisorg)
  ;; #:use-module (gnu packages xml)
  ;; #:use-module (gnu packages xorg))
) 


(define-public qtile
  (package
    (name "qtile")
    (version "0.18.1")
    (source
      (origin
        (method url-fetch)
        (uri (pypi-uri "qtile" version))
        (sha256
          (base32 "14hb26xkza7brvkd4276j60mxd3zsas72ih6y0cq3j060izm1865"))))
    (build-system python-build-system)
    (arguments
     `(#:tests? #f ; Tests require Xvfb and writable temp/cache space
       #:phases
       (modify-phases %standard-phases
         (add-after 'unpack 'patch-paths
           (lambda* (#:key inputs #:allow-other-keys)
             (substitute* "libqtile/pangocffi.py"
               (("^gobject = ffi.dlopen.*")
                 (string-append "gobject = ffi.dlopen(\""
                  (assoc-ref inputs "glib") "/lib/libgobject-2.0.so.0\")\n"))
                (("^pango = ffi.dlopen.*")
                 (string-append "pango = ffi.dlopen(\""
                  (assoc-ref inputs "pango") "/lib/libpango-1.0.so.0\")\n"))
                (("^pangocairo = ffi.dlopen.*")
                 (string-append "pangocairo = ffi.dlopen(\""
                                (assoc-ref inputs "pango") "/lib/libpangocairo-1.0.so.0\")\n")))))
        (add-after
                'install 'install-xsession
                (lambda _
                    (let* ((xsessions (string-append %output "/share/xsessions")))
                    (mkdir-p xsessions)
                    (call-with-output-file
                        (string-append xsessions "/qtile.desktop")
                        (lambda (port)
                        (format port "~
                            [Desktop Entry]~@
                            Name=~a~@
                            Comment=~a~@
                            Exec=~qtile start~@
                            Type=Application~%" ,name ,synopsis %output)))))))))
    (inputs
      (list glib pango pulseaudio))
    (propagated-inputs
      (list python-cairocffi
            python-cffi
            python-dateutil
            python-dbus-next
            python-iwlib
            python-keyring
            python-mpd2
            python-pyxdg
            python-xcffib))
    (native-inputs
      (list pkg-config
            python-flake8
            python-pep8-naming
            python-psutil
            python-pytest-cov
            python-setuptools-scm))
    (home-page "http://qtile.org")
    (synopsis "Hackable tiling window manager written and configured in Python")
    (description "Qtile is simple, small, and extensible.  It's easy to write
your own layouts, widgets, and built-in commands.")
    (license license:expat)))
