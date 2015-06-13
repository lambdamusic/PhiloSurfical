/**
 * Interface Elements for jQuery
 * FX - drop
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
		DropOutDown : function (speed, callback, transition) {
			return this.queue('interfaceFX',function(){
				new jQuery.fx.DropOutDirectiont(this, speed, callback, 'down', 'out', transition);
			});
		},
		
		DropInDown : function (speed, callback, transition) {
			return this.queue('interfaceFX',function(){
				new jQuery.fx.DropOutDirectiont(this,  speed, callback, 'down', 'in', transition);
			});
		},
		
		DropToggleDown : function (speed, callback, transition) {
			return this.queue('interfaceFX',function(){
				new jQuery.fx.DropOutDirectiont(this,  speed, callback, 'down', 'toggle', transition);
			});
		},
		
		DropOutUp : function (speed, callback, transition) {
			return this.queue('interfaceFX',function(){
				new jQuery.fx.DropOutDirectiont(this, speed, callback, 'up', 'out', transition);
			});
		},
		
		DropInUp : function (speed, callback, transition) {
			return this.queue('interfaceFX',function(){
				new jQuery.fx.DropOutDirectiont(this,  speed, callback, 'up', 'in', transition);
			});
		},
		
		DropToggleUp : function (speed, callback, transition) {
			return this.queue('interfaceFX',function(){
				new jQuery.fx.DropOutDirectiont(this,  speed, callback, 'up', 'toggle', transition);
			});
		},
		
		DropOutLeft : function (speed, callback, transition) {
			return this.queue('interfaceFX',function(){
				new jQuery.fx.DropOutDirectiont(this, speed, callback, 'left', 'out', transition);
			});
		},
		
		DropInLeft : function (speed, callback, transition) {
			return this.queue('interfaceFX',function(){
				new jQuery.fx.DropOutDirectiont(this,  speed, callback, 'left', 'in', transition);
			});
		},
		
		DropToggleLeft : function (speed, callback, transition) {
			return this.queue('interfaceFX',function(){
				new jQuery.fx.DropOutDirectiont(this,  speed, callback, 'left', 'toggle', transition);
			});
		},
		
		DropOutRight : function (speed, callback, transition) {
			return this.queue('interfaceFX',function(){
				new jQuery.fx.DropOutDirectiont(this, speed, callback, 'right', 'out', transition);
			});
		},
		
		DropInRight : function (speed, callback, transition) {
			return this.queue('interfaceFX',function(){
				new jQuery.fx.DropOutDirectiont(this,  speed, callback, 'right', 'in', transition);
			});
		},
		
		DropToggleRight : function (speed, callback, transition) {
			return this.queue('interfaceFX',function(){
				new jQuery.fx.DropOutDirectiont(this,  speed, callback, 'right', 'toggle', transition);
			});
		}
	}
);

jQuery.fx.DropOutDirectiont = function (e, speed, callback, direction, type, transition)
{
	if (!jQuery.fxCheckTag(e)) {
		jQuery.dequeue(e, 'interfaceFX');
		return false;
	}
	var z = this;
	z.el = jQuery(e);
	z.transition = transition||'original';
	z.oldStyle = {};
	z.oldStyle.position = z.el.css('position');
	z.oldStyle.top = z.el.css('top');
	z.oldStyle.left = z.el.css('left');
	if (!e.ifxFirstDisplay)
		e.ifxFirstDisplay = z.el.css('display');
	if ( type == 'toggle') {
		type = z.el.css('display') == 'none' ? 'in' : 'out';
	}
	z.el.show();
	if (z.oldStyle.position != 'relative' && z.oldStyle.position != 'absolute') {
		z.el.css('position', 'relative');
	}
	z.type = type;
	/*sizes = ['em','px','pt','%'];
	for(i in sizes) {
		if (z.oldStyle.top.indexOf(sizes[i])>0) {
			z.topUnit = sizes[1];
			z.topSize = parseFloat(z.oldStyle.top)||0;
		}
		if (z.oldStyle.left.indexOf(sizes[i])>0) {
			z.leftUnit = sizes[1];
			z.leftSize = parseFloat(z.oldStyle.left)||0;
		}
	}*/
	
	directionIncrement = 1;
	switch (direction){
		case 'up':
			z.e = new jQuery.fx(z.el.get(0), jQuery.speed(speed - 15,callback), 'top', z.transition);
			z.point = parseFloat(z.oldStyle.top)||0;
			z.unit = z.topUnit;
			directionIncrement = -1;
		break;
		case 'down':
			z.e = new jQuery.fx(z.el.get(0), jQuery.speed(speed - 15,callback), 'top', z.transition);
			z.point = parseFloat(z.oldStyle.top)||0;
			z.unit = z.topUnit;
		break;
		case 'right':
			z.e = new jQuery.fx(z.el.get(0), jQuery.speed(speed - 15,callback), 'left', z.transition);
			z.point = parseFloat(z.oldStyle.left)||0;
			z.unit = z.leftUnit;
		break;
		case 'left':
			z.e = new jQuery.fx(z.el.get(0), jQuery.speed(speed - 15,callback), 'left', z.transition);
			z.point = parseFloat(z.oldStyle.left)||0;
			z.unit = z.leftUnit;
			directionIncrement = -1;
		break;
	}
	z.e2 = new jQuery.fx(
		z.el.get(0),
		jQuery.speed
		(
		 	speed,
			function()
			{
				z.el.css(z.oldStyle);
				if (z.type == 'out') {
					z.el.css('display', 'none');
				} else 
					z.el.css('display', z.el.get(0).ifxFirstDisplay == 'none' ? 'block' : z.el.get(0).ifxFirstDisplay);
				
				jQuery.dequeue(z.el.get(0), 'interfaceFX');
			}
		 ),
		'opacity', z.transition
	);
	if (type == 'in') {
		z.e.custom(z.point+ 100*directionIncrement, z.point);
		z.e2.custom(0,1);
	} else {
		z.e.custom(z.point, z.point + 100*directionIncrement);
		z.e2.custom(1,0);
	}
};