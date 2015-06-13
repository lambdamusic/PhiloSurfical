/*
 * Superfish v1.3 - jQuery menu widget
 *
 * Copyright (c) 2007 Joel Birch
 *
 * Dual licensed under the MIT and GPL licenses:
 * 	http://www.opensource.org/licenses/mit-license.php
 * 	http://www.gnu.org/licenses/gpl.html
 *
 * YOU MAY DELETE THIS CHANGELOG:
 * v1.2.1 altered: 2nd July 07. added hide() before animate to make work for jQuery 1.1.3. See comment in 'over' function.
 * v1.2.2 altered: 2nd August 07. changed over function .find('ul') to .find('>ul') for smoother animations
 * 				   Also deleted the iframe removal lines - not necessary it turns out
 * v1.2.3 altered: jquery 1.1.3.1 broke keyboard access - had to change quite a few things and set display:none on the
 *				   .superfish rule in CSS instead of top:-999em
 * v1.3	: 		   Pretty much a complete overhaul to make all original features work in 1.1.3.1 and above.
 *				   .superfish rule reverted back to top:-999em (which is better)
 */

(function($){
	$.fn.superfish = function(o){
		var $sf = this,
			defaults = {
			hoverClass	: 'sfHover',
			pathClass	: 'overideThisToUse',
			delay		: 800,
			animation	: {opacity:'show'},
			speed		: 'normal'
		},
			over = function(){
				clearTimeout(this.sfTimer);
				clearTimeout($sf[0].sfTimer);
				$(this)
				.showSuperfishUl()
				.siblings()
				.hideSuperfishUl();
			},
			out = function(){
				var $$ = $(this);
				if ( !$$.is('.'+o.bcClass) ) {
					this.sfTimer=setTimeout(function(){
						$$.hideSuperfishUl();
						if (!$('.'+o.hoverClass,$sf).length) { 
							over.call($currents.hideSuperfishUl());
						}
					},o.delay);
				}		
			};
		$.fn.extend({
			hideSuperfishUl : function(){
				return this
					.removeClass(o.hoverClass)
					.find('ul:visible')
						.hide()
					.end();
			},
			showSuperfishUl : function(){
				return this
					.addClass(o.hoverClass)
					.find('>ul:hidden')
						.animate(o.animation,o.speed,function(){
							$(this).removeAttr('style');
						})
					.end();
			},
			applySuperfishHovers : function(){
				return this[($.fn.hoverIntent) ? 'hoverIntent' : 'hover'](over,out);
			}
		});
		o = $.extend({bcClass:'sfbreadcrumb'},defaults,o || {});
		var $currents = $('.'+o.pathClass,this).filter('li[ul]');
		if ($currents.length) {
			$currents.each(function(){
				$(this).removeClass(o.pathClass).addClass(o.hoverClass+' '+o.bcClass);
			});
		}
		var $sfHovAr=$('li[ul]',this).applySuperfishHovers(over,out)
			.find('a').each(function(){
				var $a = $(this), $li = $a.parents('li');
				$a.focus(function(){
					over.call($li);
					return false;
				}).blur(function(){
					$li.removeClass(o.hoverClass);
				});
			})
			.end()
			.not('.'+o.bcClass)
				.hideSuperfishUl()
			.end();
		$(window).unload(function(){
			$sfHovAr.unbind('mouseover').unbind('mouseout');
		});
		return this.addClass('superfish').blur(function(){
			out.call(this);
		});
	};
})(jQuery);