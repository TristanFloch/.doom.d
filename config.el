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

(setq doom-font (font-spec :family "DejaVuSansMono Nerd Font" :size 16)
      doom-variable-pitch-font (font-spec :family "DejaVu Sans" :size 16))

(setq doom-theme 'doom-dracula)
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

(setq! my/data-dir (concat doom-private-dir "data/"))
(defun my/file-to-string (file)
  "File to string function"
  (with-temp-buffer
    (insert-file-contents file)
    (string-trim (buffer-string))))

(setq! fancy-splash-image (concat my/data-dir "doom-256.png"))

;; (use-package! dashboard
;;   :init
;;   (setq dashboard-startup-banner (concat doom-private-dir "doom-256.png"))
;;   (setq dashboard-items '((recents . 5)
;;                           (projects . 5)
;;                           (bookmarks . 5)
;;                           (agenda . 5)))
;;   (setq dashboard-set-heading-icons t)
;;   (setq dashboard-set-file-icons t)
;;   :config
;;   (dashboard-setup-startup-hook)
;;   (setq initial-buffer-choice (lambda() (get-buffer "*dashboard*")))
;;   (setq doom-fallback-buffer-name "*dashboard*")
;;   (setq doom-fallback-buffer "*dashboard*")
;;   )


;; Sets a scroll offset (as in Vim)
(setq scroll-margin 10)

(setq org-directory "~/Documents/orgfiles/")
(after! org
  (require 'org-superstar)
  (add-hook 'org-mode-hook (lambda() (org-superstar-mode 1)))
  (setq org-ellipsis " ▾"
        org-superstar-headline-bullets-list '("◉" "○" "✸" "✿" "✤" "✜" "◆" "▶"))
  (add-to-list 'org-capture-templates
               '("b" "Book" entry (file+headline "books.org" "Books")
                 "* %^{Author} - %^{Title} %^g\n"
                 :prepend t))
  (add-to-list 'org-capture-templates
               '("l" "Link" entry (file+headline "links.org" "Links")
                 "* %x %^g\n"
                 :immediate-finish t
                 :prepend t))
  (org-add-link-type
   "latex-small-caps" nil
   (lambda (path desc format)
     (cond
      ((eq format 'latex)
       (format "\\textsc{%s}" desc))))) ;; the path should be left blank
  )

(require 'org-gcal)
(setq
 org-gcal-auto-archive nil ;; Temporary fix until https://github.com/kidd/org-gcal.el/issues/172 is merged
 org-gcal-client-id "517191471377-0g7snp1jneht2s8tmqth900nf13t9vbl.apps.googleusercontent.com"
 org-gcal-client-secret (my/file-to-string (concat my/data-dir "org-gcal-client-secret"))
 org-gcal-fetch-file-alist (mapcar '(lambda (key-val)
                                      (let ((lhs (car key-val))
                                            (rhs (concat org-directory "calendars/" (cdr key-val))))
                                        (cons lhs rhs)))
                                   '(("tristan.floch@gmail.com" . "gcal.org")
                                     ("cvc5giinpq8llis9l19ur7e7kt6unuv2@import.calendar.google.com" . "gistre.org")
                                     ("cttim40rtokh1rnr2msli7eusf8v7lls@import.calendar.google.com" . "shifts.org")
                                     ("ppdgco17tdub1thuaeqq402c0n0s9nen@import.calendar.google.com" . "office-365.org")
                                     )))

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
  (add-to-list 'org-agenda-files (concat org-directory "calendars/"))
  )


(require 'org-download)
(add-hook 'dired-mode-hook 'org-download-enable) ;; Drag-and-drop to `dired`
(add-hook 'org-mode-hook 'org-download-enable)
(setq-default org-download-image-dir "./.images/")
(setq-default org-download-heading-lvl nil)

(add-hook! '(c-mode c++-mode)
  (c-set-style "user")
  (after! lsp-mode
    (setq! lsp-ui-sideline-show-code-actions nil))
  )

;; (map! :map '(c-mode-map c++-mode-map)
;;       :leader
;;       (:prefix-map ("c" . "code")
;;        :desc "Clang format buffer" "f" #'clang-format-buffer))

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
 '("/main\\.c\\(?:c\\|pp\\)$" :ignore t)
 '("/win32_\\.c\\(?:c\\|pp\\)$" :ignore t)
 '("\\.c\\(?:c\\|pp\\)$" :ignore t)
 '("\\.h\\(?:h\\|pp\\|xx\\)$" :trigger "__pragma-once" :mode c++-mode)
 '("\\.h$" :ignore t)
 '("/Makefile$" :ignore t)
 )

(map! :after lsp-mode
      :map prog-mode-map
      :leader
      (:prefix-map ("c" . "code")
       :desc "LSP format buffer" "f" #'lsp-format-buffer))

(map! :leader
      (:prefix-map ("t" . "toggle")
       :desc "Doom modeline" "m" #'doom-modeline-mode
       :desc "Vimish fold" "z" 'vimish-fold-toggle
       ))

(map! :after projectile
      :leader
      (:prefix-map ("s" . "search")
       :desc "Replace in project" "R" 'projectile-replace-regexp))

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

(setq mu4e-get-mail-command "mbsync -c ~/.config/mu4e/mbsyncrc -a"
      mu4e-update-interval  300
      message-send-mail-function 'smtpmail-send-it
      mu4e-maildir-shortcuts
      '(("/epita-mail/Inbox"  . ?i)
        ("/epita-mail/Sent"   . ?s)
        ("/epita-mail/Drafts" . ?d)
        ("/epita-mail/Trash"  . ?t)))

(remove-hook! 'mu4e-compose-pre-hook #'org-msg-mode)

(set-email-account! "epita"
                    '(
                      (mu4e-sent-folder         . "/epita-mail/Sent")
                      (mu4e-drafts-folder       . "/epita-mail/Drafts")
                      (mu4e-trash-folder        . "/epita-mail/Trash")
                      (smtpmail-smtp-server     . "smtp.office365.com")
                      (smtpmail-smtp-service    . 587)
                      (smtpmail-stream-type     . starttls)
                      (user-mail-address        . "tristan.floch@epita.fr")
                      )
                    t)

(defconst message-cite-style-custom
  '((message-cite-function          'message-cite-original-without-signature)
    (message-citation-line-function 'message-insert-formatted-citation-line)
    (message-cite-reply-position    'traditional)
    (message-yank-prefix            "> ")
    (message-yank-cited-prefix      "> ")
    (message-yank-empty-prefix      ">")
    (message-citation-line-format   "%f writes:"))
  "Message citation style used for email. Use with `message-cite-style'.")

(after! message
  (setq message-cite-style message-cite-style-custom
        message-cite-function          'message-cite-original-without-signature
        message-citation-line-function 'message-insert-formatted-citation-line
        message-cite-reply-position    'traditional
        message-yank-prefix            "> "
        message-yank-cited-prefix      "> "
        message-yank-empty-prefix      ">"
        message-citation-line-format   "%f writes:"))

(after! mu4e
  (setq mu4e-compose-format-flowed nil
        mu4e-view-use-gnus t))

(setq gnus-fetch-old-headers t) ;; show unread groups
(setq gnus-select-method '(nntp "news.cri.epita.fr"))
(map! :leader
      (:prefix-map ("o" . "open")
       :desc "Gnus" "g" #'gnus))

(setq auth-sources '("~/.authinfo.gpg"))

(remove-hook 'doom-first-input-hook #'evil-snipe-mode)
(remove-hook 'text-mode-hook #'spell-fu-mode)
;; (add-hook 'nix-mode-hook #'lsp) ; make opening nix files laggy
(remove-hook! 'text-mode-hook #'spell-fu-mode)

(load! "lisp/tiger.el")
(autoload 'tiger-mode "tiger" "Load tiger-mode" t)

(load! "lisp/kconfig.el")

(add-to-list 'auto-mode-alist '("\\.ti[gh]$" . tiger-mode))
(add-to-list 'auto-mode-alist '("\\.rasi\\'" . css-mode))
(add-to-list 'auto-mode-alist '("\\.ll\\'" . bison-mode))
(add-to-list 'auto-mode-alist '("\\.yy\\'" . bison-mode))

(add-hook 'emacs-lisp-mode-hook #'aggressive-indent-mode)

;; (after! hydra
;;   (defhydra+ my/hydra-splitter
;;     ("h" hydra-move-splitter-left)
;;     ("j" hydra-move-splitter-down)
;;     ("k" hydra-move-splitter-up)
;;     ("l" hydra-move-splitter-right)
;;     ))

;; (defhydra hydra-splitter (global-map "C-M-s")
;; "splitter"
;; ("h" hydra-move-splitter-left)
;; ("j" hydra-move-splitter-down)
;; ("k" hydra-move-splitter-up)
;; ("l" hydra-move-splitter-right))

;; (map! :leader
;;       (:prefix-map ("w" . "window")
;;        :desc "Navigation" "SPC" '+hydra/window-nav/body))
