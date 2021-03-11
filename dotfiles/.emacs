
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(add-log-mailing-address "unixbhaskar@gmail.com")
 '(ansi-color-names-vector
   ["#3F3F3F" "#CC9393" "#7F9F7F" "#F0DFAF" "#8CD0D3" "#DC8CC3" "#93E0E3" "#DCDCCC"])
 '(company-quickhelp-color-background "#4F4F4F")
 '(company-quickhelp-color-foreground "#DCDCCC")
 '(compose-mail-user-agent-warnings nil)
 '(custom-enabled-themes '(molokai))
 '(custom-safe-themes
   '("8f567db503a0d27202804f2ee51b4cd409eab5c4374f57640317b8fcbbd3e466" "e6df46d5085fde0ad56a46ef69ebb388193080cc9819e2d6024c9c6e27388ba9" default))
 '(display-line-numbers-type 'relative)
 '(display-time-mode t)
 '(epa-global-mail-mode t)
 '(fci-rule-color "#383838")
 '(global-display-line-numbers-mode t)
 '(mu4e-mu-binary "/usr/local/bin/mu")
 '(nrepl-message-colors
   '("#CC9393" "#DFAF8F" "#F0DFAF" "#7F9F7F" "#BFEBBF" "#93E0E3" "#94BFF3" "#DC8CC3"))
 '(package-selected-packages
   '(vterm dashboard pass molokai-theme magit zenburn-theme ## mu4e-views mu4e-alert counsel ivy-rich which-key command-log-mode use-package))
 '(pdf-view-midnight-colors '("#DCDCCC" . "#383838"))
 '(scroll-bar-mode nil)
 '(send-mail-function 'mailclient-send-it)
 '(show-paren-mode t)
 '(smtpmail-debug-info t)
 '(smtpmail-default-smtp-server "smtp.gmail.com")
 '(smtpmail-local-domain "gmail.com")
 '(smtpmail-smtp-server "smtp.gmail.com")
 '(smtpmail-smtp-service 587)
 '(smtpmail-smtp-user "unixbhaskar")
 '(smtpmail-stream-type 'starttls)
 '(tooltip-mode nil)
 '(user-mail-address "unixbhaskar@gmail.com")
 '(vc-annotate-background "#2B2B2B")
 '(vc-annotate-color-map
   '((20 . "#BC8383")
     (40 . "#CC9393")
     (60 . "#DFAF8F")
     (80 . "#D0BF8F")
     (100 . "#E0CF9F")
     (120 . "#F0DFAF")
     (140 . "#5F7F5F")
     (160 . "#7F9F7F")
     (180 . "#8FB28F")
     (200 . "#9FC59F")
     (220 . "#AFD8AF")
     (240 . "#BFEBBF")
     (260 . "#93E0E3")
     (280 . "#6CA0A3")
     (300 . "#7CB8BB")
     (320 . "#8CD0D3")
     (340 . "#94BFF3")
     (360 . "#DC8CC3")))
 '(vc-annotate-very-old-color "#DC8CC3"))
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
		mu4e-main-mode-hook
		mu4e-view-mode-hook
		mu4e-compose-mode-hook
		mu4e-headers-mode-hook
		mu4e-org-mode-hook
		eshell-mode-hook
		eww-buffers-mode-hook
		vterm-mode-hook))
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
     (setq mu4e-getmail-command "getmail")
     (setq mu4e-maildir "~/gmail-backup")
     (setq mu4e-sent-folder "/sent")

     (setq mu4e-maildir-shortcuts
	   '(("Inbox"        .?i)
	     ("Greg(GKH)"    .?g)
	     ("Linus"        .?l)
	     ("Al_Viro"      .?a)
	     ("Andrew_Morton"  .?n)
	     ("Thomas_Gleixner"  .?t)
	     ("unix_tips"       .?u)
	     ("David_Miller"    .?d)
	     ("Jonathan_Corbet"  .?j)
	     ("sent"         .?s))))


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

(setq epg-gpg-program "gpg2")
(setenv "GPG_AGENT_INFO" nil)

(use-package pass
  :pin melpa
  :config
  (setf epa-pinentry-mode 'loopback))

;;vterm

(use-package vterm
	         :ensure t)
(add-to-list 'load-path "~/.emacs.d/emacs-libvterm/")
(require 'vterm)

(setq auth-source-debug t)

(setq auth-sources
          '((:source "~/.emacs.d/secrets/.authinfo.gpg")))

