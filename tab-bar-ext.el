;;; tab-bar-ext.el --- Tab Bar Extensions  -*- lexical-binding: t; -*-

;; Copyright (C) 2024  Ruslan Kamashev

;; Author: Ruslan Kamashev <rynffoll@gmail.com>
;; Keywords: frames tabs
;; Version: 0.1
;; Package-Requires: ((emacs "28.1"))
;; Homepage: https://github.com/rynffoll/tab-bar-ext

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; Extension function for `tab-bar-mode'

;;; Code:

(require 'tab-bar)
(require 'project)


(defgroup tab-bar-ext
  nil
  "Tab Bar Extentions."
  :group 'tools)


;;;###autoload
(defun tab-bar-ext-print-tabs (&optional ignore)
  (interactive)
  (let* ((separator (propertize "|" 'face '(shadow)))
         (tabs
          (mapconcat
           (lambda (tab)
             (let* ((type (car tab))
                    (index (1+ (tab-bar--tab-index tab)))
                    (name (alist-get 'name tab))
                    (face (if (equal type 'current-tab)
                              '(font-lock-constant-face :inverse-video t)
                            '(shadow))))
               (propertize (format " %d:%s " index name) 'face face)))
           (tab-bar-tabs) separator)))
    (message tabs)))

;;;###autoload
(defun tab-bar-ext-rename-or-close (name)
  (if name
      (tab-rename name)
    (progn
      (tab-close)
      (setq quit-flag nil))))

;;;###autoload
(defun tab-bar-ext-post-open-rename (tab)
  (let* ((index (1+ (tab-bar--current-tab-index)))
         (prompt (format "%d:" index))
         (inhibit-quit t)
         (name (with-local-quit (read-string prompt))))
    (tab-bar-ext-rename-or-close name)))

;;;###autoload
;; (defun tab-bar-ext-post-open-projectile (tab)
;;   (let* ((inhibit-quit t)
;;          (project (with-local-quit (projectile-switch-project)))
;;          (name (when project
;;                  (file-name-nondirectory
;;                   (directory-file-name project)))))
;;     (tab-bar-ext-rename-or-close name)))

;;;###autoload
;; (defun tab-bar-ext-projectile ()
;;   (interactive)
;;   (let* ((tab-bar-tab-post-open-functions #'tab-bar-ext-post-open-projectile))
;;     (tab-new)))

;;;###autoload
(defun tab-bar-ext-post-open-project (tab)
  (let* ((inhibit-quit t)
         (project (and (with-local-quit (call-interactively 'project-switch-project))
                       (project-current)))
         (name (when project
                 (project-name project))))
    (tab-bar-ext-rename-or-close name)))

;;;###autoload
(defun tab-bar-ext-project ()
  (interactive)
  (let* ((tab-bar-tab-post-open-functions #'tab-bar-ext-post-open-project))
    (tab-new)))

(provide 'tab-bar-ext)
;;; tab-bar-ext.el ends here
