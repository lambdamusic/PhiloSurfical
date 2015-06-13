/**
 * Interface Elements for jQuery
 * FX - slide
 * 
 * http://interface.eyecon.ro
 * 
 * Copyright (c) 2006 Stefan Petre
 * Dual licensed under the MIT (MIT-LICENSE.txt) 
 * and GPL (GPL-LICENSE.txt) licenses.
 *   
 *
 */

jQuery.fn.extend(
	{
		SlideInUp : function (speed,callback, transition)
		{
			return this.queue('interfaceFX', function(){
				new jQuery.fx.slide(this, speed, callback, 'up', 'in', transition);
			});
		},
		
		SlideOutUp : function (speed,callback, transition)
		{
			return this.queue('interfaceFX', function(){
				new jQuery.fx.slide(this, speed, callback, 'up', 'out', transition);
			});
		},
		
		SlideToggleUp : function (speed,callback, transition)
		{
			return this.queue('interfaceFX', function(){
				new jQuery.fx.slide(this, speed, callback, 'up', 'toggle', transition);
			});
		},
		
		SlideInDown : function (speed,callback, transition)
		{
			return this.queue('interfaceFX', function(){
				new jQuery.fx.slide(this, speed, callback, 'down', 'in', transition);
			});
		},
		
		SlideOutDown : function (speed,callback, transition)
		{
			return this.queue('interfaceFX', function(){
				new jQuery.fx.slide(this, speed, callback, 'down', 'out', transition);
			});
		},
		
		SlideToggleDown : function (speed,callback, transition)
		{
			return this.queue('interfaceFX', function(){
				new jQuery.fx.slide(this, speed, callback, 'down', 'toggle', transition);
			});
		},
		
		SlideInLeft : function (speed,callback, transition)
		{
			return this.queue('interfaceFX', function(){
				new jQuery.fx.slide(this, speed, callback, 'left', 'in', transition);
			});
		},
		
		SlideOutLeft :  function (speed,callback, transition)
		{
			return this.queue('interfaceFX', function(){
				new jQuery.fx.slide(this, speed, callback, 'left', 'out', transition);
			});
		},
		
		SlideToggleLeft : function (speed,callback, transition)
		{
			return this.queue('interfaceFX', function(){
				new jQuery.fx.slide(this, speed, callback, 'left', 'toggle', transition);
			});
		},
		
		SlideInRight : function (speed,callback, transition)
		{
			return this.queue('interfaceFX', function(){
				new jQuery.fx.slide(this, speed, callback, 'right', 'in', transition);
			});
		},
		
		SlideOutRight : function (speed,callback, transition)
		{
			return this.queue('interfaceFX', function(){
				new jQuery.fx.slide(this, speed, callback, 'right', 'out', transition);
			});
		},
		
		SlideToggleRight : function (speed,callback, transition)
		{
			return this.queue('interfaceFX', function(){
				new jQuery.fx.slide(this, speed, callback, 'right', 'toggle', transition);
			});
		}
	}
);

jQuery.fx.slide = function(e, speed, callback, direction, type, transition)
{
	if (!jQuery.fxCheckTag(e)) {
		jQuery.dequeue(e, 'interfaceFX');
		return false;
	}
	var z = this;
	z.el = jQuery(e);
	z.transition = transition||'original';
	if ( type == 'toggle') {
		type = z.el.css('display') == 'none' ? 'in' : 'out';
	}
	if (!e.ifxFirstDisplay)
		e.ifxFirstDisplay = z.el.css('display');
	z.el.show();
	
	z.speed = speed;
	z.callback = callback;
	z.fx = jQuery.fx.buildWrapper(e);
	
	z.type = type;
	z.direction = direction;
	z.complete = function()
	{
		if(z.type == 'out')
			z.el.css('visibility', 'hidden');
		jQuery.fx.destroyWrapper(z.fx.wrapper.get(0), z.fx.oldStyle);
		if(z.type == 'in'){
			z.el.css('display', z.el.get(0).ifxFirstDisplay == 'none' ? 'block' : z.el.get(0).ifxFirstDisplay);
		} else {
			z.el.css('display', 'none');
			z.el.css('visibility', 'visible');
		}
		if (z.callback && z.callback.constructor == Function) {
			z.callback.apply(z.el.get(0));
		}
		jQuery.dequeue(z.el.get(0), 'interfaceFX');
	};
	switch (z.direction) {
		case 'up':
			z.ef = new jQuery.fx(
				z.el.get(0), 
				jQuery.speed(
					z.speed,
					z.complete
				),
				'top',
				z.transition
			);
			z.efx = new jQuery.fx(
				z.fx.wrapper.get(0), 
				jQuery.speed(
					z.speed
				),
				'height',
				z.transition
			);
			if (z.type == 'in') {
				z.ef.custom (-z.fx.oldStyle.sizes.hb, 0);
				z.efx.custom(0, z.fx.oldStyle.sizes.hb);
			} else {
				z.ef.custom (0, -z.fx.oldStyle.sizes.hb);
				z.efx.custom (z.fx.oldStyle.sizes.hb, 0);
			}
		break;
		case 'down':
			z.ef = new jQuery.fx(
				z.el.get(0), 
				jQuery.speed(
					z.speed,
					z.complete
				),
				'top',
				z.transition
			);
			if (z.type == 'in') {
				z.ef.custom (z.fx.oldStyle.sizes.hb, 0);
			} else {
				z.ef.custom (0, z.fx.oldStyle.sizes.hb);
			}
		break;
		case 'left':
			z.ef = new jQuery.fx(
				z.el.get(0), 
				jQuery.speed(
					z.speed,
					z.complete
				),
				'left',
				z.transition
			);
			z.efx = new jQuery.fx(
				z.fx.wrapper.get(0), 
				jQuery.speed(
					z.speed
				),
				'width',
				z.transition
			);
			if (z.type == 'in') {
				z.ef.custom (-z.fx.oldStyle.sizes.wb, 0);
				z.efx.custom (0, z.fx.oldStyle.sizes.wb);
			} else {
				z.ef.custom (0, -z.fx.oldStyle.sizes.wb);
				z.efx.custom (z.fx.oldStyle.sizes.wb, 0);
			}
		break;
		case 'right':
			z.ef = new jQuery.fx(
				z.el.get(0), 
				jQuery.speed(
					z.speed,
					z.complete
				),
				'left',
				z.transition
			);
			if (z.type == 'in') {
				z.ef.custom (z.fx.oldStyle.sizes.wb, 0);
			} else {
				z.ef.custom (0, z.fx.oldStyle.sizes.wb);
			}
		break;
	}
};
