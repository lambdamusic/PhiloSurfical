(in-package cl-user)




;; +++
;; welcoming page
;; ++

    
;; init
(defun generate-zero-tab ()
"Generates the welcoming page"
(with-html-np
  (:div :class "tabbertab" :title "Welcome..." :id "welcome"


      ;; (:h1 "The PhiloSurfical tool:" )

       (:div :class "wtitle1"
        (:h2 "What is PhiloSURFical?"))
       (:div :class "wdesc1"
        (:p "PhiloSURFIcal is a tool for browsing a philosophical text, taking advantage of a map of the concepts relevant to the text. You can imagine it as the real book, with the enhancement of a <em>smart</em> analytical index, which is constantly updated depending on the context. Find out more using the help <img src=\"/static/img/help0.jpg\" height=\"30\" width=\"30\" align=\"top\"> buttons!"))

       (:div :class "wtitle2"
        (:h2 "Why the Tractatus?"))
       (:div :class "wdesc2"
        (:p " The PhiloSURFical application has been prototyped with Wittgenstein's <a href=\"http://en.wikipedia.org/wiki/Tractatus_Logico-Philosophicus\" target=\"_blank\">Tractatus Logico-Philosophicus</a>. The choice of the Tractatus is not casual: firstly, it is a very structured text, therefore it somehow facilitates the analytical task of dissecting its components and annotating them. Secondly, the Tractatus is a very influential work in the twentieth century philosophy, investigating several issues concerning the functioning of our everyday language, which in recent times has become of interest to various other discipines. Finally - cause it's <i><a href=\"http://www.gutenberg.org/etext/5740\" target=\"_blank\">freely available</a></i>!!"))

       (:div :class "wtitle3"
        (:h2 "How does it work?"))
       (:div :class "wdesc3"
        (:p "Thanks to an underlying <em><a href=\"http://www.formalontology.it/\" target=\"_blank\">ontology</a></em>, that is, a formal representation of the entities of a world. We created this model with the specific purpose of facilitating the exchange of philosophy-related data on the web. PhiloSURFical shows how this can be done: all the contents you see are processed by means of the ontology. This technology exists in the context of the <a href=\"http://www.w3.org/2001/sw/\" target=\"_blank\">Semantic Web</a> initiative: we expect that whenever more resources in the humanities (but not only) will be 'marked-up' using these techniques, the scope and complexity of the available scholarly applications will also improve considerably. To find out more, check out the <a href=\"#\"   onclick=\"return faq_popup('faq')\">F.A.Q.</a> section or go to the main <a href=\"http://philosurfical.open.ac.uk/\" target=\"_blank\">project site</a>."))

       )))


