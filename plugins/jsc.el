;; snippet Google Closure Compiler
(define-key global-map "\C-cJe" 'fitz-jsc-errors-current-selection)

(defun fitz-jsc-errors-current-selection ()
 "run jsc for errors on current selection"
 (interactive)
 (let ((tmp-buffer (get-buffer-create "**fitz-cc**"))
       (region-str (buffer-substring (region-beginning) (region-end)))
       (cc-output (shell-command-to-string
                       (concat "jsc -e -c \""
                               (buffer-substring (region-beginning) (region-end)) "\""))))
   (set-buffer tmp-buffer)
   (goto-char (point-max))
   (insert (concat "===== BEGIN =====\n"
                   "Selected Code:\n\t"
                   region-str
                   "\n\n"
                   "JSCompiler Errors:\n"
                   cc-output
                   "===== END =====\n\n")
   (switch-to-buffer-other-window tmp-buffer)
   (recenter (point-max)))))

(define-key global-map "\C-cJw" 'fitz-jsc-warnings-current-selection)
 
(defun fitz-jsc-warnings-current-selection ()
 "run jsc for warnings on current selection"
 (interactive)
 (let ((tmp-buffer (get-buffer-create "**fitz-cc**"))
       (region-str (buffer-substring (region-beginning) (region-end)))
       (cc-output (shell-command-to-string
                       (concat "jsc -w -c \""
                               (buffer-substring (region-beginning) (region-end)) "\""))))
   (set-buffer tmp-buffer)
   (goto-char (point-max))
   (insert (concat "===== BEGIN =====\n"
                   "Selected Code:\n\t"
                   region-str
                   "\n\n"
                   "JSCompiler Warnings:\n"
                   cc-output
                   "===== END =====\n\n")
   (switch-to-buffer-other-window tmp-buffer)
   (recenter (point-max)))))
