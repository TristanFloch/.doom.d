;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Tristan Floch"
      user-mail-address "tristan.floch@epita.fr")

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

(setq doom-font (font-spec :family "Source Code Pro" :size 17)
      doom-variable-pitch-font (font-spec :family "Ubuntu Nerd Font" :size 18))

(setq catppuccin-flavor 'mocha) ;; or 'latte, 'macchiato, or 'frappe
(setq doom-theme 'catppuccin)
;; (setq doom-palenight-padded-modeline t)
;; (setq doom-theme 'doom-vibrant)
;; (setq doom-vibrant-padded-modeline t)
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

(setq! scroll-margin 10)

(setq! org-directory "~/Documents/orgfiles/")
(after! org
	(require 'org-superstar)
  (add-hook 'org-mode-hook (lambda() (org-superstar-mode 1)))
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
		         :prepend t))
  (org-link-set-parameters
   "latex-small-caps" nil
   (lambda (_ desc format)
     (cond ((eq format 'latex)
            (format "\\textsc{%s}" desc))))) ;; the path should be left blank
  )

(after! company
    (setq company-idle-delay 0))

;; (set-frame-parameter (selected-frame) 'alpha '(<active> . <inactive>))
;; (set-frame-parameter (selected-frame) 'alpha <both>)
;; (set-frame-parameter (selected-frame) 'alpha '(85 . 85))
;; (add-to-list 'default-frame-alist '(alpha . (85 . 85)))

;; Change the binding of the Org capture
(map! :leader
      :desc "Org Capture"           "x" #'org-capture
      :desc "Pop up scratch buffer" "X" #'doom/open-scratch-buffer)

;; Weekly view in the agenda and log of what I've done during the day
(after! org-agenda
	(setq org-agenda-span 'week)
  (setq org-agenda-start-with-log-mode '(clock))
  (add-to-list 'org-agenda-files (concat org-directory "calendars/")))

(after! org-download
	(setq-default org-download-image-dir "./.images/"
	 setq-default org-download-heading-lvl nil))

(add-hook! '(c-mode c++-mode)
	   (c-set-style "user")
	   (after! lsp-mode
		   (setq! lsp-ui-sideline-show-code-actions nil))
	   )

(add-hook! c++-mode
	   (setq! flycheck-clang-language-standard "c++20")
	   (setq! flycheck-gcc-language-standard "c++20")
	   )

(add-hook! python-mode
	   (after! lsp-mode
		   (setq! lsp-pylsp-plugins-pylint-args '("--errors-only"))
		   )
	   )

(set-file-templates!
  '(c-mode :ignore t)
  '("/main\\.c\\(?:c\\|pp\\)$" :ignore t)
  '("/win32_\\.c\\(?:c\\|pp\\)$" :ignore t)
  '("\\.c\\(?:c\\|pp\\)$" :ignore t)
  '("\\.h\\(?:h\\|pp\\|xx\\)$" :trigger "__pragma-once" :mode c++-mode)
  '("\\.h$" :trigger "__h" :mode c-mode)
  '("/Makefile$" :ignore t)
  )

(map! :leader
      :prefix "t"
      :desc "Doom modeline" "m" #'hide-mode-line-mode
      :desc "Vimish fold" "z" 'vimish-fold-toggle
      )

(map! :after projectile
      :leader
      :prefix "s"
      :desc "Replace in project" "R" 'projectile-replace-regexp)

(map! :leader
      :prefix "o"
      :desc "Calculator" "c" 'calc)

;; (map! :after rjsx-mode
;;       :map rjsx-mode-map
;;       (:prefix-map "C-c"
;;                    "C-c" 'nodejs-repl-send-buffer))

(after! lsp-mode
	(setq! lsp-headerline-breadcrumb-segments '(project file symbols))
	(setq! lsp-headerline-breadcrumb-enable t)
	(setq! lsp-ui-doc-show-with-cursor nil)
	(setq! lsp-ui-doc-show-with-mouse t)
	)

;; (map! :after neotree-mode
;;       :map neotree-mode-map
;;       "v" #'neotree-enter-vertical-split)

(with-eval-after-load 'compile
		      (define-key compilation-mode-map (kbd "h") nil)
		      (define-key compilation-mode-map (kbd "0") nil)
		      (setq compilation-scroll-output t))

(map! :leader
      :prefix "o"
      :desc "Gnus" "g" #'gnus)

(setq auth-sources '("~/.authinfo.gpg"))

(remove-hook 'doom-first-input-hook #'evil-snipe-mode)
(remove-hook 'text-mode-hook #'spell-fu-mode)
;; (add-hook 'nix-mode-hook #'lsp) ; make opening nix files laggy

(setq-hook! 'nix-mode-hook +format-with-lsp nil)

(after! org-noter
	(map! :map pdf-view-mode-map
	      :ni "i" 'org-noter-insert-note)
	(setq! org-noter-always-create-frame nil
	       org-noter-doc-split-fraction '(0.6 0.4)))
