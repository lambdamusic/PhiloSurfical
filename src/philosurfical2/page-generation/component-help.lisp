;;; +++++++++++++++++++++++++++++++++++++
;;; functions to generate the html HELP files
;;; +++++++++++++++++++++++++++++++++++++




(defun create-helpbar (class id)
"Fucntion that creates the html code to be read by the jqmodal javascript library, e.g. (create-helpbar 'help2trigger 'help2)"
  (with-html-np
    (:a :href "#" :class (string-downcase class) 
      (:span :id "help" "&nbsp;<img src=\"/static/img/help.jpg\" height=\"40\" width=\"90\">")
     ;(:span :id "help" "&nbsp;HELP&nbsp;&nbsp;&nbsp;" )
     )
    (:div :class "jqmWindow" :id (string-downcase id) "Please wait...."
     (:img :src "/static/img/busy.gif" :alt "loading"))))



(defun html-help0 ()
"The help for the first tab"
  (with-html-np
    (:b (:a :href "#" :class "jqmClose" (:em "Close")))
    (:hr)
    (:h1 "Hi there! ")
    (:p "This is a help panel - you will find many others throughout the PhiloSURFical application - if you do not understand what's going on, this is the first place to look for some hints...")))



(defun html-help1 ()
"The help for the first tab"
  (with-html-np
    (:b (:a :href "#" :class "jqmClose" (:em "Close")))
    (:hr)
    (:h1 "Browse the text")
    (:p "This section of PhiloSURFical presents the Tractatus in one of its main two english translations, the one made by David Pears and Brian McGuinness in 1961. <br /><br />By using the left outline you can easily jump to different paragraphs of the book and also have an overview of its inherently hierarchical structure.<br /><br />The right section instead presents the english text together with the original <b>german version</b>, which can be seen by <b>clicking on a paragraph </b>when it is highlighted.")))
 ;;   (:p "this is just another paragraph")))
    


;;+++++++++ second tab

(defun html-help2 ()
  (with-html-np
    (:b (:a :href "#" :class "jqmClose" (:em "Close")))
    (:hr)
    (:h1 "All categories")
    (:p "This panel lets you browse the different ideas which has been associated with the Tractatus. By selecting one of the ideas you can reorder the paragraphs shown in the middle panel. You just have to click on the '+' sign each idea has to bring it into focus and start exploring its meaning.<br />Notice how the ideas have been classified into <b>eight major categories</b>. A group of experts have defined them as the most simple ways to describe the key 'types' of ideas in the world of philosophy.  <br />This organization is clearly highly subjective: you might agree or not with it. Indeed, one of the goals of PhiloSURFical is to test how well these categories support the navigation process. You can find out more about them in the 'browse the ontology' panel, under the class <i>philosophical idea</i>. ")))
 ;;   (:p "this is just another paragraph")))


(defun html-help3 ()
  (with-html-np
    (:b (:a :href "#" :class "jqmClose" (:em "Close")))
    (:hr)
    (:h1 "Describe annotation")
    (:p "This panel shows the most recent idea you clicked on. You can use as an indication of the <i>active</i> annotation, so to make sense of the information displayed in the other panels and in the central text area.<br />Some annotations have also an <i>abstract</i> associated with them: this is just a brief explanation of the meaning of the idea, in order to help understanding of the original text.")))
   ;; (:p "this is just another paragraph")))



(defun html-help4 ()
  (with-html-np
    (:b (:a :href "#" :class "jqmClose" (:em "Close")))
    (:hr)
    (:h1 "Local Annotations")
    (:p "This panel shows the local annotations of the text area you clicked on. In other words, by focusing on a specific paragraph of the Tractatus you can see here what ideas have been associated with it. <br />This analytical work on Wittgenstein's text has been done by two dedicated philosophers, trying to reflect the most common interpretations in the Tractatus' commentaries. <br /><br />Also here, when you click on the '+' near to the idea-name the focus of the other panel changes accordingly.")))
  ;;  (:p "this is just another paragraph")))



(defun html-help5 ()
  (with-html-np
    (:b (:a :href "#" :class "jqmClose" (:em "Close")))
    (:hr)
    (:h1 "Inspect annotation")
    (:p "This panel serves as a <i>map</i> of the interconnections among ideas. The orientation of the map is determined by the most recent idea which has been selected: by clicking on the '+' sign next to an annotation, the active idea is updated and also the map gets re-organized accordingly. <br />By inspecting an annotation, you can find out which are the various <b>relations</b> that link it to its neighboring annotations. These relations may help in understanding the sense of an idea and possibly in better positioning it within the larger network of Wittgenstein's ideas. <br />By clicking on the ideas you like, the map can be used to browse the text in non-conventional ways.")))
   ;; (:p "this is just another paragraph")))



;;; +++++++++++ third tab


(defun html-help6 ()
  (with-html-np
    (:b (:a :href "#" :class "jqmClose" (:em "Close")))
    (:hr)
    (:h1 "Browse the Pathways - starting point")
    (:p "From here you can select an entity in the <i>philosophical world</i> (e.g. an idea, person etc.) and explore further associated resources by means of several 'learning pathways' which go beyond the context of the Tractatus. <br /><br />In the 'starting point' tab you usually see the <b>most recent annotation</b> you clicked on, selected as the starting point of the navigation. If you want, you can <b>choose a different content</b>, by selecting it from the window that pops up when 'choose another content' is clicked. <br /><br />All the available information related to a content appears at the bottom: the information is presented with the structure it has in the PhiloSURFical knowledge base. Once you are happy with what is selected, the <b>two buttons</b> on the right let you either use it to explore the available pathways or to save its details in the 'recent items' panel.")))
;;    (:p "this is just another paragraph")))

(defun html-help7 ()
  (with-html-np
    (:b (:a :href "#" :class "jqmClose" (:em "Close")))
    (:hr)
    (:h1 "Available pathways")
    (:p "In this panel you can see a list of the available 'learning pathways' for a chosen content. The pathways can be of different type (e.g. historical, geographical, theoretical) depending on the type of ontological relations employed when constructing them. The available pathways will appear in a vertical list, ordered by types. Move the mouse over their names and  a short description will appear next to them. <br /><br />When you click on them, instead, the panel on the right side of the screen is activated and a graphical view of the pathway results is shown. From there, you can resize the graph by digiting <b>Command+click</b>. You can also select items of interest by pressing <b>Alt+click</b> on their names: a reference to them will be created on the 'recent items' panel.")))
  


(defun html-help8 ()
  (with-html-np
    (:b (:a :href "#" :class "jqmClose" (:em "Close")))
    (:hr)
    (:h1 "Recent items")
    (:p "In this panel you can find the contents you saved from the 'starting point' panel or from the 'graphical' one. <br /><br />The <i>saved topics box</i> can be used for storing items you found particularly interesting and want to explore more (e.g. by using them as a starting point for other type of pathways). <br /><br />Just <b>click on an item when highlighted </b>in order to select it and bring it into focus as a new starting point. If instead the item is a web-link to another resource, it will open in a pop up window.")))



(defun html-help9 ()
  (with-html-np
    (:b (:a :href "#" :class "jqmClose" (:em "Close")))
    (:hr)
    (:h1 "Browse the Ontology")
    (:p "This panel lets you navigate through the ontology that PhiloSURFical uses in order to describe and reason on the various type of resources it's presenting. As you can see, an ontology in artifical intelligence is an abstract model, a formal description of the <i>types</i> or <i>categories</i> a software program uses to perform its tasks. <br />In other words, it is the formal and structured specification of a <b>computational language</b>. <br />The philoSURFical ontology has been created as an extension of another ontology, CIDOC. This is a well known ISO-standard for representing cultural heritage data, widely used by many museums and other institutions too. <br />By expanding the tree on the left and clicking on the classes' names you can see their formal description on the right panel. <br />You can find out much more about this ontology by looking at the publications on the <a href=\"http://philosurfical.open.ac.uk/publication.html\" target=\"_blank\">PhiloSURfical site.</a>.")))
  ;;  (:p "this is just another paragraph")))
