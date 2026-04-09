/**
 * jquery.rikerize.js
 *
 * A Konami code-style Easter egg plugin, except the secret code is "RIKER"
 * (keycodes: 82, 73, 75, 69, 82).
 *
 * Originally written for bresnan.com circa ~2012.
 * Preserved here because this repo wouldn't be called RIKERIZE without it.
 *
 * Usage:
 *   $(document).rikerize(function() {
 *     alert("Number One, you have the bridge.");
 *   });
 *
 * Custom code:
 *   $(document).rikerize(callback, "38,38,40,40,37,39,37,39,66,65");
 */
(function($) {
	$.fn.rikerize = function(callback, code) {
		if(code == undefined) code = "82,73,75,69,82";
		var kkeys=new Array();
		return this.each(function() {
			$(this).keydown(function(e){
				kkeys.push( e.keyCode );
				if ( kkeys.toString().indexOf( code ) >= 0 ){
					$(this).unbind('keydown', arguments.callee);
					callback(e);
				}
			}, true);
		});
	}
})(jQuery);
