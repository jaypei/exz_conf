;;; Package --- ...
;;; Commentary:

;;; Code:

(exz-add-search-path "site-lisp/org")

;; fontify code in code blocks
(setq org-src-fontify-natively t)

(setq org-publish-project-alist
      '(("note-org"
         :base-directory "~/work/vimwiki/org"
         :publishing-directory "~/work/vimwiki/org-publish"
         :base-extension "org"
         :recursive t
         :publishing-function org-html-publish-to-html
         :auto-index nil
         :index-filename "index.org"
         :index-title "index"
         :link-home "index.html"
         :section-numbers nil
         :style "<link rel=\"stylesheet\"
                       href=\"./style/emacs.css\"
                       type=\"text/css\"/>")
        ("note-static"
         :base-directory "~/work/vimwiki/org-static"
         :publishing-directory "~/work/vimwiki/org-publish/static"
         :recursive t
         :base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|swf\\|zip\\|gz\\|txt\\|el"
         :publishing-function org-publish-attachment)
        ("note"
         :components ("note-org" "note-static")
         :author "jaypei97159@gmail.com"
         )))

(add-hook 'org-mode-hook
          (lambda ()
            (org-babel-do-load-languages
             'org-babel-load-languages
             '((sh . t)
               (python . t)
               (R . t)
               (ruby . t)
               (ditaa . t)
               (dot . t)
               (octave . t)
               (sqlite . t)
               (perl . t)
               ))))

(setq org-todo-keywords
      '((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)")
        (sequence "WAITING(w@/!)" "HOLD(h@/!)" "|" "CANCELLED(c@/!)" "PHONE" "MEETING")))

(setq org-todo-keyword-faces
      (quote (("TODO" :foreground "red" :weight bold)
              ("NEXT" :foreground "blue" :weight bold)
              ("DONE" :foreground "forest green" :weight bold)
              ("WAITING" :foreground "orange" :weight bold)
              ("HOLD" :foreground "magenta" :weight bold)
              ("CANCELLED" :foreground "forest green" :weight bold)
              ("MEETING" :foreground "forest green" :weight bold)
              ("PHONE" :foreground "forest green" :weight bold))))

(setq org-todo-state-tags-triggers
      (quote (("CANCELLED" ("CANCELLED" . t))
              ("WAITING" ("WAITING" . t))
              ("HOLD" ("WAITING") ("HOLD" . t))
              (done ("WAITING") ("HOLD"))
              ("TODO" ("WAITING") ("CANCELLED") ("HOLD"))
              ("NEXT" ("WAITING") ("CANCELLED") ("HOLD"))
              ("DONE" ("WAITING") ("CANCELLED") ("HOLD")))))

;; Capture templates for: TODO tasks, Notes, appointments, phone calls, meetings, and org-protocol
(setq org-capture-templates
      (quote (("t" "todo" entry (file "~/work/org/refile.org")
               "* TODO %?\n%U\n%a\n" :clock-in t :clock-resume t)
              ("r" "respond" entry (file "~/work/org/refile.org")
               "* NEXT Respond to %:from on %:subject\nSCHEDULED: %t\n%U\n%a\n" :clock-in t :clock-resume t :immediate-finish t)
              ("n" "note" entry (file "~/work/org/refile.org")
               "* %? :NOTE:\n%U\n%a\n" :clock-in t :clock-resume t)
              ("j" "Journal" entry (file+datetree "~/work/org/diary.org")
               "* %?\n%U\n" :clock-in t :clock-resume t)
              ("w" "org-protocol" entry (file "~/work/org/refile.org")
               "* TODO Review %c\n%U\n" :immediate-finish t)
              ("m" "Meeting" entry (file "~/work/org/refile.org")
               "* MEETING with %? :MEETING:\n%U" :clock-in t :clock-resume t)
              ("p" "Phone call" entry (file "~/work/org/refile.org")
               "* PHONE %? :PHONE:\n%U" :clock-in t :clock-resume t)
              ("h" "Habit" entry (file "~/work/org/refile.org")
               "* NEXT %?\n%U\n%a\nSCHEDULED: %(format-time-string \"<%Y-%m-%d %a .+1d/3d>\")\n:PROPERTIES:\n:STYLE: habit\n:REPEAT_TO_STATE: NEXT\n:END:\n"))))

(setq org-directory "~/work/org")
(setq org-default-notes-file "~/work/org/refile.org")
(setq org-agenda-files (quote ("~/work/org/todo")))

(defun exz/org-publish ()
  "Auto generate web-site."
  (interactive)
  (org-publish "note"))

(defun exz/org-open ()
  "Open index.org in wiki base dir."
  (interactive)
  (find-file "~/work/vimwiki/org/index.org"))

(defun exz/org-compile-and-open-html ()
  (interactive)
  (org-export-to-file 'html "/tmp/abc.html")
  (browse-url "/tmp/abc.html")
  )

(defun exz/make-org-scratch ()
  (interactive)
  (find-file "/tmp/publish/scratch.org")
  (gnus-make-directory "/tmp/publish"))

(defun exz/switch-to-scratch ()
  (interactive)
  (switch-to-buffer "*scratch*"))

;; I use C-c c to start capture mode
(global-set-key (kbd "C-c c")
                (lambda ()
                  (find-file "~/work/org/todo/index.org")))

;; org
(add-hook 'org-mode-hook
          (lambda ()
            (local-set-key (kbd "C-z o p") 'exz-org-publish)
            (local-set-key (kbd "C-z c") 'exz/org-compile-and-open-html)))


;;; exz-org.el ends here
(provide 'exz-org)
