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
		//this is the autocomplete for the punch field
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
		
		//this is the datepicker for the advanced punches menu
		$("#punch_date").datepicker({
			dateFormat: "DD, MM d, yy"
		});
		
		//this is the toggle for the advanced menu
		$("#show_advanced_menu").click(function() {
			$("#advanced_menu").toggle("blind", 500);
		});
		
		//only hide the menu if javascript is enabled
		$("#advanced_menu").hide()
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