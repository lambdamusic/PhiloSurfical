/**
 * Interface Elements for jQuery
 * FX - Highlight
 * 
 * http://interface.eyecon.ro
 * 
 * Copyright (c) 2006 Stefan Petre
 * Dual licensed under the MIT (MIT-LICENSE.txt) 
 * and GPL (GPL-LICENSE.txt) licenses.
 *   
 *
 */

jQuery.fn.Highlight = function(duration, color, callback, transition) {
	return this.queue('interfaceFX',function(){
		new jQuery.fx.Highlight(this, duration, color, callback, transition);
	});
};

jQuery.fx.Highlight = function (e, duration, color, callback, transition)
{
	if (!jQuery.fxCheckTag(e) || !color) {
		jQuery.dequeue(e, 'interfaceFX');
		return false;
	}
	var z = this;
	z.transition = transition||'original';
	z.duration = jQuery.speed(duration).duration;
	z.callback = callback;
	z.el = jQuery(e);
	z.oldStyle = {
		backgroundColor : z.el.css('backgroundColor'),
		backgroundImage : z.el.css('backgroundImage')
	}
	
	if ((typeof color == 'object') && (color.constructor == Array)) {
		z.endColor = jQuery.fx.parseColor(color[1] || z.oldStyle.backgroundColor);
		z.startColor = jQuery.fx.parseColor(color[0]);
	} else {
		z.endColor = jQuery.fx.parseColor(z.oldStyle.backgroundColor);
		z.startColor = jQuery.fx.parseColor(color);
	}
	
	if (!z.endColor || !z.startColor) {
		jQuery.dequeue(e, 'interfaceFX');
		return false;
	}
	
	z.t=(new Date).getTime();
	z.clear = function(){clearInterval(z.timer);z.timer=null;};
	z.step = function(){
		var t = (new Date).getTime();
		var n = t - z.t;
		var p = n / z.duration;
		if (t >= z.duration+z.t) {
			setTimeout(
				function(){
					/*	o = 1;	
					if (z.type) {
						t = z.endTop;
						l = z.endLeft;
						if (z.type == 'puff')
							o = 0;
					}
					z.zoom(z.to, l, t, true, o);*/
					z.el.css(z.oldStyle);
					jQuery.dequeue(e, 'interfaceFX');
					if (z.callback && typeof z.callback == 'function') {
						z.callback.apply(z.el.get(0));
					}
				},
				13
			);
			z.clear();
		} else {
			o = 1;
			s = jQuery.fx.transitions(p, n, z.from, (z.to-z.from), z.duration, z.transition);
			newColor = {
				r: parseInt(jQuery.fx.transitions(p, n, z.startColor.r, (z.endColor.r-z.startColor.r), z.duration, z.transition)),
				g: parseInt(jQuery.fx.transitions(p, n, z.startColor.g, (z.endColor.g-z.startColor.g), z.duration, z.transition)),
				b: parseInt(jQuery.fx.transitions(p, n, z.startColor.b, (z.endColor.b-z.startColor.b), z.duration, z.transition))
			};
			z.el.css('backgroundColor', 'rgb(' + newColor.r + ',' + newColor.g + ',' + newColor.b + ')');
		}
	};
	z.timer=setInterval(function(){z.step();},13);

};