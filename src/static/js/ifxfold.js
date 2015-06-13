/**
 * Interface Elements for jQuery
 * FX - fold
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
		Fold : function (speed, height, callback, transition)
		{
			return this.queue('interfaceFX',function(){
				new jQuery.fx.DoFold(this, speed, height, callback, 'fold', transition);
			});
		},
		
		UnFold : function (speed, height, callback, transition)
		{
			return this.queue('interfaceFX',function(){
				new jQuery.fx.DoFold(this, speed, height, callback, 'unfold', transition);
			});
		},
		
		FoldToggle : function (speed, height, callback, transition)
		{
			return this.queue('interfaceFX',function(){
				new jQuery.fx.DoFold(this, speed, height, callback, 'toggle', transition);
			});
		}
	}
);

jQuery.fx.DoFold = function (e, speed, height, callback, type, transition)
{
	if (!jQuery.fxCheckTag(e)) {
		jQuery.dequeue(e, 'interfaceFX');
		return false;
	}
	var z = this;
	z.el = jQuery(e);
	z.transition = transition||'original';
	if ( type == 'toggle') {
		type = z.el.css('display') == 'none' ? 'unfold' : 'fold';
	}
	//z.el.show();
	z.speed = speed;
	z.callback = callback;
	z.height = height && height.constructor == Number ? height : 20;
	z.fx = jQuery.fx.buildWrapper(e);
	z.type = type;
	z.complete = function()
	{
		if (z.callback && z.callback.constructor == Function) {
			z.callback.apply(z.el.get(0));
		}
		if(z.type == 'unfold'){
			z.el.show();
		} else {
			z.el.hide();
		}
		jQuery.fx.destroyWrapper(z.fx.wrapper.get(0), z.fx.oldStyle);
		jQuery.dequeue(z.el.get(0), 'interfaceFX');
	};
	if ( z.type == 'unfold') {
		z.el.show();
		z.fx.wrapper.css('height', z.height + 'px').css('width', '1px');
		
		z.ef = new jQuery.fx(
				z.fx.wrapper.get(0),
				jQuery.speed (
					z.speed,
					function()
					{
						z.ef = new jQuery.fx(
							z.fx.wrapper.get(0),
							jQuery.speed(
								z.speed, 
								z.complete
							),
							'height',
							z.transition
						);
						z.ef.custom(z.height, z.fx.oldStyle.sizes.hb);
					}
				), 
				'width',
				z.transition
			);
		z.ef.custom(0, z.fx.oldStyle.sizes.wb);
	} else {
		z.ef = new jQuery.fx(
				z.fx.wrapper.get(0),
				jQuery.speed(
					z.speed,
					function()
					{
						z.ef = new jQuery.fx(
							z.fx.wrapper.get(0),
							jQuery.speed(
								z.speed,
								z.complete
							),
							'width',
							z.transition
						);
						z.ef.custom(z.fx.oldStyle.sizes.wb, 0);
					}
				), 
				'height',
				z.transition
			);
		z.ef.custom(z.fx.oldStyle.sizes.hb, z.height);
	}
};

