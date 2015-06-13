;; functions to create the left navigation bar


(in-package :cl-user)






;; ++++
;; treeview stuff
;; ++++



(defun generate-navigation-header ()
"Generates control commands for the tree navigation panel"
            ;; raw html - just to try out the working javascript!!
         (format nil "<div id=\"treecontrol\">

		<a href=\"#\">Collapse All</a>
		<a href=\"#\">Expand All</a>
		<a href=\"#\">Toggle All</a>
	</div>"))



(defun add-closing-stuff (number)
"Function to close the nested lists" 
  (setq risultato "")
  (dotimes (i number)
    (setq risultato (format nil "~A~%</li>~%</ul>" risultato)))
  (values risultato))



(defun add-opening-stuff (number)
"Function to create the space for the proposition Wittgenstein has missed out" 
  (setq risultato "")
  (dotimes (i (- number 1))
    (setq risultato (format nil "~A~%<ul>~%<li><a href=\"http://philosurfical.open.ac.uk/tractatus/info-gutenberg.html#missing\" target=\"_blank\">Empty Node</a>" risultato)))  ;;maybe we can call it empty-level
  (values risultato))




;; stuff for sorting out the tabs problem-- the anchors needs to be "shifted up" ..
(defun calculate-link (y foo-vect shift) 
"Takes a vector and one of its element, and returns the vector element preceding by -shift-"
  (cond ((= y 1) (setq link 1))
        ((= y 1.1)  (setq link 1))
        (t (dotimes (i (length foo-vect))
             (if (= (aref foo-vect i) y)
                 (setq link (aref foo-vect (- i shift)))))))
    link)
   



(defun go-through-list (foo)
"Function to create the input for the treeView jscript - and also create the link structure for the satz!"
  (setq result "")
  (setq previous-length 0)
  (setq foo-vector (list-to-vector foo))
  (mapc #'(lambda (x) (cond ((= (number-length x) previous-length)
                             (setq result (format nil "~A~%</li>~%<li><a href=\"#~A\" class=\"item\">~A</a>" result (calculate-link x foo-vector 0) x))
                             (setq previous-length (number-length x)))
                            ((= (- (number-length x) previous-length) 1)
                             (setq result (format nil "~A~%<ul>~%<li><a href=\"#~A\" class=\"item\">~A</a>" result (calculate-link x foo-vector 0) x))
                             (setq previous-length (number-length x)))
                            ((> (- (number-length x) previous-length) 1)
                             (setq result (format nil "~A~A~%<ul>~%<li><a href=\"#~A\" class=\"item\">~A</a>" result (add-opening-stuff (- (number-length x) previous-length )) 
                                                  (calculate-link x foo-vector 0) x))
                             (setq previous-length (number-length x)))

                            ((< (number-length x) previous-length)
                             (setq result (format nil "~A~A~%<li><a href=\"#~A\" class=\"item\">~A</a>" result (add-closing-stuff (- previous-length (number-length x))) 
                                                  (calculate-link x foo-vector 0) x))
                             (setq previous-length (number-length x))))) foo)
  (setq result (format nil "~A~%</li>~%</ul>" result)))
 
 




(defun generate-navigation-pane ()
"Generates the multi level list of the navigation pane with the kb data about the paragraphs and sub-paragraphs"
(go-through-list (ocml::get-tractatus-paragraphs-numbers)))
 






