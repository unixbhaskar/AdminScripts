(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(add-log-mailing-address "unixbhaskar@gmail.com")
 '(custom-enabled-themes '(tango-dark))
 '(display-line-numbers-type 'relative)
 '(display-time-mode t)
 '(epa-global-mail-mode t)
 '(global-display-line-numbers-mode t)
 '(mu4e-mu-binary "/usr/local/bin/emacs-mu")
 '(package-selected-packages
   '(mu4e-views mu4e-alert counsel ivy-rich which-key command-log-mode use-package))
 '(scroll-bar-mode nil)
 '(send-mail-function 'mailclient-send-it)
 '(show-paren-mode t)
 '(tooltip-mode nil))
(tool-bar-mode -1)
(tooltip-mode -1)
(menu-bar-mode -1)

(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
			 ("org" . "https://orgmode.org/elpa/")
			 ("elpa" . "https//elpa.gnu.org/packages/")))

(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)
(add-to-list 'package-archives
             '("melpa-stable" . "http://stable.melpa.org/packages/") t)
(add-to-list 'package-archives
	     '("marmalade" . "https://marmalade-repo.org/packages/") t)
(add-to-list 'package-archives
             '("gnu elpa" . "https://elpa.gnu.org/packages/") t)



(let ((default-directory "~/.emacs.d/elpa"))
  (normal-top-level-add-subdirs-to-load-path))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))
(unless (package-installed-p 'use-package)
(package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)
(use-package command-log-mode)
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

(setq load-path (append load-path '("~/.emacs.d/mu/mu4e")))
(require 'mu4e)

(setq user-full-name "Bhaskar Chowdhury"
      user-mail-address "unixbhaskar@gmail.com")
(setq mu4e-get-mail-command "getmail"
      mu4e-update-interval 300
      mu4e-attachment-dir "~/attachments")

(setq mu4e-mu-binary "/usr/local/bin/mu")

(require 'mml2015)
(require 'epa-file)

(defun encrypt-message (&optional arg)
  (interactive "p")
  (mml-secure-message-encrypt-pgp))

(defun decrypt-message (&optional arg)
  (interactive "p")
  (epa-decrypt-armor-in-region (point-min) (point-max)))

(defalias 'ec 'encrypt-message)
(defalias 'dc 'decrypt-message)
(setq browse-url-browser-function 'browse-url-vimb)

(column-number-mode)

(dolist (mode '(org-mode-hook
		term-mode-hook
		shell-mode-hook
		mu4e-mode-hook
		eshell-mode-hook))
(add-hook mode (lambda () (display-line-numbers-mode 0))))



(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(require 'org-mu4e)
(require 'mu4e-contrib)
(require 'smtpmail)
(auth-source-pass-enable)
(setq auth-source-debug t)
(setq auth-source-do-cache nil)
(setq auth-sources '(password-store))
(setq message-kill-buffer-on-exit t)
(setq message-send-mail-function 'smtpmail-send-it)
(setq mu4e-attachment-dir "~/attachments")
(setq mu4e-compose-complete-addresses t)
(setq mu4e-compose-context-policy nil)
(setq mu4e-context-policy 'pick-first)
(setq mu4e-view-show-addresses t)
(setq mu4e-view-show-images t)
(setq smtpmail-debug-info t)
(setq smtpmail-stream-type 'starttls)
(setq mm-sign-option 'guided)

(when (fboundp 'imagemagick-register-types)
    (imagemagick-register-types))

(defun sign-or-encrypt-message ()
    (let ((answer (read-from-minibuffer "Sign or encrypt?\nEmpty to do nothing.\n[s/e]: ")))
      (cond
       ((string-equal answer "s") (progn
                                    (message "Signing message.")
                                    (mml-secure-message-sign-pgpmime)))
       ((string-equal answer "e") (progn
                                    (message "Encrypt and signing message.")
                                    (mml-secure-message-encrypt-pgpmime)))
       (t (progn
            (message "Dont signing or encrypting message.")
            nil)))))

  (add-hook 'message-send-hook 'sign-or-encrypt-message)



(use-package mu4e
     :ensure nil
     :config

     (setq mu4e-change-filenames-when-moving t)
     (setq mu4e-update-interval (* 10 60))
     (setq mu4e-getmail-command "mbsync gmail")
     (setq mu4e-maildir "~/gmail-backup")
     (setq mu4e-sent-folder "/sent")

     (setq mu4e-maildir-shortcuts
	   '(("/Inbox"        .?i)
	     ("/sent"         .?s))))


(put 'upcase-region 'disabled nil)

;;open vimb,invoke it like browse-url-generic on M-x prompt
(setq browse-url-generic-program
    (executable-find (getenv "BROWSER"))
     browse-url-browser-function 'browse-url-generic)

(setq x-super-keysym 'meta)

(use-package which-key
    :init (which-key-mode)
    :diminish which-key-mode
    :config
    (setq which-key-idle-delay 0.3))

(use-package ivy-rich
	     :init
	     (ivy-rich-mode 1))

(use-package mu4e-alert
    :after mu4e
    :hook ((after-init . mu4e-alert-enable-mode-line-display)
           (after-init . mu4e-alert-enable-notifications))
    :config (mu4e-alert-set-default-style 'libnotify))

(add-hook 'mu4e-view-mode-hook #'visual-line-mode)
(add-hook 'mu4e-compose-mode-hook 'flyspell-mode)
;;(setq mu4e-compose-in-new-frame t)
(setq mu4e-compose-format-flowed t)
