# org-sync-snippets
Simple extension to export snippets to org-mode and vice versa.

It was designed with Yasnippet in mind.

## Motivation
I really like Yasnippet and would like to collect my snippets files into one place.
It is a lot of files to track if I put them into source control, and I rarely modify the ones I have.

On the other hand, I also do not want to track all the snippets I make and keep some private.

For these reasons, I made `org-sync-snippets` which compiles snippets files to an org file and back.

## Install

Install from MELPA (if it is admitted) with
```
M-x package-install org-sync-snippets
```
or load the present file.

## Usage

Load with
```
(require 'org-sync-snippets)
```
To export your snippets to an org-mode file, use
```
M-x org-sync-snippets-snippets-to-org
```
Alternatively, to turn your org-mode file into snippets
```
M-x org-sync-snippets-org-to-snippets
```
Notice: you can prevent certain snippets from being exported to org by adding the `tangle: no` tag in them.
```
# -*- mode: snippet -*-
# name: var_dump
# key: dump
# tangle: no
# --
var_dump($1); exit;$0
```
This particular snippet will not make it into the compiled org file.

## Customize

By default, snippets are taken from the 'user-emacs-directory' (typically '~/.emacs.d/snippets/') folder.
You can change this with
```
(setq org-sync-snippets-snippets-dir "~/your/path/to/snippets")
```
Similarly, the org file compiled goes to your 'org-directory' (usually '~/org/snippets.org').
You can define a different one with
```
(setq org-sync-snippets-org-snippet-file "~/your/path/to/snippet/file")
```
Finally, if you want to save your snippets regularly, I recommend using a hook like
```
(add-hook 'yas-after-reload-hook 'snippets-to-org)
```
