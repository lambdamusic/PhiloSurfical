/**
 *
 *   Philosurfical javascript/ajax functions
 *   
 *   made by Michele Pasin @ knowledge media institute
 *
 */



/*  STUFF FOR THE POPUP   */

// construct for explorer compatibility
var newwindow = '';

function popitup(url) {
	if (!newwindow.closed && newwindow.location) {
		newwindow.location.href = url;
	}
	else {
		newwindow=window.open(url,'name','height=600,width=850, status=yes ');   /*resizable=1*/
		if (!newwindow.opener) newwindow.opener = self;
			 newwindow.moveTo(150,100);
	}
	if (window.focus) {newwindow.focus()}
	return false;
}



var faqwindow = '';

function faq_popup(url) {
	if (!faqwindow.closed && faqwindow.location) {
		faqwindow.location.href = url;
	}
	else {
		faqwindow=window.open(url,'name','height=600,width=550, status=1,  scrollbars=1 ');   
		/*resizable=1, location=1,=1*/
		if (!faqwindow.opener) faqwindow.opener = self;
			 faqwindow.moveTo(150,100);
	}
	if (window.focus) {faqwindow.focus()}
	return false;
}







/*   INIT: FUNCTIONS USED BY THE ONLOAD FUCNTION AT THE TOP   */

 function initnarratives() {
    $.get("init-narratives",
               function(data){
                  $("#content_right").empty().append(data);
               }
    );
 }

 function inittab1() {
       if (booleanTab1 == false)  {
    $.get("init-tab1",
               function(data){
                  $("#content_middle1").empty().append(data);
                  $('p').cluetip({attribute: 'tooltip', activation: 'click', width: '700px' });
                              }
           );
     booleanTab1 = true;   }
 }


 function inittab2() {
       if (booleanTab2 == false)  {
    $.get("init-tab2",
               function(data){
                  $("#content_middle2").empty().append(data);
                              }
           );
     booleanTab2 = true;   }
 }


 function inittab3() {
       if (booleanTab3 == false)  {
       /*     hideFocusBox();
          hidePathways(); */
          booleanTab3 = true; }
 }



  function initontology() {
          if (booleanTab4 == false)      {
    $.get("init-ontology",
               function(data){
                  $("#browser_left_navigation").empty().append(data);
                   newtree(); 
                   reloadHelp();
                  }
           );
      booleanTab4 = true; }
}





/*  SHOW/HIDE SECTIONS   */	

     function hideSelectionBox(){
     	$("#selection_box div.narrative_start:visible").slideUp("slow");
     	$("#selection_box h2").empty().append("Selection box (<a href='#' onclick='showSelectionBox()'>Open</a>)");	}

     function showSelectionBox(){
     	$("#selection_box div.narrative_start:hidden").slideDown("slow");
     	$("#selection_box h2").empty().append("Selection box (<a href='#' onclick='hideSelectionBox()'>Close</a>)");}	


     function hideFocusBox(){
     	$("#narrative_roll:visible ").slideUp("slow");
     	$("#focus_box  h2").empty().append("Focus box (<a href='#' onclick='showFocusBox()'>Open</a>)");	}

     function showFocusBox(){
     	$("#narrative_roll:hidden").slideDown("slow");
     	$("#focus_box h2").empty().append("Focus box (<a href='#' onclick='hideFocusBox()'>Close</a>)");}



     function hidePathways(){
     	$("#pathways_list div.activePathways:visible").slideUp("slow");
     	$("#pathways_list h2").empty().append("My-pathway box (<a href='#' onclick='showPathways()'>Open</a>)");	}

     function showPathways(){
     	$("#pathways_list div.activePathways:hidden").slideDown("slow");
     	$("#pathways_list h2").empty().append("My-pathway box (<a href='#' onclick='hidePathways()'>Close</a>)");}






/*  WHEN THE CATEGORIES PANEL IS CLICKED   */

function updateTab2(selection) {
	loadingData = "<h2>Loading the text annotated as " + selection + "....</h2><img src='/static/img/busy.gif' alt='loading' />"
	$("#content_middle2").empty().append(loadingData);
	
    $.get("update2",
          { metadata: selection },
               function(data){
                  $("#content_middle2").empty().append(data);
                  reloadHelp();
               }
    );

    $("#instance_desc").empty().append("<h2>loading...</h2>");
    $.get("update-info",
          { metadata: selection },
               function(data){
                  $("#instance_desc").empty().append(data);
                  reloadHelp();
               }
    );

    $("#content_bott_right").empty().append("<h2>loading...</h2>");
    $.get("update-map",
          { metadata: selection },
               function(data){
                  $("#content_bott_right").empty().append(data);
                  reloadHelp();
               }
    );

   updateActiveSelection (selection);


   /*document.getElementById('inspect-tabber').tabber.tabShow(0);*/

 }


/*   WHEN THE TEXT IS CLICKED, THE ANNOTATIONS COME OUT   */

 function metadataLoad(nodeid) {
	$("#content_top_right").empty().append("<h3>loading...</h3>");

    $.get("load-metadata",
          { id: nodeid },
               function(data){
                  $("#content_top_right").empty().append(data);
                reloadHelp();    }
    );
  document.getElementById('topics-tabber').tabber.tabShow(1);

 }




 /* UPDATES THE SELECT PANEL WHEN A NEW ITEM IS CLICKED */
function updateActiveSelection (newselection) {
	$("#selection_box #selection").attr("value", newselection);
    genInstanceInfo(newselection);	
}






/*    UPDATES the ONTO INFO TABS   */

function ontotabinfo(selection) {
	loadingData = "<b>Loading description of class " + selection + "....</b><img src='/static/img/busy.gif' alt='loading' />"
	  $("#browser_middle").empty().append(loadingData);
    $.get("onto-class-info",
          { metadata: selection },
               function(data){
                  $("#browser_middle").empty().append(data);

               }
    );
}





/*    NOT USED   */

 function updateTab2justText(selection) {
	loadingData = "<h3>Loading the text annotates as " + selection + "....</h3><img src='/static/img/busy.gif' alt='loading' />"
	  $("#content_middle2").empty().append(loadingData);
	
    $.get("update2",
          { metadata: selection },
               function(data){
                  $("#content_middle2").empty().append(data);
               }
    );

    $.get("update-map",
          { metadata: selection },
               function(data){
                  $("#content_bott_right").empty().append(data);
                  reloadHelp(); } 
    );
 }











/*   NARRATIVE FUNCTIONS   */



function genInstanceInfo (inst)  {
	$.get("get-instance-info",
          { instance: inst },
               function(data){
                  $("#instance_info").empty().append(data);
                            }
    			);	
}





  function startNewPathway ()   {
      /*  hideSelectionBox(); */
      choice =  $("#selection_box #selection").attr("value");
                 /*    document.getElementById("selection").value; */
	  document.getElementById('selection-tabber').tabber.tabShow(1);
	  loadingData = "<h3>Loading the available pathways for " + choice + "....</h3><img src='/static/img/busy.gif' alt='loading' />"
	  $("#narrative_roll").empty().append(loadingData);
	
      $.get("start-new-pathway",
               { instance: choice },
                   function(data){
                    $("#narrative_roll").empty().append(data);
                    reloadHelp();
                    /*  retoggleElements();
                    showFocusBox(); */
			
               }
         );
}



function describePathway (shortname)  {
	if (shortname)  {
   		$.get("pathway-info",
         	{ name: shortname },
              	function(data){
                 	$("#narrative_roll div.narrative_choices2").empty().append(data);
              	}
   				);
			}
		else  {
			$("#narrative_roll div.narrative_choices2").empty();
		}
}




/*   ADDS A STEP IN THE SAVE PANEL  */
 function addNarrativeStep () {
     /* hideSelectionBox(); */
    choice = $("#selection_box #selection").attr("value");
	insertNewStep (choice);
	document.getElementById('selection-tabber').tabber.tabShow(2);
 }



 /* function that gets the values from the applet */
function setIdea(data) {
		insertNewStep(data);
}



/*   Gets the instance-info from the backend, and updates the SAVE panel  */
function insertNewStep (step) {
	$.get("new-step",
          { instance: step },
               function(data){
                  	$("#pathways_list  div.activePathways").append(data);
               }
			
    );  
	setTimeout("document.getElementById('selection-tabber').tabber.tabShow(2);", 50);
	setTimeout("$(\"#pathways_list div.activePathways\").slideDown(\"fast\");", 500);
}



function clearNarrativeSteps () {
	$("#pathways_list  div.activePathways").empty();
}






function updateSelectionFromSaved (selection){
	updateActiveSelection (selection);
	document.getElementById('selection-tabber').tabber.tabShow(0);
}








/* HELL YEAH  */
function loadGraph(narrative, item) {

	applet = document.getElementById('cohereGraphApplet');    // i put it here 
	applet.setViewHeight(100);		
	applet.prepareGraph();

	$.get("build-graph-components",
        { narrativetype: narrative , narrativeitem: item },
             function(data){
                eval (data);
             }
     );

	applet.displayGraph();
}




/* mm not used i think  */

 function getnarrativeresults(item,narrative) {
    $.get("update-narratives",
          { metadata: item, path: narrative },
               function(data){
                  $("#content_right").empty().append(data);
               }
    );
 }

 function updatenarrativestep(item,narrative) {
    $.get("new-step",
          { metadata: item, path: narrative },
               function(data){
                  $("#narratives").append(data);
               }
    );
 }




/*   REFRESHING FUNCTIONS   */



function reloadAccordion(){
	  $('div.accordion> div').hide(); 
	  $('div.accordion> h3').click(function() {
	    var $nextDiv = $(this).next();
	    var $visibleSiblings = $nextDiv.siblings('div:visible');

	    if ($visibleSiblings.length ) {
	      $visibleSiblings.slideUp('fast', function() {
	        $nextDiv.slideToggle('slow');
	      });
	    } else {
	       $nextDiv.slideToggle('slow');
	    }
	  });  
   }





  function reloadHelp()   {
     $('body').append($('.jqmWindow'));     /*little hack*/
     $('#help1').jqm({ajax: 'help1', trigger: 'a.help1trigger' , overlay:60});
     $('#help2').jqm({ajax: 'help2', trigger: 'a.help2trigger' , overlay:60});
     $('#help3').jqm({ajax: 'help3', trigger: 'a.help3trigger' , overlay:60});
     $('#help4').jqm({ajax: 'help4', trigger: 'a.help4trigger' , overlay:60});
     $('#help5').jqm({ajax: 'help5', trigger: 'a.help5trigger' , overlay:60});
     $('#help6').jqm({ajax: 'help6', trigger: 'a.help6trigger' , overlay:60});
     $('#help7').jqm({ajax: 'help7', trigger: 'a.help7trigger' , overlay:60});
     $('#help8').jqm({ajax: 'help8', trigger: 'a.help8trigger' , overlay:60});
     $('#help9').jqm({ajax: 'help9', trigger: 'a.help9trigger' , overlay:60});



              }



function newtree()   {
	$("div > ul:first").Treeview({ speed: "fast", collapsed: true, control: "#ontocontrol" });
	$("div > ul:eq(1), div > ul:eq(3)").Treeview({ control: "#ontocontrol" });

		$("div > ul:last").Treeview({ speed: "fast", collapsed: true }); 
   }		         



   function retoggleElements()    {
       $('div.toggler-c').toggleElements( 
        { fxAnimation:'fade', fxSpeed:'slow', className:'toggler' });

       $('div.toggler-d').toggleElements( 
        { fxAnimation:'fade', fxSpeed:'fast', className:'toggler' });

    }


/*    NOT USED   */

 function refreshalltopics() {
    $.get("refresh-topics",
               function(data){
                  $("#content_left").empty().append(data);
                  reloadAccordion();
                  reloadHelp(); }
          );    
 }







   $(document).ready(function(){



 /* treeview code: three fucntions are needed, dont know why, but it works..... */

		$("div > ul:first").Treeview({ speed: "fast", collapsed: true, control: "#treecontrol" });
		/* by default, nodes are all open, unless closed is specified */ 


		$("div > ul:eq(1), div > ul:eq(3)").Treeview({ control: "#treecontrol" });

		/* 		the control container  */ 

 		$("div > ul:last").Treeview({ speed: "fast", collapsed: true }); 
		/* 		speed of animation, inherits from jquery animate */ 

	/* 	end of treeview code - we'll have to find out the truth about it! */



      /* TOGGLE ELEMENTS*/

   	   $('div.toggler-c').toggleElements( 
        { fxAnimation:'fade', fxSpeed:'slow', className:'toggler' });

       $('div.toggler-d').toggleElements( 
        { fxAnimation:'fade', fxSpeed:'fast', className:'toggler' });





    /* 	SUPERFISH*/

    $(".nav")
			.superfish({
				animation : { opacity:"show",height:"show"}
			})
			.find(">li:has(ul)") /* .find(">li[ul]") in jQuery less than v1.2*/
				.mouseover(function(){
					$("ul", this).bgIframe({opacity:false});
				})
				.find("a")
					.focus(function(){
						$("ul", $(".nav>li:has(ul)")).bgIframe({opacity:false});
						/* $("ul", $(".nav>li[ul]")).bgIframe({opacity:false});
						in jQuery less than v1.2*/
					});


     /*JQMODAL*/

     $('body').append($('.jqmWindow'));    /*little hack*/
     /*  $('#help0').jqm({ajax: 'help0', trigger: 'a.help0trigger' , overlay:60}); */
     $('#help1').jqm({ajax: 'help1', trigger: 'a.help1trigger' , overlay:60});
     $('#help2').jqm({ajax: 'help2', trigger: 'a.help2trigger' , overlay:60});
     $('#help3').jqm({ajax: 'help3', trigger: 'a.help3trigger' , overlay:60});
     $('#help4').jqm({ajax: 'help4', trigger: 'a.help4trigger' , overlay:60});
     $('#help5').jqm({ajax: 'help5', trigger: 'a.help5trigger' , overlay:60});
     $('#help6').jqm({ajax: 'help6', trigger: 'a.help6trigger' , overlay:60});
     $('#help7').jqm({ajax: 'help7', trigger: 'a.help7trigger' , overlay:60});
    /* old $('#dialog').jqm({overlay:60}); */  





    /*CLUETIP -- actually loaded when tab1 is initialized*/

    $('p').cluetip({attribute: 'tooltip', activation: 'click', width: '700px' });



    /*ACCORDION */

     reloadAccordion();



	});   <!--    end of document.ready function   !--> 




      /*booleans to avoid reloading existing stuff*/
       var booleanTab1 = new Boolean(false); 
       var booleanTab2 = new Boolean(false);
       var booleanTab3 = new Boolean(false);
       var booleanTab4 = new Boolean(false);

       document.write('<style type="text/css">.tabber{display:none;}</style>');


    window.resizeTo(1250,950); 

	setTimeout("initontology();", 500);
    setTimeout("inittab1();", 1000);
  	setTimeout("inittab2();", 1200);
  	setTimeout("inittab3();", 2300);
  	



