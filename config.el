;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'seoul256)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
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
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
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
  ;;(defalias 'only 'zygospore-toggle-delete-other-windows))
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
  (use-package! evil-expat)
  (define-key evil-motion-state-map "j" 'evil-next-visual-line)
  (define-key evil-motion-state-map "k" 'evil-previous-visual-line))

(after! evil-escape
  (setq-default evil-escape-key-sequence "kj"))


;; prettier installed by typing: npm -g install prettier
(when (executable-find "prettier")
  (use-package! prettier-js)
  (setq prettier-js-width-mode nil)
  ;;(setq prettier-js-args '("--single-quote" "--bracket-spacing"))
  (setq prettier-js-args '("--bracket-spacing"))
  (add-hook 'js-mode-hook 'prettier-js-mode)
  (add-hook 'js2-mode-hook 'prettier-js-mode)
  (add-hook 'typescript-mode-hook 'prettier-js-mode)
  
  (add-hook 'web-mode-hook  ;; for TSX files
            (lambda ()
              (when (string-equal "tsx" (file-name-extension buffer-file-name))
                (prettier-js-mode)
                (add-hook 'before-save-hook 'prettier-js nil 'make-it-local))))

  ;; Custom keybinding for manual formatting
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


(defalias 'fs 'evil-write-all)
(defalias 'pf 'projectile-find-file)

;; https://www.reddit.com/r/emacs/comments/hsb0ma/my_own_stupid_spacemacs_clone/
;; https://lccambiaghi.github.io/.doom.d/readme.html
;;(general-auto-unbind-keys)
;;(map! :leader
;;      ;;:desc "M-x"                   :n "SPC" #'counsel-M-x
;;      ;;:desc "ivy resume" :n ":" #'ivy-resume
;;      ;;:desc "Async shell command"   :n "!"   #'async-shell-command
;;      ;;:desc "Toggle eshell"         :n "'"   #'+eshell/toggle
;;      ;;:desc "Open dir in iTerm" :n "oi" #'+macos/open-in-iterm
;;      ;;:desc "Neotree toggle" :n "nt" #'neotree-toggle
;;      ;;:desc "Neotree find" :n "nf" #'neotree-find
;;      ;;;:desc "ace-jump-mode" :n "aj" #'ace-jump-mode
;;      ;;:desc "evil-write-all" :n "fs" #'evil-write-all
;;      :desc "projectile-find-file" :n "pf" #'projectile-find-file
;;
;;      ;; (:desc "windows" :prefix "w"
;;      ;;   :desc "popup raise" :n "p" #'+popup/raise)
;;
;;      ;; (:desc "project" :prefix "p"
;;      ;;   :desc "Eshell"               :n "'" #'projectile-run-eshell
;;      ;;   :desc "Terminal" :n "t" #'projectile-run-vterm )
;;      )
(map! :leader
      "SPC" #'execute-extended-command)

;; popup dashboard, overwrite what which-key displays
(after! which-key
  (which-key-add-key-based-replacements
    "SPC SPC" "M-x execute-extended-command"
    "SPC :" "M-x execute-extended-command"))

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


(use-package! python-black
  :demand t
  :after python
  :config
  (add-hook! 'python-mode-hook #'python-black-on-save-mode)
)

(use-package! evil-matchit
  :demand t
  :config
  (global-evil-matchit-mode 1)
)

;; (setq doom-font (font-spec :family "JetBrains Mono" :size 24)
;;       doom-big-font (font-spec :family "JetBrains Mono" :size 36)
;;       doom-variable-pitch-font (font-spec :family "Overpass" :size 24)
;;       doom-serif-font (font-spec :family "IBM Plex Mono" :weight 'light))

;;(setq doom-font (font-spec :family "Attribute Mono" :size 20))
;;(unless (find-font doom-font)
;;  (setq doom-font (font-spec :family "FuraCode Nerd Font" :size 20)))

(after! vertico
  (setq completion-styles '(orderless)
        orderless-matching-styles '(orderless-flex)))

(set-face-attribute 'default nil :height 140)

;; Set the default Emacs frame size
(setq default-frame-alist
      '((width  . 160)  ; character
        (height . 48))) ; lines

;; Set default position
(add-to-list 'default-frame-alist '(left . 0))
(add-to-list 'default-frame-alist '(top . 0))

(menu-bar-mode -1)

(when (display-graphic-p)
  (add-hook 'after-init-hook 'minimap-mode))
