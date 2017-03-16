;;; org-sync-snippets.el --- Export snippets to org-mode and vice versa

;; Copyright (C) 2017, Adrien Brochard

;; This file is NOT part of Emacs.

;; This  program is  free  software; you  can  redistribute it  and/or
;; modify it  under the  terms of  the GNU  General Public  License as
;; published by the Free Software  Foundation; either version 2 of the
;; License, or (at your option) any later version.

;; This program is distributed in the hope that it will be useful, but
;; WITHOUT  ANY  WARRANTY;  without   even  the  implied  warranty  of
;; MERCHANTABILITY or FITNESS  FOR A PARTICULAR PURPOSE.   See the GNU
;; General Public License for more details.

;; You should have  received a copy of the GNU  General Public License
;; along  with  this program;  if  not,  write  to the  Free  Software
;; Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
;; USA

;; Version: 1.0
;; Author: Adrien Brochard
;; Keywords: snippet org-mode yasnippet tools
;; URL: https://github.com/abrochard/org-sync-snippets
;; License: GNU General Public License >= 3
;; Package-Requires: ((org "8.3.5") (emacs "24.3") (f "0.17.3"))

;;; Commentary:

;; Simple extension to export snippets to org-mode and vice versa.
;; It was designed with Yasnippet in mind.

;;; Install:

;; Install from MELPA with
;;
;; M-x package-install org-sync-snippets
;;
;; or load the present file.

;;; Usage:

;; Load with
;;
;; (require 'org-sync-snippets)
;;
;; To export your snippets to an org-mode file, use
;;
;; M-x oss-snippets-to-org
;;
;; Alternatively, to turn your org-mode file into snippets
;;
;; M-x oss-org-to-snippets
;;
;; Notice: you can prevent certain snippets from being exported to org by adding the `tangle: no` tag in them.

;;; Customize:

;; By default, snippets are taken from the 'user-emacs-directory' (typically '~/.emacs.d/snippets/') folder.
;; You can change this with
;;
;; (setq oss-snippets-dir "~/your/path/to/snippets")
;;
;; Similarly, the org file compiled goes to your 'org-directory' (usually '~/org/snippets.org').
;; You can define a different one with
;;
;; (setq oss-org-snippets-file "~/your/path/to/snippet/file")
;;
;; Finally, if you want to save your snippets regularly, I recommend using a hook like
;;
;; (add-hook 'yas-after-reload-hook 'snippets-to-org)

;;; Code:
(require 'org)
(require 'f)

(defcustom oss-org-snippets-file (concat (file-name-as-directory org-directory) "snippets.org"))
(defcustom oss-snippets-dir (concat user-emacs-directory "snippets/"))
(defcustom oss-collection-title "Snippets Collection")

;;;###autoload
(defun oss-snippets-to-org ()
  "Compile snippet files to an 'org-mode' file."
  (interactive)
  (let ((output ""))
    (setq output (concat output "#+TITLE: " oss-collection-title "\n"))
    (setq output (concat output "#+AUTHOR: org-sync-snippets\n\n"))
    (dolist (mode (f-directories oss-snippets-dir))
      (setq output (concat output "* " (file-name-base mode) "\n"))
      (dolist (snippet-file (f-files mode))
        (let ((content (f-read-text snippet-file 'utf-8)))
          (if (not (string-match "^# tangle: no" content))
              (setq output (concat output
                                   "** " (file-name-base snippet-file) "\n"
                                   "#+BEGIN_SRC snippet "
                                   ":tangle " snippet-file
                                   "\n"
                                   (replace-regexp-in-string "^" "  " content) "\n"
                                   "#+END_SRC\n"))))))
    (f-write-text output 'utf-8 oss-org-snippets-file))
  (message "Done"))

(defun oss-org-to-snippets ()
  "Export the 'org-mode' file back to snippet files."
  (interactive)
  (if (not (f-dir? oss-snippets-dir))
      (f-mkdir oss-snippets-dir))
  (with-temp-buffer
    (insert-file-contents oss-org-snippets-file)
    (while (re-search-forward "^* \\(.+-mode\\)" (point-max) t)
      (let ((path (concat (file-name-as-directory oss-snippets-dir) (match-string 1))))
        (if (not (f-dir? path))
            (f-mkdir path)))))
  (org-babel-tangle-file oss-org-snippets-file)
  (message "Done"))

(provide 'org-sync-snippets)
;;; org-sync-snippets.el ends here
