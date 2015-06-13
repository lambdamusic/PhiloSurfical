/**
 * Interface Elements for jQuery
 * Droppables
 * 
 * http://interface.eyecon.ro
 * 
 * Copyright (c) 2006 Stefan Petre
 * Dual licensed under the MIT (MIT-LICENSE.txt) 
 * and GPL (GPL-LICENSE.txt) licenses.
 *   
 *
 */

jQuery.iDrop = {
	fit : function (zonex, zoney, zonew, zoneh)
	{
		return 	zonex <= jQuery.iDrag.dragged.dragCfg.nx && 
				(zonex + zonew) >= (jQuery.iDrag.dragged.dragCfg.nx + jQuery.iDrag.dragged.dragCfg.oC.w) &&
				zoney <= jQuery.iDrag.dragged.dragCfg.ny && 
				(zoney + zoneh) >= (jQuery.iDrag.dragged.dragCfg.ny + jQuery.iDrag.dragged.dragCfg.oC.h) ? true :false;
	},
	intersect : function (zonex, zoney, zonew, zoneh)
	{
		return 	! ( zonex > (jQuery.iDrag.dragged.dragCfg.nx + jQuery.iDrag.dragged.dragCfg.oC.w)
				|| (zonex + zonew) < jQuery.iDrag.dragged.dragCfg.nx 
				|| zoney > (jQuery.iDrag.dragged.dragCfg.ny + jQuery.iDrag.dragged.dragCfg.oC.h) 
				|| (zoney + zoneh) < jQuery.iDrag.dragged.dragCfg.ny
				) ? true :false;
	},
	pointer : function (zonex, zoney, zonew, zoneh)
	{
		return	zonex < jQuery.iDrag.dragged.dragCfg.currentPointer.x
				&& (zonex + zonew) > jQuery.iDrag.dragged.dragCfg.currentPointer.x 
				&& zoney < jQuery.iDrag.dragged.dragCfg.currentPointer.y 
				&& (zoney + zoneh) > jQuery.iDrag.dragged.dragCfg.currentPointer.y
				? true :false;
	},
	overzone : false,
	highlighted : {},
	count : 0,
	zones : {},
	
	highlight : function (elm)
	{
		if (jQuery.iDrag.dragged == null) {
			return;
		}
		var i;
		jQuery.iDrop.highlighted = {};
		oneIsSortable = false;
		for (i in jQuery.iDrop.zones) {
			if (jQuery.iDrop.zones[i] != null) {
				iEL = jQuery.iDrop.zones[i].get(0);
				if (jQuery.className.has(jQuery.iDrag.dragged,iEL.dropCfg.a)) {
					if (iEL.dropCfg.m == false) {
						iEL.dropCfg.p = jQuery.extend(
							jQuery.iUtil.getPosition(iEL),
							jQuery.iUtil.getSize(iEL)
						);//jQuery.iUtil.getPos(iEL);
						iEL.dropCfg.m = true;
					}
					if (iEL.dropCfg.ac) {
						jQuery.iDrop.zones[i].addClass(iEL.dropCfg.ac);
					}
					jQuery.iDrop.highlighted[i] = jQuery.iDrop.zones[i];
					//if (jQuery.iSort && jQuery.iDrag.dragged.dragCfg.so) {
					if (jQuery.iSort && iEL.dropCfg.s == true) {
						iEL.dropCfg.el = jQuery('.' + iEL.dropCfg.a, iEL);
						elm.style.display = 'none';
						jQuery.iSort.measure(iEL);
						elm.style.display = elm.dragCfg.oD;
						oneIsSortable = true;
					}
				}
			}
		}
		//if (jQuery.iSort && jQuery.iDrag.dragged.dragCfg.so) {
		if (oneIsSortable) {
			jQuery.iSort.start();
		}
	},
	/**
	 * remeasure the droppable
	 * 
	 * useful when the positions/dimensions for droppables 
	 * are changed while dragging a element
	 * 
	 * this works for sortables too but with a greate processor 
	 * penality because remeasures each sort items too
	 */
	remeasure : function()
	{
		jQuery.iDrop.highlighted = {};
		for (i in jQuery.iDrop.zones) {
			if (jQuery.iDrop.zones[i] != null) {
				iEL = jQuery.iDrop.zones[i].get(0);
				if (jQuery.className.has(jQuery.iDrag.dragged,iEL.dropCfg.a)) {
					iEL.dropCfg.p = jQuery.extend(
						jQuery.iUtil.getPosition(iEL),
						jQuery.iUtil.getSize(iEL)
					);
					if (iEL.dropCfg.ac) {
						jQuery.iDrop.zones[i].addClass(iEL.dropCfg.ac);
					}
					jQuery.iDrop.highlighted[i] = jQuery.iDrop.zones[i];
					
					if (jQuery.iSort && iEL.dropCfg.s == true) {
						iEL.dropCfg.el = jQuery('.' + iEL.dropCfg.a, iEL);
						elm.style.display = 'none';
						jQuery.iSort.measure(iEL);
						elm.style.display = elm.dragCfg.oD;
						oneIsSortable = true;
					}
				}
			}
		}
	},
	
	checkhover : function (e)
	{
		if (jQuery.iDrag.dragged == null) {
			return;
		}
		jQuery.iDrop.overzone = false;
		var i;
		applyOnHover = false;
		for (i in jQuery.iDrop.highlighted)
		{
			iEL = jQuery.iDrop.highlighted[i].get(0);
			if ( 
					jQuery.iDrop.overzone == false
					 && 
					 jQuery.iDrop[iEL.dropCfg.t](
					 	iEL.dropCfg.p.x, 
						iEL.dropCfg.p.y, 
						iEL.dropCfg.p.wb, 
						iEL.dropCfg.p.hb
					) 
				) {
				if (iEL.dropCfg.hc && iEL.dropCfg.h == false) {
					jQuery.iDrop.highlighted[i].removeClass(iEL.dropCfg.ac);
					jQuery.iDrop.highlighted[i].addClass(iEL.dropCfg.hc);
				}
				//chec if onHover function has to be called
				if (iEL.dropCfg.h == false &&iEL.dropCfg.onHover) {
					applyOnHover = true;
				}
				iEL.dropCfg.h = true;
				jQuery.iDrop.overzone = iEL;
				//if(jQuery.iSort && jQuery.iDrag.dragged.dragCfg.so) {
				if(jQuery.iSort && iEL.dropCfg.s == true) {
					jQuery.iSort.helper.get(0).className = iEL.dropCfg.shc;
					jQuery.iSort.checkhover(iEL);
				}
			} else {
				//onOut function
				if (iEL.dropCfg.onOut && iEL.dropCfg.h == true) {
					iEL.dropCfg.onOut.apply(iEL, [e, clonedEl, iEL.dropCfg.fx]);
				}
				if (iEL.dropCfg.hc) {
					jQuery.iDrop.highlighted[i].removeClass(iEL.dropCfg.hc);
					jQuery.iDrop.highlighted[i].addClass(iEL.dropCfg.ac);
				}
				iEL.dropCfg.h = false;
			}
		}
		if (jQuery.iSort && jQuery.iDrop.overzone == false) {
			jQuery.iSort.helper.get(0).style.display = 'none';
			jQuery('body').append(jQuery.iSort.helper.get(0));
		}
		//call onhover
		if(applyOnHover) {
			jQuery.iDrop.overzone.dropCfg.onHover.apply(jQuery.iDrop.overzone, [e, clonedEl]);
		}
	},
	checkdrop : function (e)
	{
		var i;
		for (i in jQuery.iDrop.highlighted) {
			iEL = jQuery.iDrop.highlighted[i].get(0);
			if (iEL.dropCfg.ac) {
				jQuery.iDrop.highlighted[i].removeClass(iEL.dropCfg.ac);
			}
			if (iEL.dropCfg.hc) {
				jQuery.iDrop.highlighted[i].removeClass(iEL.dropCfg.hc);
			}
			if(iEL.dropCfg.s) {
				jQuery.iSort.changed[jQuery.iSort.changed.length] = i;
			}
			if (iEL.dropCfg.onDrop && iEL.dropCfg.h == true) {
				iEL.dropCfg.h = false;
				iEL.dropCfg.onDrop.apply(iEL, [e, iEL.dropCfg.fx]);
			}
			iEL.dropCfg.m = false;
			iEL.dropCfg.h  = false;
		}
		jQuery.iDrop.highlighted = {};
	},
	destroy : function()
	{
		return this.each(
			function()
			{
				if (this.isDroppable) {
					if (this.dropCfg.s) {
						id = jQuery.attr(this,'id');
						jQuery.iSort.collected[id] = null;
						jQuery('.' + this.dropCfg.a, this).DraggableDestroy();
					}
					jQuery.iDrop.zones['d' + this.idsa] = null;
					this.isDroppable = false;
					this.f = null;
				}
			}
		);
	},
	build : function (o)
	{
		return this.each(
			function()
			{
				if (this.isDroppable == true || !o.accept || !jQuery.iUtil || !jQuery.iDrag){
					return;
				}
				this.dropCfg = {
					a : o.accept,
					ac: o.activeclass, 
					hc:	o.hoverclass,
					shc: o.helperclass,
					onDrop:	o.ondrop||o.onDrop,
					onHover: o.onHover||o.onhover,
					onOut: o.onOut||o.onout,
					t: o.tolerance && ( o.tolerance == 'fit' || o.tolerance == 'intersect') ? o.tolerance : 'pointer',
					fx: o.fx ? o.fx : false,
					m: false,
					h: false
				};
				if (o.sortable == true && jQuery.iSort) {
					id = jQuery.attr(this,'id');
					jQuery.iSort.collected[id] = this.dropCfg.a;
					this.dropCfg.s = true;
					if(o.onchange) {
						this.dropCfg.onchange = o.onchange;
						this.dropCfg.os = jQuery.iSort.serialize(id).hash;
					}
				}
				this.isDroppable = true;
				this.idsa = parseInt(Math.random() * 10000);
				jQuery.iDrop.zones['d' + this.idsa] = jQuery(this);
				jQuery.iDrop.count ++;
			}
		);
	}
};

jQuery.fn.extend(
	{
		DroppableDestroy : jQuery.iDrop.destroy,
		Droppable : jQuery.iDrop.build
	}
);
jQuery.recallDroppables = jQuery.iDrop.remeasure;