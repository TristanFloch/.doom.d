;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Tristan Floch"
      user-mail-address "tristan.floch@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:

(setq doom-font (font-spec :family "SauceCodePro Nerd Font" :size 17)
      doom-variable-pitch-font (font-spec :family "Ubuntu Nerd Font" :size 18))

;; (setq catppuccin-flavor 'mocha) ;; or 'latte, 'macchiato, or 'frappe
;; (setq doom-theme 'doom-tokyo-night)
;; (setq doom-palenight-padded-modeline t)
(setq doom-theme 'doom-vibrant)
(setq doom-vibrant-padded-modeline t)
(doom-themes-org-config)
(setq doom-themes-treemacs-theme "doom-colors")
(setq doom-themes-treemacs-enable-variable-pitch nil)

(after! treemacs
  (setq treemacs-show-cursor t))

;; (display-battery-mode t)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; Only used if doom-dashboard is enabled

(setq! my/data-dir (concat doom-user-dir "data/"))
(defun my/file-to-string (file)
  "File to string function"
  (with-temp-buffer
    (insert-file-contents file)
    (string-trim (buffer-string))))

(setq! fancy-splash-image (concat my/data-dir "doom-256.png"))

(setq! org-directory "~/Documents/orgfiles/")
(after! org
  ;; (require 'org-superstar)
  ;; (add-hook 'org-mode-hook (lambda() (org-superstar-mode 1)))
  (setq org-ellipsis " ▾"
        ;; org-format-latex-options (plist-put org-format-latex-options :scale 0.55) ;; might be specific to my system
        org-startup-folded t
        org-cycle-include-plain-lists 'integrate
        )
  (add-to-list 'org-capture-templates
               '("b" "Book" entry (file+headline "books.org" "Books")
                 "* %^{Author} - %^{Title} %^g\n"
                 :prepend t))
  (add-to-list 'org-capture-templates
               '("l" "Link" entry (file+headline "links.org" "Links")
                 "* [[%x][%^{Description}]] %^g\n"
                 :immediate-finish t
                 :prepend t)))

(after! company
  (setq company-idle-delay 0))

(after! corfu
  (setq! corfu-auto-delay 0
         corfu-preview-current nil
         corfu-max-width 70
         corfu-preselect t
         +corfu-want-minibuffer-completion nil
         +corfu-want-tab-prefer-navigating-snippets t))

(after! org-agenda
  (setq org-agenda-span 'week)
  (setq org-agenda-start-with-log-mode '(clock))
  (add-to-list 'org-agenda-files (concat org-directory "calendars/")))

(after! org-download
  (setq-default org-download-image-dir "./.images/"
                org-download-heading-lvl nil))

(add-hook! '(c-mode c++-mode)
  (c-set-style "user")
  (after! lsp-mode
    (setq! lsp-ui-sideline-show-code-actions nil)))

(add-hook! c++-mode
  (setq! flycheck-clang-language-standard "c++20")
  (setq! flycheck-gcc-language-standard "c++20")
  )

(setq-hook! 'rust-mode-hook +format-with 'lsp)

;; (add-hook! prog-mode
;;   (add-hook 'completion-at-point-functions #'codeium-completion-at-point))

(set-file-templates!
 '(c-mode :ignore t)
 '("\\.sh$" :ignore t)
 '("\\.py$" :ignore t)
 '("/main\\.c\\(?:c\\|pp\\)$" :ignore t)
 '("/win32_\\.c\\(?:c\\|pp\\)$" :ignore t)
 '("\\.c\\(?:c\\|pp\\)$" :ignore t)
 '("\\.h\\(?:h\\|pp\\|xx\\)$" :trigger "__pragma-once" :mode c++-mode)
 '("\\.h$" :trigger "__h" :mode c-mode)
 '("/Makefile$" :ignore t)
 )

(map! :leader

      ;; switch org capture and scratch buffer
      :desc "Org Capture"           "x" #'org-capture
      :desc "Pop up scratch buffer" "X" #'doom/open-scratch-buffer

      (:prefix "t"
       :desc "Doom modeline" "m" #'hide-mode-line-mode
       (:when (modulep! :completion company)
         :map company-mode-map
         :desc "Company autocompletion" "a" #'+company/toggle-auto-completion)
       (:map org-mode-map
        :desc "Zen mode" "z" #'+zen/toggle)
       (:when (modulep! :tools lsp +eglot)
         :map eglot-mode-map
         :desc "Inlay hints mode" "h" #'eglot-inlay-hints-mode))

      (:prefix "o"
       :desc "Calculator" "c" 'calc
       ;; :desc "Project tree" "p" #'+treemacs/toggle
       ;; :desc "Find file in project sidebar" "P" #'treemacs-find-file
       )

      (:prefix "s"
               (:map projectile-mode-map
                :desc "Replace in project" "R" 'projectile-replace-regexp))

      (:prefix "TAB"
               (:map persp-mode-map
                :desc "Swap workspace left" "H" '+workspace/swap-left
                :desc "Swap workspace right" "L" '+workspace/swap-right)))

(after! lsp-mode
  (setq! lsp-headerline-breadcrumb-segments '(project file symbols)
         lsp-headerline-breadcrumb-enable t
         lsp-ui-doc-show-with-cursor nil
         lsp-ui-doc-show-with-mouse t
         lsp-clangd-binary-path (executable-find "clangd")
         lsp-clients-clangd-args '("--enable-config"
                                   "--clang-tidy"
                                   "--header-insertion=never"
                                   "--header-insertion-decorators=0"
                                   "--limit-results=20"
                                   "--pch-storage=memory")
         lsp-pylsp-plugins-black-enabled t ; formatter
         lsp-pylsp-plugins-flake8-enabled t ; linter
         lsp-pylsp-plugins-mypy-enabled t ; type error hints
         ))


(with-eval-after-load 'compile
  (define-key compilation-mode-map (kbd "h") nil)
  (define-key compilation-mode-map (kbd "0") nil)
  (setq compilation-scroll-output t))

(setq-hook! '(eshell-mode-hook shell-mode-hook)
  company-idle-delay nil)

(map! :i
      "M-/" #'+company/complete)

(setq auth-sources '("~/.authinfo.gpg"))

(remove-hook 'doom-first-input-hook #'evil-snipe-mode)
(remove-hook 'text-mode-hook #'spell-fu-mode)
;; (add-hook 'nix-mode-hook #'lsp) ; make opening nix files laggy

(setq-hook! '(nix-mode-hook
              cuda-mode-hook
              python-mode-hook
              ;; c++-mode-hook
              ;; c-mode-hook
              )
  +format-with-lsp nil)
(setq-hook! 'python-mode-hook +format-with 'black)
(setq! +format-on-save-disabled-modes
       '(python-mode
         protobuf-mode))

(after! org-noter
  (map! :map pdf-view-mode-map
        :ni "i" 'org-noter-insert-note)
  (setq! org-noter-always-create-frame nil
         org-noter-doc-split-fraction '(0.6 0.4)))

(after! web-mode
  (setq! typescript-indent-level 2
         css-indent-offset 2
         web-mode-code-indent-offset 2
         web-mode-css-indent-offset 2))

(use-package! magit
  :config
  (transient-append-suffix 'magit-push "-u"
    '(1 "-s" "Skip GitLab pipeline" "--push-option=ci.skip"))
  (transient-append-suffix 'magit-push "-u"
    '(2 "-t" "Follow-tags" "--follow-tags")))

(use-package! lsp-dart
  :after dart-mode
  :config
  (setq! lsp-dart-dap-flutter-hot-reload-on-save t)
  (set-popup-rule! "\\*Flutter\\*"
    :size 0.4
    :select t
    :ttl nil ; do not kill on dismiss
    ))

(after! dirvish
  (setq! dirvish-quick-access-entries
         `(("h" "~/"                          "Home")
           ("d" "~/Downloads/"                "Downloads")
           ("e" ,user-emacs-directory         "Emacs user directory"))
         ;; dirvish-attributes '(vc-state file-size nerd-icons subtree-state collapse)
         )
  (push 'collapse dirvish-attributes)
  (custom-set-faces!
    '(dirvish-hl-line :inherit treemacs-hl-line-face)) ; softer than default (which is highlight)
  )


(setq-hook! 'sh-mode-hook +format-with nil)
(setq-hook! '(css-mode-hook nix-mode-hook) +format-inhibit t)

(add-to-list 'auto-mode-alist '("\\.spec\\(\\.in\\)?$" . prog-mode))

(use-package! ultra-scroll
  :init (setq scroll-conservatively 101
              scroll-margin 0)
  :config (ultra-scroll-mode t))

(setq! shell-file-name (executable-find "fish"))

(use-package! copilot
  :bind
  (:map copilot-mode-map
        ("M-RET" . 'copilot-accept-completion)
        ("M-<return>" . 'copilot-accept-completion)
        ("M-f" . 'copilot-accept-completion-by-word)
        ("M-l" . 'copilot-accept-completion-by-line)
        ("C-f" . 'copilot-accept-completion-by-line)
        ("M-J" . 'copilot-next-completion)
        ("M-K" . 'copilot-previous-completion)
        ("M-P" . 'copilot-panel-complete))
  :config
  (set-popup-rule! "\\*copilot-panel\\*"
    :side 'right
    :size 0.3
    :select nil
    :modeline nil
    :ttl 'ignore
    :quit t
    )
  (add-to-list 'copilot-indentation-alist '(emacs-lisp-mode 2))
  (add-to-list 'copilot-indentation-alist '(nix-mode lisp-indent-offset))
  (add-to-list 'copilot-indentation-alist '(markdown-mode 2)))
