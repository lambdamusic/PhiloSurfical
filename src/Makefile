default:
	echo "No default target."

clean:
	find . -name "*fasl" | xargs rm


console:
	lispworks -init make-console.lisp -siteinit -
