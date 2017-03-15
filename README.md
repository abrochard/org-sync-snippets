# org-sync-snippets
Simple extension to export snippets to org-mode and vice versa.
It was designed with Yasnippet in mind.

## Install:

Install from MELPA with
```
M-x package-install org-sync-snippets
```
or load the present file.

## Usage:

To export your snippets to an org-mode file, use
```
M-x snippets-to-org
```
Alternatively, to turn your org-mode file into snippets
```
M-x org-to-snippets
```

## Customize:

By default, snippets are taken from the 'user-emacs-directory' (typically '~/.emacs.d/snippets/') folder.
You can change this with
```
(setq oss-snippets-dir "~/your/path/to/snippets")
```
Similarly, the org file compiled goes to your 'org-directory' (usually '~/org/snippets.org').
You can define a different one with
```
(setq oss-org-snippet-file "~/your/path/to/snippet/file")
```
Finally, if you want to save your snippets regularly, I recommend using a hook like
```
(add-hook 'yas-after-reload-hook 'snippets-to-org)
```
