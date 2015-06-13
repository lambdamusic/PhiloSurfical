/**
 * Interface Elements for jQuery
 * FX - transfer
 * 
 * http://interface.eyecon.ro
 * 
 * Copyright (c) 2006 Stefan Petre
 * Dual licensed under the MIT (MIT-LICENSE.txt) 
 * and GPL (GPL-LICENSE.txt) licenses.
 *   
 *
 */

jQuery.transferHelper = null;
jQuery.fn.TransferTo = function(o)
{
	return this.queue('interfaceFX', function(){
		new jQuery.fx.itransferTo(this, o);
	});
};
jQuery.fx.itransferTo = function(e, o)
{
	
	if(jQuery.transferHelper == null)
	{
		jQuery('body', document).append('<div id="transferHelper"></div>');
		jQuery.transferHelper = jQuery('#transferHelper');
	}
	jQuery.transferHelper.css('display', 'block').css('position', 'absolute');
	
	var z = this;
	z.el = jQuery(e);
	if(!o || !o.to) {
		return;
	}
	
	if (o.to.constructor == String && document.getElementById(o.to)) {
		o.to = document.getElementById(o.to);
	} else if ( !o.to.childNodes ) {
		return;
	}
	
	if (!o.duration) {
		o.duration = 500;
	}
	z.duration = o.duration;
	z.to = o.to;
	z.classname = o.className;
	z.complete = o.complete;
	if (z.classname) {
		jQuery.transferHelper.addClass(z.classname);
	}
	z.start = jQuery.extend(
		jQuery.iUtil.getPosition(z.el.get(0)),
		jQuery.iUtil.getSize(z.el.get(0))
	);
	z.end = jQuery.extend(
		jQuery.iUtil.getPosition(z.to),
		jQuery.iUtil.getSize(z.to)
	);
	z.callback = o.complete;
	jQuery.transferHelper
		.css('width', z.start.wb + 'px')
		.css('height', z.start.hb + 'px')
		.css('top', z.start.y + 'px')
		.css('left', z.start.x + 'px')
		.animate(
			{
				top: z.end.y,
				left: z.end.x,
				width: z.end.wb,
				height: z.end.hb
			},
			z.duration,
			function()
			{
				if(z.classname)
					jQuery.transferHelper.removeClass(z.classname);
				jQuery.transferHelper.css('display', 'none');
				if (z.complete && z.complete.constructor == Function) {
					z.complete.apply(z.el.get(0), [z.to]);
				}
				jQuery.dequeue(z.el.get(0), 'interfaceFX');
			}
		);
};