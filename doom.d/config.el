;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Erik Jenner"
      user-mail-address "erik.jenner99@gmail.com")

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
(setq doom-font (font-spec :family "Source Code Pro" :size 22 :weight 'semi-light)
      doom-variable-pitch-font (font-spec :family "sans" :size 15))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-solarized-light)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Documents/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'visual)


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

;; I think org-special-block-extras needs this but doesn't require it itself?
;; Without this line, I get a "void-function first" error
(require 'cl)

(defun switch-to-last-buffer ()
  "Switch to the last viewed buffer.
Call repeatedly to toggle between two buffers."
  (interactive)
  (switch-to-buffer (other-buffer (current-buffer))))

(map! :leader
      :desc "Previous buffer"   "TAB"   #'switch-to-last-buffer)

;; Smooth scrolling
(setq scroll-conservatively 10000
      ;; Start scrolling 5 lines before end of screen is reached
      scroll-margin 5)

(add-to-list 'load-path "~/.doom.d/elisp")
(require 'prettify-utils)

(after! org
  ;; Make LaTeX fragments larger
  (setq org-format-latex-options (plist-put org-format-latex-options :scale 1.7)
        ;; highlighting latex is nice but slows org down enormously on large files
        org-highlight-latex-and-related nil
        ;; if an org heading as a CUSTOM_ID, use that to generate latex labels
        ;; necessary for org-ref links to headings using IDs to work correctly after export
        org-latex-prefer-user-labels t
        org-hide-emphasis-markers t
        ;; Add a CLOSED timestamp when TODO items are closed
        org-log-done 'time
        ;; Set width of inline images to 600px by default
        org-image-actual-width 600
        ;; Don't shift text with headlines
        org-adapt-indentation nil
        ;; Open org links in the same frame
        org-link-frame-setup '((file . find-file))
        org-confirm-babel-evaluate nil
        org-src-preserve-indentation t
        ;; No extra indentation in src blocks
        org-edit-src-content-indentation 0
        org-export-allow-bind-keywords t)
  (prettify-utils-add-hook org-mode
                           ("[ ]" "☐")
                           ("[X]" "☑")
                           ("[-]" "❍"))

  (setq org-todo-keywords '((sequence "TODO(t)" "|" "DONE(d)" "CANCELLED(c)")
                            (sequence "WAIT(w)" "|" "DONE"))
        org-agenda-skip-scheduled-if-done t
        org-refile-targets '(("~/Documents/org/projects.org" :maxlevel . 1)
                             ("~/Documents/org/someday.org" :maxlevel . 2)
                             ("~/Documents/org/tickler.org" :maxlevel . 1)
                             ("~/Documents/org/short_reading.org" :maxlevel . 1)
                             ("~/Documents/org/next_actions.org" :maxlevel . 1))
        org-agenda-files (list (expand-file-name "next_actions.org" org-roam-directory)
                               (expand-file-name "tickler.org" org-roam-directory)
                               (expand-file-name "goals.org" org-roam-directory)
                               (expand-file-name "projects.org" org-roam-directory)
                               (expand-file-name "bugs.org" org-roam-directory)))

  (setq org-latex-packages-alist
        '(("" "my_style" t)))

  (setq org-latex-listings 'minted
        org-latex-pdf-process
        '("pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
          "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
          "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"))

  ;; Display list bullets as circles instead of dashes
  ;; From http://www.howardism.org/Technical/Emacs/orgmode-wordprocessor.html
  (font-lock-add-keywords 'org-mode
                          '(("^ *\\(-\\) "
                             (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

  (map! :map org-mode-map
        :n
        "t" #'org-todo))

(use-package! org-special-block-extras
  :hook (org-mode . org-special-block-extras-mode)
  :config
  (defun my-latex-export-src-blocks (src backend info)
    "Export src blocks as my custom listings env."
    (when (org-export-derived-backend-p backend 'latex)
      (replace-regexp-in-string
       "\\\\begin{minted}\\[\\]{\\([a-zA-Z]+\\)}"
       "\\\\begin{mylisting}[\\1]"
       (replace-regexp-in-string
        "\\\\end{minted}"
        "\\\\end{mylisting}"
        src))))

  (add-to-list 'org-export-filter-src-block-functions
               'my-latex-export-src-blocks)
  (org-special-block-extras-short-names)
  (defblock quote
    () ()
    "A beautifully styled blockquote."
    (format (if (equal backend 'latex)
                "\\begin{quotationb}%s\\end{quotationb}"
              "<blockquote>%s</blockquote>")
            contents)))


(setq org-roam-directory (file-name-as-directory
                          (expand-file-name "alexandria" org-directory))
      org-roam-index-file "index.org"
      org-roam-tag-sources '(prop all-directories)
      org-roam-dailies-directory "daily/"
      org-roam-dailies-capture-templates
      '(("j" "journal" entry
         #'org-roam-capture--get-point
         "* %?"
         :file-name "daily/%<%Y-%m-%d>"
         :head "#+TITLE: %<%Y-%m-%d>\n"
         :olp ("Journal"))

        ("r" "research" entry
         #'org-roam-capture--get-point
         "* %?"
         :file-name "daily/%<%Y-%m-%d>"
         :head "#+TITLE: %<%Y-%m-%d>\n"
         :olp ("Research notes"))))

(map! :leader
      :desc "Open wiki page" "j" #'org-roam-find-file)
(after! org-roam
  (setq +org-roam-open-buffer-on-find-file nil))

;;; Source: https://org-roam.discourse.group/t/org-roam-dailies-how-to-browse-through-previous-days/1018/5
(defun my/check-org-roam-buffer-p (buf)
  "Return non-nil if BUF is org-roam-buffer that can be refleshed.
It also checks the following:
- `org-roam' is indeed loaded
- BUF is visiting an Org-roam file
- org-roam-buffer exists"
  (and (functionp #'org-roam--org-roam-file-p)
       (org-roam--org-roam-file-p (buffer-file-name buf))
       (not (eq (org-roam-buffer--visibility) 'none))))

(defun my/dired-display-next-file ()
  "In Dired directory, go to the next file, and open it.
            If `org-roam-mode' is active, update the org-roam-buffer."
  (interactive)
  (dired-next-line 1)
  (let ((buf (find-file-noselect (dired-get-file-for-visit))))
    (display-buffer buf t)
    (when (my/check-org-roam-buffer-p buf)
      (with-current-buffer buf
        (setq org-roam-buffer--current buf)
        (org-roam-buffer-update)))))

(defun my/dired-display-prev-file ()
  "In Dired directory, go to the previous file, and open it.
            If `org-roam-mode' is active, update the org-roam-buffer."
  (interactive)
  (dired-previous-line 1)
  (let ((buf (find-file-noselect (dired-get-file-for-visit))))
    (display-buffer buf t)
    (when (my/check-org-roam-buffer-p buf)
      (with-current-buffer buf
        (setq org-roam--current-buffer buf)
        (org-roam-buffer-update)))))

(defun my/browse-journal ()
  "Browse journal entries using a dired sidepane."
  (interactive)
  (split-window-right)
  (dired (expand-file-name "daily" org-roam-directory))

  (dired-hide-details-mode 1)
  (map! :map dired-mode-map
        :n "j" #'my/dired-display-next-file)
  (map! :map dired-mode-map
        :n "k" #'my/dired-display-prev-file)
  (let ((fit-window-to-buffer-horizontally 'only))
    (fit-window-to-buffer)))

(after! org-fancy-priorities
  (setq org-fancy-priorities-list '("[A]" "[B]" "[C]" "[D]" "[E]")))

(after! company
  ;; Complete immediately
  (setq company-minimum-prefix-length 1
        company-idle-delay 0.2))

(after! flycheck
  ;; proselint is annoying in orgmode because it complains about TODO items
  ;; etc
  (setq-default flycheck-disabled-checkers '(proselint)))

(defun show-checklists ()
  "Show my list of checklists."
  (interactive)
  (find-file (expand-file-name "Checklists.org" org-roam-directory))
  (message "Look for checklists that might be relevant to do now."))
(defun show-agenda-tomorrow ()
  "Show the org agenda for tomorrow."
  (org-agenda-list nil "TODAY" 2)
  (message "Now enter your intentions for tomorrow."))
(defun write-daily-message ()
  "Pick the first TODO for tomorrow."
  (interactive)
  (with-temp-file "~/.productivity/daily_message.txt"
    (insert (read-from-minibuffer "First TODO for tomorrow: ")))
  (daily-checklist-next))
(defun choose-bedtime ()
  "Choose the target bedtime for tomorrow."
  (interactive)
  (copy-file "~/.productivity/bedtime_tomorrow.txt"
             "~/.productivity/bedtime_today.txt"
             ;; overwrite existing file
             " ")
  (with-temp-file "~/.productivity/bedtime_tomorrow.txt"
    (insert (read-from-minibuffer "Planned bedtime tomorrow: ")))
  (daily-checklist-next))

(defvar daily-checklist-functions
  '("Fill out your outcomes for today, then come back!"
    "Process your intray."
    show-checklists
    "Check your calendar for tomorrow."
    (lambda ()
      (find-file "~/Documents/org/reviews/weekly.org")
      (message "Look at your weekly goals"))
    (lambda ()
      (shell-command "complice.sh")
      (daily-checklist-next))
    show-agenda-tomorrow
    write-daily-message
    choose-bedtime
    "Mental check: are there any open things you need to deal with?"
    (lambda ()
      (message "You're done! Say your shutdown phrase and enjoy the evening :)")
      (setq daily-checklist-current-step nil)))
  "The list of functions to be called one after another during the daily checklist.")

(defvar daily-checklist-current-step nil
  "Index of the current step of the daily checklist or nil for not running.")

(defun daily-checklist-next ()
  "Go to the next step of the daily checklist."
  (interactive)
  (if daily-checklist-current-step
      (setq daily-checklist-current-step (1+ daily-checklist-current-step))
    (setq daily-checklist-current-step 0))
  (if (< daily-checklist-current-step (safe-length daily-checklist-functions))
      (let ((next-step (nth daily-checklist-current-step daily-checklist-functions)))
        (if (stringp next-step)
            (message next-step)
          (funcall next-step)))
    (setq daily-checklist-current-step nil)
    (message "Something went wrong, but the daily checklist should be reset now.")))

(defun daily-checklist-abort ()
  "Stop the daily checklist early."
  (interactive)
  (setq daily-checklist-current-step nil)
  (message "Aborted daily checklist."))

(map! :leader
      :desc "Daily checklist" "on" #'daily-checklist-next
      :desc "Abort checklist" "oq" #'daily-checklist-abort
      :desc "Calc" "oc" #'calc
      :desc "Daily note today" "nrt" #'org-roam-dailies-find-today
      :desc "Browse journal" "nrj" #'my/browse-journal)

(use-package! ledger-mode
  :mode "\\.journal\\'"
  :custom
  (ledger-default-date-format ledger-iso-date-format)
  :config
  (setq ledger-binary-path "hledger"))

;; LaTeX config
(setq +latex-viewers '(zathura))
(setq reftex-default-bibliography "~/Documents/bibliography/references.bib")
(setq LaTeX-csquotes-open-quote "\\enquote{"
      LaTeX-csquotes-close-quote "}"
      ;; Math symbols are already handled by ligatures, we don't need to fold them.
      ;; Otherwise, they sometimes change color when responsibility switches
      ;; from ligatures to folding for some reason. More importantly, folding
      ;; doesn't play nice with sub- and superscripts (the folded objects aren't
      ;; lowered/raised).
      LaTeX-fold-math-spec-list nil)

(add-hook 'LaTeX-mode-hook
          (lambda () (set (make-local-variable 'TeX-electric-math)
                     (cons "\\(" ""))))
;; Remove certain unwanted ligatures
;; (for example, \par is annoying because it is a prefix of \partial, which makes
;; typing it weird)
;; tex-mode defines an underlying variable tex--prettify-symbols-alist, which
;; is used to populate prettify-symbols-alist (the latter is buffer-local)
;; NOTE Might be better to directly modify that once instead of using this hook?
(add-hook 'LaTeX-mode-hook
          (lambda ()
            (setq prettify-symbols-alist (delq (assoc "\\par" prettify-symbols-alist) prettify-symbols-alist))))

;; Making \( \) less visible
;; https://tecosaur.github.io/emacs-config/config.html#editor-visuals
(defface unimportant-latex-face
  '((t
     :inherit font-lock-comment-face :slant normal :weight light))
  "Face used to make \\(\\), \\[\\] less visible."
  :group 'LaTeX-math)

(font-lock-add-keywords
 'latex-mode
 `((,(rx (and "\\" (any "()[]"))) 0 'unimportant-latex-face prepend))
 'end)

(font-lock-add-keywords
 'latex-mode
 `((,"\\\\[[:word:]]+" 0 'font-lock-keyword-face prepend))
 'end)

;; https://emacs.stackexchange.com/questions/13933/cycling-through-latex-math-mode-and-equation
(defun cycle-texmath ()
  (interactive)
  (save-excursion
    (while (member (TeX-current-macro) '("text"))
      (backward-char))
    (when (texmathp)
      (let ((env (car texmathp-why)))
        (cond
         ((string= env "equation")
          (search-backward "\\begin{equation}")
          (replace-match "\\[" t t)
          (search-forward "\\end{equation}")
          (replace-match "\\]" t t))
         ((string= env "\\[")
          (search-backward "\\[")
          (replace-match "\\(" t t)
          (search-forward "\\]")
          (replace-match "\\)" t t))
         ((string= env "\\(")
          (search-backward "\\(")
          (replace-match "\\begin{equation}" t t)
          (search-forward "\\)")
          (replace-match "\\end{equation}" t t)))))))
(map! :after latex
      :map LaTeX-mode-map
      :localleader
      :nv "e" #'cycle-texmath)

(use-package! latex-extra
  :hook (LaTeX-mode . latex-extra-mode)
  :config
  ;; By default, evil-mode overrides the [tab] keybinding
  (map! :map evil-tex-mode-map
        :n [tab] #'latex/hide-show))

(use-package! ivy-posframe
  :defer t
  :config
  (setq ivy-posframe-width 110
        ivy-posframe-height ivy-height
        ivy-posframe-min-height ivy-height
        ivy-posframe-min-width 110))

(use-package org-ref
  :after org
  :config
  (setq org-ref-default-ref-type "cref")
  (setq org-ref-get-pdf-filename-function 'org-ref-get-pdf-filename-helm-bibtex)
  (setq org-ref-bibliography-notes "~/Documents/bibliography/notes.org"
        org-ref-default-bibliography '("~/Documents/bibliography/references.bib")
        org-ref-pdf-directory "~/Documents/bibliography/pdfs/"))

(global-evil-motion-trainer-mode 1)
(setq evil-motion-trainer-threshold 5)

(setq evil-snipe-scope 'visible
      evil-snipe-repeat-scope 'whole-visible)
