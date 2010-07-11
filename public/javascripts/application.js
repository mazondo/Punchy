// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults


$(function() {
	//these functions are taken nearly verbatim from the jquery-ui demos
		function split(val) {
			return val.split(/\s+/);
		}
		function extractLast(term) {
			return split(term).pop();
		}
		
		$("#autocomplete_punches").autocomplete({
			source: function(request, response) {
				$.getJSON("/punches/autocomplete", {
					term: extractLast(request.term)
				}, response);
			},
			
			minLength: 1,
			
			focus: function() {
				// prevent value inserted on focus
				return false;
			},
			
			select: function(event, ui) {
				var terms = split( this.value );
				// remove the current input
				terms.pop();
				// add the selected item
				terms.push( ui.item.value );
				// add placeholder to get the space at the end
				terms.push("");
				this.value = terms.join(" ");
				return false;
			}
		});
	});
	
/*
$(function(){
	$('#autocomplete_punches').autoComplete({
	ajax: '/punches/autocomplete',
	ajaxCache: true,
	multiple: true,
	multipleSeparator: ' ',
	autofill: true,
	striped: 'auto-complete-striped',
	// Add a delay as autofill takes some time
	delay: 200
	});
});
*/