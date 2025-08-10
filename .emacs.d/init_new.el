(setq inhibit-splash-screen t)
(setq use-dialog-box t)                 ; only for mouse events
(setq use-file-dialog nil)

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name
        "straight/repos/straight.el/bootstrap.el"
        (or (bound-and-true-p straight-base-dir)
            user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; (straight-use-package
;;  '(melpa :type git :host github
;;          :repo "melpa/melpa"
;;          :files ("recipes/*")))

(setq package-enable-at-startup nil)

(straight-use-package 'use-package)

(setq ring-bell-function 'ignore)

(scroll-bar-mode -1)
(tool-bar-mode -1)
;; (tooltip mode -1)
(menu-bar-mode -1)
(winner-mode 1)
(repeat-mode t)
(recentf-mode 1)
(pixel-scroll-precision-mode 1)
(global-display-line-numbers-mode 1)

(use-package modus-themes
  :ensure t
  :config
  ;; Add all your customizations prior to loading the themes
  (setq modus-themes-italic-constructs nil
        modus-themes-bold-constructs nil
	modus-themes-mixed-fonts t
      modus-themes-variable-pitch-ui t
      modus-themes-custom-auto-reload t
      modus-themes-org-blocks 'tinted-background ; {nil,'gray-background,'tinted-background}
      modus-themes-disable-other-themes t
	)

  ;; Maybe define some palette overrides, such as by using our presets
  (setq modus-themes-common-palette-overrides
        modus-themes-preset-overrides-intense)

  ;; Load the theme of your choice.
  (load-theme 'modus-vivendi-tinted t)

  (define-key global-map (kbd "<f5>") #'modus-themes-toggle))


(set-face-attribute 'default nil :font "Adwaita Mono" :height 120)
(setq blink-cursor-mode nil)

(use-package spacious-padding
  :ensure t)

;; These are the default values, but I keep them here for visibility.
(setq spacious-padding-widths
      '( :internal-border-width 15
         :header-line-width 4
         :mode-line-width 6
         :tab-width 4
         :right-divider-width 30
         :scroll-bar-width 8
         :fringe-width 12))

;; Read the doc string of `spacious-padding-subtle-mode-line' as it
;; is very flexible and provides several examples.
(setq spacious-padding-subtle-frame-lines
      `( :mode-line-active 'default
         :mode-line-inactive vertical-border))

(spacious-padding-mode 1)

;; Set a key binding if you need to toggle spacious padding.
(define-key global-map (kbd "<f8>") #'spacious-padding-mode)

(use-package beframe
  :ensure t)


(beframe-mode 1)

;; Bind Beframe commands to a prefix key, such as C-c b:
(define-key global-map (kbd "C-c b") #'beframe-prefix-map)
;; OR use the transient instead of the prefix map:
(define-key global-map (kbd "C-c b") #'beframe-transient)


(defun consult-beframe-buffer-list (&optional frame)
  "Return the list of buffers from `beframe-buffer-names' sorted by visibility.
With optional argument FRAME, return the list of buffers of FRAME."
  (beframe-buffer-list frame :sort #'beframe-buffer-sort-visibility))

(setq consult-buffer-list #'consult-beframe-buffer-list)



(use-package pulsar
  :ensure t)

(setq pulsar-pulse t)
(setq pulsar-delay 0.055)
(setq pulsar-iterations 10)
(setq pulsar-face 'pulsar-magenta)
(setq pulsar-highlight-face 'pulsar-yellow)

(pulsar-global-mode 1)

;; OR use the local mode for select mode hooks

(dolist (hook '(org-mode-hook emacs-lisp-mode-hook))
  (add-hook hook #'pulsar-mode))

;; pulsar does not define any key bindings.  This is just a sample that
;; respects the key binding conventions.  Evaluate:
;;
;;     (info "(elisp) Key Binding Conventions")
;;
;; The author uses C-x l for `pulsar-pulse-line' and C-x L for
;; `pulsar-highlight-line'.
;;
;; You can replace `pulsar-highlight-line' with the command
;; `pulsar-highlight-dwim'.
(let ((map global-map))
  (define-key map (kbd "C-c h p") #'pulsar-pulse-line)
  (define-key map (kbd "C-c h h") #'pulsar-highlight-line))


(add-hook 'minibuffer-setup-hook #'pulsar-pulse-line)

;; integration with the `consult' package:
(add-hook 'consult-after-jump-hook #'pulsar-recenter-top)
(add-hook 'consult-after-jump-hook #'pulsar-reveal-entry)

;; integration with the built-in `imenu':
(add-hook 'imenu-after-jump-hook #'pulsar-recenter-top)
(add-hook 'imenu-after-jump-hook #'pulsar-reveal-entry)


(use-package mct
  :ensure t
  :config
  (setq mct-completion-window-size (cons #'mct-frame-height-third 1))
  (setq mct-remove-shadowed-file-names t) ; works when `file-name-shadow-mode' is enabled
  (setq mct-hide-completion-mode-line t)
  (setq mct-completing-read-multiple-indicator t)
  (setq mct-minimum-input 3)
  (setq mct-live-completion t)
  (setq mct-live-update-delay 0.6)

  ;; This is for commands or completion categories that should always pop
  ;; up the completions' buffer.  It circumvents the default method of
  ;; waiting for some user input (see `mct-minimum-input') before
  ;; displaying and updating the completions' buffer.
  (setq mct-completion-passlist
        '(;; Some commands
          select-frame-by-name
          Info-goto-node
          Info-index
          Info-menu
          vc-retrieve-tag
          ;; Some completion categories
          consult-buffer
          consult-location
          embark-keybinding
          imenu
          file
          project-file
          buffer
          kill-ring))

  ;; The blocklist follows the same principle as the passlist, except it
  ;; disables live completions altogether.
  (setq mct-completion-blocklist nil)

  ;; This is the default value but I am keeping it here for visibility.
  (setq mct-sort-by-command-or-category
        '((file . mct-sort-by-directory-then-by-file)
          ((magit-checkout vc-retrieve-tag) . mct-sort-by-alpha-then-by-length)
          ((kill-ring imenu consult-location Info-goto-node Info-index Info-menu) . nil) ; no sorting
          (t . mct-sort-by-history)))

  (mct-mode 0))

;;; General settings for the minibuffer

(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion))))
  )

;; (setq completion-styles '(basic substring initials flex partial-completion orderless))
(setq completion-category-defaults nil)
(setq completion-category-overrides
      '((file (styles . (basic partial-completion initials substring)))))

(setq completion-cycle-threshold 2)
(setq completion-ignore-case t)
(setq completion-show-inline-help nil)

(setq completions-detailed t)

(setq enable-recursive-minibuffers t)
(setq minibuffer-eldef-shorten-default t)

(setq read-buffer-completion-ignore-case t)
(setq read-file-name-completion-ignore-case t)

(setq resize-mini-windows t)
(setq minibuffer-eldef-shorten-default t)

(file-name-shadow-mode 1)
(minibuffer-depth-indicate-mode 1)
(minibuffer-electric-default-mode 1)

;; Do not allow the cursor in the minibuffer prompt
(setq minibuffer-prompt-properties
      '(read-only t cursor-intangible t face minibuffer-prompt))

(add-hook 'minibuffer-setup-hook #'cursor-intangible-mode)

;;; Minibuffer history

(use-package savehist
  :ensure t
  :config
  (savehist-mode 1))

(setq backup-directory-alist `(("." . "~/.saves")))


;; https://sachachua.com/dotemacs/
(defun my/smarter-move-beginning-of-line (arg)
  "Move point back to indentation of beginning of line.

      Move point to the first non-whitespace character on this line.
      If point is already there, move to the beginning of the line.
      Effectively toggle between the first non-whitespace character and
      the beginning of the line.

      If ARG is not nil or 1, move forward ARG - 1 lines first.  If
      point reaches the beginning or end of the buffer, stop there."
  (interactive "^p")
  (setq arg (or arg 1))

  ;; Move lines first
  (when (/= arg 1)
    (let ((line-move-visual nil))
      (forward-line (1- arg))))

  (let ((orig-point (point)))
    (back-to-indentation)
    (when (= orig-point (point))
      (move-beginning-of-line 1))))

;; remap C-a to `smarter-move-beginning-of-line'
(global-set-key [remap move-beginning-of-line]
                'my/smarter-move-beginning-of-line)

(use-package org-modern
  :ensure t)

(with-eval-after-load 'org (global-org-modern-mode))


;; Example configuration for Consult
(use-package consult
  :ensure t
  ;; Replace bindings. Lazily loaded by `use-package'.
  :bind (;; C-c bindings in `mode-specific-map'
         ("C-c M-x" . consult-mode-command)
         ("C-c h" . consult-history)
         ("C-c k" . consult-kmacro)
         ("C-c m" . consult-man)
         ("C-c i" . consult-info)
         ([remap Info-search] . consult-info)
         ;; C-x bindings in `ctl-x-map'
         ("C-x M-:" . consult-complex-command)     ;; orig. repeat-complex-command
         ("C-x b" . consult-buffer)                ;; orig. switch-to-buffer
         ("C-x 4 b" . consult-buffer-other-window) ;; orig. switch-to-buffer-other-window
         ("C-x 5 b" . consult-buffer-other-frame)  ;; orig. switch-to-buffer-other-frame
         ("C-x t b" . consult-buffer-other-tab)    ;; orig. switch-to-buffer-other-tab
         ("C-x r b" . consult-bookmark)            ;; orig. bookmark-jump
         ("C-x p b" . consult-project-buffer)      ;; orig. project-switch-to-buffer
         ;; Custom M-# bindings for fast register access
         ("M-#" . consult-register-load)
         ("M-'" . consult-register-store)          ;; orig. abbrev-prefix-mark (unrelated)
         ("C-M-#" . consult-register)
         ;; Other custom bindings
         ("M-y" . consult-yank-pop)                ;; orig. yank-pop
         ;; M-g bindings in `goto-map'
         ("M-g e" . consult-compile-error)
         ("M-g f" . consult-flymake)               ;; Alternative: consult-flycheck
         ("M-g g" . consult-goto-line)             ;; orig. goto-line
         ("M-g M-g" . consult-goto-line)           ;; orig. goto-line
         ("M-g o" . consult-outline)               ;; Alternative: consult-org-heading
         ("M-g m" . consult-mark)
         ("M-g k" . consult-global-mark)
         ("M-g i" . consult-imenu)
         ("M-g I" . consult-imenu-multi)
         ;; M-s bindings in `search-map'
         ("M-s d" . consult-find)                  ;; Alternative: consult-fd
         ("M-s c" . consult-locate)
         ("M-s g" . consult-grep)
         ("M-s G" . consult-git-grep)
         ("M-s r" . consult-ripgrep)
         ("M-s l" . consult-line)
         ("M-s L" . consult-line-multi)
         ("M-s k" . consult-keep-lines)
         ("M-s u" . consult-focus-lines)
         ;; Isearch integration
         ("M-s e" . consult-isearch-history)
         :map isearch-mode-map
         ("M-e" . consult-isearch-history)         ;; orig. isearch-edit-string
         ("M-s e" . consult-isearch-history)       ;; orig. isearch-edit-string
         ("M-s l" . consult-line)                  ;; needed by consult-line to detect isearch
         ("M-s L" . consult-line-multi)            ;; needed by consult-line to detect isearch
         ;; Minibuffer history
         :map minibuffer-local-map
         ("M-s" . consult-history)                 ;; orig. next-matching-history-element
         ("M-r" . consult-history))                ;; orig. previous-matching-history-element

  ;; Enable automatic preview at point in the *Completions* buffer. This is
  ;; relevant when you use the default completion UI.
  :hook (completion-list-mode . consult-preview-at-point-mode)

  ;; The :init configuration is always executed (Not lazy)
  :init

  ;; Tweak the register preview for `consult-register-load',
  ;; `consult-register-store' and the built-in commands.  This improves the
  ;; register formatting, adds thin separator lines, register sorting and hides
  ;; the window mode line.
  (advice-add #'register-preview :override #'consult-register-window)
  (setq register-preview-delay 0.5)

  ;; Use Consult to select xref locations with preview
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)

  ;; Configure other variables and modes in the :config section,
  ;; after lazily loading the package.
  :config

  ;; Optionally configure preview. The default value
  ;; is 'any, such that any key triggers the preview.
  ;; (setq consult-preview-key 'any)
  ;; (setq consult-preview-key "M-.")
  ;; (setq consult-preview-key '("S-<down>" "S-<up>"))
  ;; For some commands and buffer sources it is useful to configure the
  ;; :preview-key on a per-command basis using the `consult-customize' macro.
  (consult-customize
   consult-theme :preview-key '(:debounce 0.2 any)
   consult-ripgrep consult-git-grep consult-grep consult-man
   consult-bookmark consult-recent-file consult-xref
   consult--source-bookmark consult--source-file-register
   consult--source-recent-file consult--source-project-recent-file
   ;; :preview-key "M-."
   :preview-key '(:debounce 0.4 any))

  ;; Optionally configure the narrowing key.
  ;; Both < and C-+ work reasonably well.
  (setq consult-narrow-key "<") ;; "C-+"

  ;; Optionally make narrowing help available in the minibuffer.
  ;; You may want to use `embark-prefix-help-command' or which-key instead.
  ;; (keymap-set consult-narrow-map (concat consult-narrow-key " ?") #'consult-narrow-help)
)


(use-package marginalia
  :ensure t
  :config
  (marginalia-mode))

(use-package embark
  :ensure t

  :bind
  (("C-." . embark-act)         ;; pick some comfortable binding
   ("C-;" . embark-dwim)        ;; good alternative: M-.
   ("C-h B" . embark-bindings)) ;; alternative for `describe-bindings'

  :init

  ;; Optionally replace the key help with a completing-read interface
  (setq prefix-help-command #'embark-prefix-help-command)

  ;; Show the Embark target at point via Eldoc. You may adjust the
  ;; Eldoc strategy, if you want to see the documentation from
  ;; multiple providers. Beware that using this can be a little
  ;; jarring since the message shown in the minibuffer can be more
  ;; than one line, causing the modeline to move up and down:

  ;; (add-hook 'eldoc-documentation-functions #'embark-eldoc-first-target)
  ;; (setq eldoc-documentation-strategy #'eldoc-documentation-compose-eagerly)

  ;; Add Embark to the mouse context menu. Also enable `context-menu-mode'.
  ;; (context-menu-mode 1)
  ;; (add-hook 'context-menu-functions #'embark-context-menu 100)

  :config

  ;; Hide the mode line of the Embark live/completions buffers
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))

;; Consult users will also want the embark-consult package.
(use-package embark-consult
  :ensure t ; only need to install it, embark loads it after consult if found
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

(use-package vertico
  :straight t
  :custom
  ;; (vertico-scroll-margin 0) ;; Different scroll margin
  (vertico-count 12) ;; Show more candidates
  (vertico-resize nil) ;; Grow and shrink the Vertico minibuffer
  (vertico-cycle t) ;; Enable cycling for `vertico-next/previous'
  :init
  (vertico-mode))

(vertico-multiform-mode 1)

(setq vertico-multiform-commands
      '(
	;; (consult-line buffer)           ; Use buffer mode for consult-line
	(consult-buffer flat)
        (consult-imenu reverse)         ; Use reverse mode for consult-imenu
        (execute-extended-command flat) ; Use flat mode for M-x
        (consult-locate buffer)         ; Use buffer mode for consult-locate
        (project-find-file grid)        ; Use grid mode for project files
        (describe-symbol flat))        ; Use flat mode for describe-symbol
      )

(setq vertico-multiform-categories
      '((file flat)           ; Use grid for file completion
        (buffer flat)         ; Use flat for buffer switching
        (symbol flat)         ; Use flat for symbol completion
        (consult-grep buffer) ; Use buffer for grep results
        ;; (imenu buffer)       ; Use buffer for imenu
	))

;; (setq consult-customize
;;  consult-ripgrep :preview-key nil
;;  consult-git-grep :preview-key nil
;;  consult-grep :preview-key nil
;;  consult-bookmark :preview-key nil
;;  consult-recent-file :preview-key nil
;;  consult-xref :preview-key nil
;;  consult-buffer :preview-key nil)


(use-package projectile
  :ensure t)

(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)

;; https://systemcrafters.net/emacs-from-scratch/build-your-own-ide-with-lsp-mode/
(use-package lsp-mode
  :straight t
  :commands (lsp lsp-deferred)
  :init
  (setq lsp-keymap-prefix "C-c l")  ;; Or 'C-l', 's-l'
  :config
  (lsp-enable-which-key-integration t))

(use-package company
  :straight t
  :after lsp-mode
  :hook (lsp-mode . company-mode)
  :bind (:map company-active-map
         ("<tab>" . company-complete-selection))
        (:map lsp-mode-map
         ("<tab>" . company-indent-or-complete-common))
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.0)
)

;; (use-package corfu
;;   :straight t
;;   ;; Optional customizations
;;   :custom
;;   (corfu-cycle t)                ;; Enable cycling for `corfu-next/previous'
;;   ;; (corfu-quit-at-boundary nil)   ;; Never quit at completion boundary
;;   ;; (corfu-quit-no-match nil)      ;; Never quit, even if there is no match
;;   ;; (corfu-preview-current nil)    ;; Disable current candidate preview
;;   (corfu-preselect 'prompt)      ;; Preselect the prompt
;;   ;; (corfu-on-exact-match nil)     ;; Configure handling of exact matches

;;   ;; Enable Corfu only for certain modes. See also `global-corfu-modes'.
;;   ;; :hook ((prog-mode . corfu-mode)
;;   ;;        (shell-mode . corfu-mode)
;;   ;;        (eshell-mode . corfu-mode))

;;   :init

;;   ;; Recommended: Enable Corfu globally.  Recommended since many modes provide
;;   ;; Capfs and Dabbrev can be used globally (M-/).  See also the customization
;;   ;; variable `global-corfu-modes' to exclude certain modes.
;;   (global-corfu-mode)

;;   ;; Enable optional extension modes:
;;   (corfu-history-mode)
;;   ;; (corfu-popupinfo-mode)
;;   )

;; ;; A few more useful configurations...
;; (use-package emacs
;;   :custom
;;   ;; TAB cycle if there are only few candidates
;;   ;; (completion-cycle-threshold 3)

;;   ;; Enable indentation+completion using the TAB key.
;;   ;; `completion-at-point' is often bound to M-TAB.
;;   (tab-always-indent 'complete)

;;   ;; Emacs 30 and newer: Disable Ispell completion function.
;;   ;; Try `cape-dict' as an alternative.
;;   (text-mode-ispell-word-completion nil)

;;   ;; Hide commands in M-x which do not apply to the current mode.  Corfu
;;   ;; commands are hidden, since they are not used via M-x. This setting is
;;   ;; useful beyond Corfu.
;;   (read-extended-command-predicate #'command-completion-default-include-p))

;; ;; Enable auto completion and configure quitting
;; (setq corfu-auto t
;;       corfu-quit-no-match 'separator) ;; or t

;; (setq lsp-completion-provider :none)
;; (defun corfu-lsp-setup ()
;;   (setq-local completion-styles '(orderless)
;;               completion-category-defaults nil))
;; (add-hook 'lsp-mode-hook #'corfu-lsp-setup)

;; https://www.ovistoica.com/blog/2024-7-05-modern-emacs-typescript-web-tsx-config#orgc542f94

(use-package typescript-mode
  :straight t
  :mode "\\.ts\\'"
  :hook (typescript-mode . lsp-deferred)
  :config
  (setq typescript-indent-level 2))

(setq read-process-output-max (* 10 1024 1024))
(setq gc-cons-threshold 200000000)

;; (use-package treesit
;;   ;; :mode (("\\.tsx\\'" . tsx-ts-mode))
;;   :preface
;;   (defun mp-setup-install-grammars ()
;;     "Install Tree-sitter grammars if they are absent."
;;     (interactive)
;;     (dolist (grammar
;;              ;; Note the version numbers. These are the versions that
;;              ;; are known to work with Combobulate *and* Emacs.
;;              '((css . ("https://github.com/tree-sitter/tree-sitter-css" "v0.20.0"))
;;                (go . ("https://github.com/tree-sitter/tree-sitter-go" "v0.20.0"))
;;                (html . ("https://github.com/tree-sitter/tree-sitter-html" "v0.20.1"))
;;                (javascript . ("https://github.com/tree-sitter/tree-sitter-javascript" "v0.20.1" "src"))
;;                (json . ("https://github.com/tree-sitter/tree-sitter-json" "v0.20.2"))
;;                (markdown . ("https://github.com/ikatyang/tree-sitter-markdown" "v0.7.1"))
;;                (python . ("https://github.com/tree-sitter/tree-sitter-python" "v0.20.4"))
;;                (rust . ("https://github.com/tree-sitter/tree-sitter-rust" "v0.21.2"))
;;                (toml . ("https://github.com/tree-sitter/tree-sitter-toml" "v0.5.1"))
;;                (tsx . ("https://github.com/tree-sitter/tree-sitter-typescript" "v0.20.3" "tsx/src"))
;;                (typescript . ("https://github.com/tree-sitter/tree-sitter-typescript" "v0.20.3" "typescript/src"))
;;                (yaml . ("https://github.com/ikatyang/tree-sitter-yaml" "v0.5.0"))))
;;       (add-to-list 'treesit-language-source-alist grammar)
;;       ;; Only install `grammar' if we don't already have it
;;       ;; installed. However, if you want to *update* a grammar then
;;       ;; this obviously prevents that from happening.
;;       (unless (treesit-language-available-p (car grammar))
;;         (treesit-install-language-grammar (car grammar)))))

;;   ;; Optional. Combobulate works in both xxxx-ts-modes and
;;   ;; non-ts-modes.

;;   ;; You can remap major modes with `major-mode-remap-alist'. Note
;;   ;; that this does *not* extend to hooks! Make sure you migrate them
;;   ;; also
;;   (dolist (mapping
;;            '((python-mode . python-ts-mode)
;;              (css-mode . css-ts-mode)
;;              (typescript-mode . typescript-ts-mode)
;;              (js2-mode . js-ts-mode)
;;              (bash-mode . bash-ts-mode)
;;              (conf-toml-mode . toml-ts-mode)
;;              (go-mode . go-ts-mode)
;;              (css-mode . css-ts-mode)
;;              (json-mode . json-ts-mode)
;;              (js-json-mode . json-ts-mode)))
;;     (add-to-list 'major-mode-remap-alist mapping))
;;   :config
;;   (mp-setup-install-grammars)
;;   ;; Do not forget to customize Combobulate to your liking:
;;   ;;
;;   ;;  M-x customize-group RET combobulate RET
;;   ;;
;;  (use-package combobulate
;;    :custom
;;    ;; You can customize Combobulate's key prefix here.
;;    ;; Note that you may have to restart Emacs for this to take effect!
;;    (combobulate-key-prefix "C-c o")
;;    :hook ((prog-mode . combobulate-mode))
;;    ;; Amend this to the directory where you keep Combobulate's source
;;    ;; code.
;;    :load-path ("/home/mars/packages/combobulate")))


(use-package multiple-cursors
  :straight t)

(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

(add-to-list 'display-buffer-alist
             '("\\*grep\\*"
               (display-buffer-in-side-window)
               (side . left)
               (window-width . 40)))
