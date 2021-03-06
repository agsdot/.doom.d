;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "John Doe"
      user-mail-address "john@doe.com")

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
;; (setq doom-theme 'doom-one)
;; (setq doom-theme 'doom-material)
;; (setq doom-theme 'doom-tomorrow-night)
(setq doom-theme 'seoul256)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

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
;;
;;
;;
(setq confirm-kill-emacs nil)

;; http://stackoverflow.com/questions/34531831/highlighting-trailing-whitespace-in-emacs-without-changing-character
(setq-default show-trailing-whitespace t)
(setq whitespace-style (quote (spaces tabs newline space-mark tab-mark newline-mark)))
(setq whitespace-display-mappings
  '((space-mark 32 [183] [46])
    (tab-mark 9 [9655 9] [92 9])))

;; http://evgeni.io/posts/reversable-ex-only-command/
(use-package! zygospore
  :commands zygospore-toggle-delete-other-windows
  :init
  ;; :config
  ;; for use in counsel-M-x / smex
  (defalias 'only 'zygospore-toggle-delete-other-windows)
  (evil-ex-define-cmd "only" 'zygospore-toggle-delete-other-windows))

(use-package! buffer-move)

(use-package! ace-jump-mode)

;; https://github.com/yasuyk/web-beautify
;; js-beautify installed by typing: npm -g install js-beautify
;; beautify js AND html AND css
(when (executable-find "js-beautify")
  (use-package! web-beautify))

(after! js2-mode
  (add-hook 'js2-mode-hook
    (lambda () (setq js2-basic-offset 2))))

(after! evil
  (define-key evil-motion-state-map "j" 'evil-next-visual-line)
  (define-key evil-motion-state-map "k" 'evil-previous-visual-line))

(after! evil-escape
  (setq-default evil-escape-key-sequence "kj"))


;; prettier installed by typing: npm -g install prettier
(when (executable-find "prettier")
  (use-package! prettier-js)
  (setq prettier-js-width-mode nil)
  (setq prettier-js-args '("--single-quote" "--bracket-spacing"))
  (add-hook 'js-mode-hook 'prettier-js-mode)
  (add-hook 'js2-mode-hook 'prettier-js-mode)
  ;; https://superuser.com/questions/684352/add-keybinding-to-js-mode-javascript-mode-in-emacs
  ;; js-mode loads js.el file, so eval-after-load 'js to bind to js-mode-map
  (eval-after-load 'js
    '(define-key js-mode-map (kbd "C-c j") 'prettier-js))
  (eval-after-load 'js2-mode
    '(define-key js2-mode-map (kbd "C-c j") 'prettier-js)))

;;http://www.accidentalrebel.com/posts/minifying-buffer-contents-in-emacs.html
(defun arebel-minify-buffer-contents()
  "Minifies the buffer contents by removing whitespaces."
  (interactive)
  (delete-whitespace-rectangle (point-min) (point-max))
  (mark-whole-buffer)
  (goto-char (point-min))
  (while (search-forward "\n" nil t) (replace-match "" nil t)))

;; for use in M-x
(defalias 'aj 'ace-jump-mode)

(defalias 'gst 'magit-status)
(defalias 'st 'magit-status)

(defalias 'nf 'neotree-find)
(defalias 'nt 'neotree-toggle)

(defalias 'w 'evil-write)
(defalias 'wq 'evil-save-and-close)
(defalias 'wq! 'evil-save-and-close)
(defalias 'q 'evil-quit)
(defalias 'q! 'evil-quit)


;; https://www.reddit.com/r/emacs/comments/hsb0ma/my_own_stupid_spacemacs_clone/
;; https://lccambiaghi.github.io/.doom.d/readme.html
(general-auto-unbind-keys)
(map! :leader
      :desc "M-x"                   :n "SPC" #'counsel-M-x
      :desc "ivy resume" :n ":" #'ivy-resume
      :desc "Async shell command"   :n "!"   #'async-shell-command
      :desc "Toggle eshell"         :n "'"   #'+eshell/toggle
      :desc "Open dir in iTerm" :n "oi" #'+macos/open-in-iterm
      :desc "Neotree toggle" :n "nt" #'neotree-toggle
      :desc "Neotree find" :n "nf" #'neotree-find
      :desc "ace-jump-mode" :n "aj" #'ace-jump-mode

      (:desc "windows" :prefix "w"
        :desc "popup raise" :n "p" #'+popup/raise)

      (:desc "project" :prefix "p"
        :desc "Eshell"               :n "'" #'projectile-run-eshell
        :desc "Terminal" :n "t" #'projectile-run-vterm ))

;; https://lccambiaghi.github.io/.doom.d/readme.html
(setq-default
 uniquify-buffer-name-style 'forward              ; Uniquify buffer names
 window-combination-resize t                      ; take new window space from all other windows (not just current)
 x-stretch-cursor t)                              ; Stretch cursor to the glyph width

(setq undo-limit 80000000                         ; Raise undo-limit to 80Mb
      evil-want-fine-undo t                       ; By default while in insert all changes are one big blob. Be more granular
      ;; auto-save-default t                         ; Nobody likes to loose work, I certainly don't
      inhibit-compacting-font-caches t)           ; When there are lots of glyphs, keep them in memory

(delete-selection-mode 1)                         ; Replace selection when inserting text
;; (global-subword-mode 1)                           ; Iterate through CamelCase words
