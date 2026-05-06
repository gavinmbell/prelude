(defun halve-other-window-height ()
  "Expand current window to use half of the other window's lines."
  (interactive)
  (enlarge-window (/ (window-height (next-window)) 2)))

(global-set-key (kbd "C-c v") 'halve-other-window-height)

(defun half-my-window-height ()
  "Expand current window to use half of the other window's lines."
  (interactive)
  (enlarge-window (* (/ (window-height) 2) -1)))

(global-set-key (kbd "C-c C-v") 'half-my-window-height)
