/**
 * Interface Elements for jQuery
 * Sortables
 * 
 * http://interface.eyecon.ro
 * 
 * Copyright (c) 2006 Stefan Petre
 * Dual licensed under the MIT (MIT-LICENSE.txt) 
 * and GPL (GPL-LICENSE.txt) licenses.
 *   
 *
 */


jQuery.iSort = {
	changed : [],
	collected : {},
	helper : false,
	inFrontOf: null,
	
	start : function ()
	{
		if (jQuery.iDrag.dragged == null) {
			return;
		}
		var i;
		
		jQuery.iSort.helper.get(0).className = jQuery.iDrag.dragged.dragCfg.hpc;
		shs = jQuery.iSort.helper.get(0).style;
		shs.display = 'block';
		jQuery.iSort.helper.oC = jQuery.iUtil.getPos(jQuery.iSort.helper.get(0));
		
		shs.width = jQuery.iDrag.dragged.dragCfg.oC.wb + 'px';
		shs.height = jQuery.iDrag.dragged.dragCfg.oC.hb + 'px';
		//shs.cssFloat = jQuery.iDrag.dragged.dragCfg.oF;
		margins = jQuery.iUtil.getMargins(jQuery.iDrag.dragged);
		shs.marginTop = margins.t;
		shs.marginRight = margins.r;
		shs.marginBottom = margins.b;
		shs.marginLeft = margins.l;
		if (jQuery.iDrag.dragged.dragCfg.ghosting == true) {
			c = jQuery.iDrag.dragged.cloneNode(true);
			cs = c.style;
			cs.marginTop = '0px';
			cs.marginRight = '0px';
			cs.marginBottom = '0px';
			cs.marginLeft = '0px';
			cs.display = 'block';
			jQuery.iSort.helper.empty().append(c);
		}
		jQuery(jQuery.iDrag.dragged).after(jQuery.iSort.helper.get(0));
		jQuery.iDrag.dragged.style.display = 'none';
	},
	
	check : function (e)
	{
		if (!e.dragCfg.so && jQuery.iDrop.overzone.sortable) {
			if (e.dragCfg.onStop)
				e.dragCfg.onStop.apply(dragged);
			jQuery(e).css('position', e.dragCfg.initialPosition || e.dragCfg.oP);
			jQuery(e).DraggableDestroy();
			jQuery(jQuery.iDrop.overzone).SortableAddItem(e);
		}
		jQuery.iSort.helper.removeClass(e.dragCfg.hpc).html('&nbsp;');
		jQuery.iSort.inFrontOf = null;
		shs = jQuery.iSort.helper.get(0).style;
		shs.display = 'none';
		ts = [];
		fnc = false;
		for(i in jQuery.iSort.changed){
			iEL = jQuery.iDrop.zones[jQuery.iSort.changed[i]].get(0);
			id = jQuery.attr(iEL, 'id');
			ser = jQuery.iSort.serialize(id);
			if (iEL.dropCfg.os != ser.hash) {
				iEL.dropCfg.os = ser.hash;
				if (fnc == false && iEL.dropCfg.onchange) {
					fnc = iEL.dropCfg.onchange;
				}
				ser.id = id;
				ts[ts.length] = ser;
			}
		}
		if (fnc != false && ts.length > 0) {
			fnc(ts);
		}
		jQuery.iSort.changed = [];
	
	},
	
	checkhover : function(e,o)
	{
		if (!jQuery.iDrag.dragged)
			return;
		jQuery.iSort.helper.get(0).style.display = 'block';
		var cur = false;
		var i = 0;
		if ( e.dropCfg.el.size() > 0) {
			for (i = e.dropCfg.el.size(); i >0; i--) {
				if (e.dropCfg.el.get(i-1) != jQuery.iDrag.dragged) {
					if (!e.sortCfg.floats) {
						if ( 
						(e.dropCfg.el.get(i-1).pos.y + e.dropCfg.el.get(i-1).pos.hb/2) > jQuery.iDrag.dragged.dragCfg.ny  
						) {
							cur = e.dropCfg.el.get(i-1);
						} else {
							break;
						}
					} else {
						if (
						(e.dropCfg.el.get(i-1).pos.x + e.dropCfg.el.get(i-1).pos.wb/2) > jQuery.iDrag.dragged.dragCfg.nx && 
						(e.dropCfg.el.get(i-1).pos.y + e.dropCfg.el.get(i-1).pos.hb/2) > jQuery.iDrag.dragged.dragCfg.ny  
						) {
							cur = e.dropCfg.el.get(i-1);
						}
					}
				}
			}
		}
		//helpos = jQuery.iUtil.getPos(jQuery.iSort.helper.get(0));
		if (cur && jQuery.iSort.inFrontOf != cur) {
			jQuery.iSort.inFrontOf = cur;
			jQuery(cur).before(jQuery.iSort.helper.get(0));
		} else if(!cur && (jQuery.iSort.inFrontOf != null || jQuery.iSort.helper.get(0).parentNode != e) ) {
			jQuery.iSort.inFrontOf = null;
			jQuery(e).append(jQuery.iSort.helper.get(0));
		}
	},
	
	measure : function (e)
	{
		if (jQuery.iDrag.dragged == null) {
			return;
		}
		var i;
		e.dropCfg.el.each (
			function ()
			{
				this.pos = jQuery.extend(
					jQuery.iUtil.getSize(this),
					jQuery.iUtil.getPosition(this)
					/*{
						x: this.offsetLeft||0 - this.parentNode.scrollLeft||0, 
						y: this.offsetTop||0 - this.parentNode.scrollTop||0
					}*/
				);
			}
		);
	},
	
	serialize : function(s)
	{
		var i;
		var h = '';
		var o = {};
		if (s) {
			if (jQuery.iSort.collected[s] ) {
				o[s] = [];
				jQuery('#' + s + ' .' + jQuery.iSort.collected[s]).each(
					function ()
					{
						if (h.length > 0) {
							h += '&';
						}
						h += s + '[]=' + jQuery.attr(this,'id');
						o[s][o[s].length] = jQuery.attr(this,'id');
					}
				);
			} else {
				for ( a in s) {
					if (jQuery.iSort.collected[s[a]] ) {
						o[s[a]] = [];			
						jQuery('#' + s[a] + ' .' + jQuery.iSort.collected[s[a]]).each(
							function ()
							{
								if (h.length > 0) {
									h += '&';
								}
								h += s[a] + '[]=' + jQuery.attr(this,'id');
								o[s[a]][o[s[a]].length] = jQuery.attr(this,'id');
							}
						);
					}
				}
			}
		} else {
			for ( i in jQuery.iSort.collected){
				o[i] = [];
				jQuery('#' + i + ' .' + jQuery.iSort.collected[i]).each(
					function ()
					{
						if (h.length > 0) {
							h += '&';
						}
						h += i + '[]=' + jQuery.attr(this,'id');
						o[i][o[i].length] = jQuery.attr(this,'id');
					}
				);
			}
		}
		return {hash:h, o:o};
	},
	
	addItem : function (e)
	{
		if ( !e.childNodes ) {
			return;
		}
		return this.each(
			function ()
			{
				if(!this.sortCfg || !jQuery.className.has(e, this.sortCfg.accept))
					jQuery(e).addClass(this.sortCfg.accept);
				jQuery(e).Draggable(this.sortCfg.dragCfg);
			}
		);
	},
	
	build : function (o)
	{
		if (o.accept && jQuery.iUtil && jQuery.iDrag && jQuery.iDrop) {
			if (!jQuery.iSort.helper) {
				jQuery('body',document).append('<div id="sortHelper">&nbsp;</div>');
				jQuery.iSort.helper = jQuery('#sortHelper');
				jQuery.iSort.helper.get(0).style.display = 'none';
			}
			this.Droppable(
				{
					accept :  o.accept,
					activeclass : o.activeclass ? o.activeclass : false,
					hoverclass : o.hoverclass ? o.hoverclass : false,
					helperclass : o.helperclass ? o.helperclass : false,
					onDrop: function (drag, fx) 
							{
								jQuery.iSort.helper.after(drag);
								if (fx > 0) {
									jQuery(drag).fadeIn(fx);
								}
							},
					onHover: o.onHover||o.onhover,
					onOut: o.onOut||o.onout,
					sortable : true,
					onChange : 	o.onChange||o.onchange,
					fx : o.fx ? o.fx : false,
					ghosting : o.ghosting ? true : false,
					tolerance: o.tolerance ? o.tolerance : 'pointer'
				}
			);
			
			return this.each(
				function()
				{
					dragCfg = {
						revert : o.revert? true : false,
						zindex : 3000,
						opacity : o.opacity ? parseFloat(o.opacity) : false,
						hpc : o.helperclass ? o.helperclass : false,
						fx : o.fx ? o.fx : false,
						so : true,
						ghosting : o.ghosting ? true : false,
						handle: o.handle ? o.handle : null,
						containment: o.containment ? o.containment : null,
						onStart : o.onStart && o.onStart.constructor == Function ? o.onStart : false,
						onStop : o.onStop && o.onStop.constructor == Function ? o.onStop : false,
						axis : /vertically|horizontally/.test(o.axis) ? o.axis : false,
						snapDistance : o.snapDistance ? parseInt(o.snapDistance)||0 : false,
						cursorAt: o.cursorAt ? o.cursorAt : false
					};
					jQuery('.' + o.accept, this).Draggable(dragCfg);
					this.isSortable = true;
					this.sortCfg = {
						accept :  o.accept,
						revert : o.revert? true : false,
						zindex : 3000,
						opacity : o.opacity ? parseFloat(o.opacity) : false,
						hpc : o.helperclass ? o.helperclass : false,
						fx : o.fx ? o.fx : false,
						so : true,
						ghosting : o.ghosting ? true : false,
						handle: o.handle ? o.handle : null,
						containment: o.containment ? o.containment : null,
						floats: o.floats ? true : false,
						dragCfg : dragCfg
					}
				}
			);
		}
	}
};
jQuery.fn.extend(
	{
		Sortable : jQuery.iSort.build,
		SortableAddItem : jQuery.iSort.addItem
	}
);
jQuery.SortSerialize = jQuery.iSort.serialize;