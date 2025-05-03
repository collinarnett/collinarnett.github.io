;;; publish.el --- Org-roam HTML publication script -*- lexical-binding: t; -*-
;; Package-Requires: (haskell-mode seq htmlize org-roam )
;;; Commentary:
;; This script provides functionality to publish org-roam notes to HTML.
;; It sets up a publication system with custom handling for backlinks,
;; sitemap generation, and link building.

;;; Code:
;; (require 'seq)
(require 'package) (package-initialize)
(require 'haskell-mode)
(require 'haskell-interactive-mode)
(require 'haskell-process)
(add-hook 'haskell-mode-hook 'interactive-haskell-mode)
;; (require 'htmlize)
(require 'org-roam)
(require 'org-roam-dailies)
(require 'org-roam-export)

(defvar my-publish-time 0
  "Timestamp of the last publication operation.")

(setq org-roam-directory (file-truename "./."))
(setq org-roam-dailies-directory "./.")

(defun roam-publication-wrapper (plist filename pubdir)
  "Wrapper for org HTML publication that also records publish time.
PLIST is the property list for the project.
FILENAME is the filename of the Org file being published.
PUBDIR is the directory where the output will be published."
  (org-html-publish-to-html plist filename pubdir)
  (setq my-publish-time (cadr (current-time))))

(defun filter-backlinks (ast)
  "Filter out nodes with backlinks from the sitemap AST.
AST is the abstract syntax tree of the sitemap."
  (cl-destructuring-bind (type &rest items) ast
    (cons type
	  (seq-filter
	   (lambda (it)
	     (let* ((link (car it))
		    (file (when (and (stringp link)
				     (string-match "\\[\\[file:\\([^][|]+\\)\\]" link))
			    (expand-file-name (match-string 1 link) org-roam-directory))))
	       (or (null file)
		   (not (seq-some
			 (lambda (n)
			   (and (string= (org-roam-node-file n) file)
				(org-roam-backlinks-get n)))
			 (org-roam-node-list))))))
	   items))))

(defun roam-sitemap (title list)
  "Generate a sitemap for org-roam notes.
TITLE is the title for the sitemap.
LIST is the list of files to include in the sitemap."
  (concat "#+OPTIONS: ^:nil author:nil html-postamble:nil\n"
	  "#+SETUPFILE: ./simple_inline.theme\n"
	  "#+TITLE: " title "\n\n"
	  (org-list-to-org (filter-backlinks list))))

(setq org-publish-project-alist
      `(("roam"
	 :base-directory "./."
	 :base-extension "org"
	 :recursive t
	 :auto-sitemap t
	 :sitemap-function roam-sitemap
	 :stiemap-style list
	 :sitemap-title "Roam notes"
	 :publishing-function roam-publication-wrapper
	 :publishing-directory "./site/"
	 :style "<link rel=\"stylesheet\" href=\"../other/mystyle.cs\" type=\"text/css\">")))

(defun org-roam-custom-link-builder (node)
  "Build custom HTML links for org-roam nodes.
NODE is the org-roam node to create a link for.
Returns a string with the HTML filename for the node."
  (let ((file (org-roam-node-file node)))
    (concat (file-name-base file) ".html")))

(defvar org-roam-graph-link-builder 'org-roam-custom-link-builder
  "Function to build links in the org-roam graph.
Should take a NODE and return a string representing the link target.")

(setq org-confirm-babel-evaluate nil)
(org-roam-db-autosync-mode)

(require 'ob-haskell)
(org-publish-all t)
;;; publish.el ends heree
