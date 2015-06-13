/**
 * Interface Elements for jQuery
 * Selectables
 * 
 * http://interface.eyecon.ro
 * 
 * Copyright (c) 2006 Stefan Petre
 * Dual licensed under the MIT (MIT-LICENSE.txt) 
 * and GPL (GPL-LICENSE.txt) licenses.
 *   
 *
 */

jQuery.selectHelper = null;
jQuery.selectKeyHelper = null;
jQuery.selectdrug = null;
jQuery.selectKeyDown = function(e)
{
	if (window.event) {
		code = window.event.keyCode;
	} else {
		code = e.which;
	}
	if (code == 17) {
		jQuery.selectKeyHelper = true;
	}
};
jQuery.selectKeyUp = function(e)
{
	jQuery.selectKeyHelper = false;
};
jQuery.selectstart = function(e)
{
	if (window.event) {
		window.event.cancelBubble = true;
		window.event.returnValue = false;
		this.f.sx = window.event.clientX + document.documentElement.scrollLeft + document.body.scrollLeft;
		this.f.sy = window.event.clientY + document.documentElement.scrollTop + document.body.scrollTop;
	} else {
		e.preventDefault();
		e.stopPropagation();
		this.f.sx = e.clientX;
		this.f.sy = e.clientY;
	}
	this.f.pos = jQuery.iUtil.getPos(this);
	if (
		this.clientWidth && 
		(
			(this.f.pos.x + this.clientWidth) < this.f.sx 
			|| 
			(this.f.pos.y + this.clientHeight) < this.f.sy
		)
	) {
		return;
	}
	this.f.sx --;
	this.f.sy --;
	this.f.scr = jQuery.iUtil.getScroll(this);
	this.f.pos.sx += this.f.scr.l;
	this.f.pos.sy += this.f.scr.t;
	jQuery(this).append(jQuery.selectHelper.get(0));
	if (this.f.hc)
		jQuery.selectHelper.addClass(this.f.hc).css('display','block');
	jQuery.selectHelper.css(
		{
			display: 'block',
			width: '0px',
			height: '0px'
		}
	);
	if (this.f.o) {
		jQuery.selectHelper.css('opacity', this.f.o);
		if (window.ActiveXObject) {
			jQuery.selectHelper.css('filter', 'alpha(opacity=' + this.f.o * 100 + ')');
		}
	}
	
	jQuery.selectdrug = this;
	jQuery.selectedone = false;
	this.f.el.each(
		function ()
		{
			this.pos = jQuery.iUtil.getPos(this);
			if (this.s == true) {
				if (jQuery.selectKeyHelper == false) {
					this.s = false;
					jQuery(this).removeClass(jQuery.selectdrug.f.sc);
				} else {
					jQuery.selectedone = true;
				}
			}
		}
	);
	jQuery.selectcheck(null, this.f.sx + 1, this.f.sy + 1, this);
};
jQuery.selectcheck = function(e, nx, ny, el)
{
	if(!jQuery.selectdrug)
		return; 
	if (e) {
		if (window.event) {
			window.event.cancelBubble = true;
			window.event.returnValue = false;
			nx = window.event.clientX + document.documentElement.scrollLeft + document.body.scrollLeft;
			ny = window.event.clientY + document.documentElement.scrollTop + document.body.scrollTop;
		} else {
			e.preventDefault();
			e.stopPropagation();
			nx = e.clientX;
			ny = e.clientY;
		}
	}
	if (!el) {
		el = this;
	}
	if (el.clientWidth && nx > (el.f.pos.x + el.clientWidth)) {
		nx = el.f.pos.x + el.clientWidth;
	}
	if (el.clientHeight && ny > (el.f.pos.y + el.clientHeight)) {
		ny = el.f.pos.y + el.clientHeight;
	}
	scr = jQuery.iUtil.getScroll(el);
	mt = ny - el.f.pos.y;
	mb = el.f.pos.y + el.f.pos.h - ny;
	ml = nx - el.f.pos.x;
	mr = el.f.pos.x + el.f.pos.w - nx;
	if (mt < 40 && el.scrollTop > 0){
		if (el.scrollTop > 10) {
			el.scrollTop -= 10;
			el.f.sy += 10;
		} else {
			el.f.sy += el.scrollTop;
			el.scrollTop = 0;
		}
	} else if (mb < 40 && el.scrollTop < (el.scrollHeight - el.f.pos.h)) {
		if ((el.scrollHeight - el.f.pos.h - el.scrollTop) > 10) {
			el.scrollTop += 10;
			el.f.sy -= 10;
		} else {
			el.f.sy -= el.scrollHeight - el.f.pos.h - el.scrollTop;
			el.scrollTop = el.scrollHeight - el.f.pos.h;
		}
	}
	if (ml < 40 && el.scrollLeft > 0){
		if (el.scrollLeft > 10) {
			el.scrollLeft -= 10;
			el.f.sx += 10;
		} else {
			el.f.sx += el.scrollLeft;
			el.scrollLeft = 0;
		}
	} else if (mr < 40 && el.scrollLeft < (el.scrollWidth - el.f.pos.w)) {
		if ((el.scrollWidth - el.f.pos.w - el.scrollLeft) > 10) {
			el.scrollLeft += 10;
			el.f.sx -= 10;
		} else {
			el.f.sx -= el.scrollWidth - el.f.pos.w - el.scrollLeft;
			el.scrollLeft = el.scrollWidth - el.f.pos.w;
		}
	}
	
	if (nx > el.f.sx){
		sx = el.f.sx;
		sw = nx - el.f.sx;
	} else {
		sx = nx;
		sw = el.f.sx - nx;
	}
	if (ny > el.f.sy){
		sy = el.f.sy;
		sh = ny - el.f.sy;
	} else {
		sy = ny;
		sh = el.f.sy - ny;
	}
	jQuery.selectHelper.css(
		{
			left:	sx + scr.l - el.f.pos.x + 'px',
			top:	sy + scr.t - el.f.pos.y + 'px',
			width:	sw + 'px',
			height:	sh + 'px'
		}
	);
	jQuery.selectHelper.l = sx + scr.l;
	jQuery.selectHelper.t = sy + scr.t;
	jQuery.selectHelper.r = jQuery.selectHelper.l + sw;
	jQuery.selectHelper.b = jQuery.selectHelper.t + sh;
	jQuery.selectedone = false;
	el.f.el.each(
		function ()
		{
			if (
				! ( this.pos.x > jQuery.selectHelper.r
				|| (this.pos.x + this.pos.w) < jQuery.selectHelper.l 
				|| this.pos.y > jQuery.selectHelper.b 
				|| (this.pos.y + this.pos.h) < jQuery.selectHelper.t 
				)
			)
			{
				jQuery.selectedone = true;
				if (this.s != true) {
					this.s = true;
					jQuery(this).addClass(jQuery.selectdrug.f.sc);
				}
			} else if (this.s == true && jQuery.selectKeyHelper != true) {
				this.s = false;
				jQuery(this).removeClass(jQuery.selectdrug.f.sc);
			}
		}
	);
};
jQuery.selectstop = function(e)
{
	if(!jQuery.selectdrug)
		return; 
	jQuery.selectHelper.css('display','none');
	if (this.f.hc)
		jQuery.selectHelper.removeClass(this.f.hc);
	jQuery.selectdrug = false;
	jQuery('body').append(jQuery.selectHelper.get(0));
	if (jQuery.selectedone == true && this.f.onselect) {
		this.f.onselect(jQuery.Selectserialize(jQuery.attr(this,'id')));
	}
};

jQuery.Selectserialize = function(s)
{
	var h = '';
	var o = [];
	if (a = jQuery('#' + s)) {
		a.get(0).f.el.each(
			function ()
			{
				if (this.s == true) {
					if (h.length > 0) {
						h += '&';
					}
					h += s + '[]=' + jQuery.attr(this,'id');
					o[o.length] = jQuery.attr(this,'id');
				}
			}
		);
	}
	return {hash:h, o:o};
};
jQuery.fn.Selectable = function(o)
{
	if (!jQuery.selectHelper) {
		jQuery('body',document).append('<div id="selectHelper"></div>').bind('keydown', jQuery.selectKeyDown).bind('keyup', jQuery.selectKeyUp);
		jQuery.selectHelper = jQuery('#selectHelper');
		jQuery.selectHelper.css(
			{
				position:	'absolute',
				display:	'none'
			}
		);
		
		if (window.event) {
			jQuery('body',document).bind('keydown', jQuery.selectKeyDown).bind('keyup', jQuery.selectKeyUp);
		} else {
			jQuery(document).bind('keydown', jQuery.selectKeyDown).bind('keyup', jQuery.selectKeyUp);
		}
	}

    if (!o) {
		o = {};
	}
    return this.each(
		function()
		{
			if (this.isSelectable)
				return;
			this.isSelectable = true;
			this.f = {
				a : o.accept,
				o : o.opacity ? parseFloat(o.opacity) : false,
				sc : o.selectedclass ? o.selectedclass : false,
				hc : o.helperclass ? o.helperclass : false,
				onselect : o.onselect ? o.onselect : false
			};
			this.f.el = jQuery('.' + o.accept);
			jQuery(this).bind('mousedown', jQuery.selectstart).bind('mousemove', jQuery.selectcheck).bind('mouseup', jQuery.selectstop).css('position', 'relative');
		}
	);
};