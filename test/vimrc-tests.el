(require 'vimrc-mode)
(require 'ert)

(defmacro vimrc--should-indent (from to)
  `(with-temp-buffer
     (let ((vimrc-indent-offset 2))
       (insert ,from)
       (indent-region (point-min) (point-max))
       (should (string= (buffer-substring-no-properties (point-min) (point-max))
                      ,to)))))

(ert-deftest vimrc--test-indent-if-1 ()
  "if"
  (vimrc--should-indent
   "
if 0
  0
endif"
   "
if 0
  0
endif"))

(ert-deftest vimrc--test-indent-if-2 ()
  "if else"
  (vimrc--should-indent
   "
if 0
0
else
1
endif"
   "
if 0
  0
else
  1
endif"))

(ert-deftest vimrc--test-indent-if-3 ()
  "if esleif else"
  (vimrc--should-indent
   "
if 0
0
elseif 1
1
else
2
endif"
   "
if 0
  0
elseif 1
  1
else
  2
endif"))

(ert-deftest vimrc--test-indent-while ()
  "while"
  (vimrc--should-indent
   "
while i < 5
echo i
let i += 1
endwhile"
   "
while i < 5
  echo i
  let i += 1
endwhile"))

(ert-deftest vimrc--indent-for ()
  "for"
  "
for i in range(1, 4)
other stmt
echo i
endfor"
  "
for i in range(1, 4)
  other stmt
  echo i
endfor")

(defun vimrc--run-tests ()
  (interactive)
  (if (featurep 'ert)
      (ert-run-tests-interactively "vimrc--test")
    (message "cant run without ert.")))

(provide 'yaml-indent-tests)
