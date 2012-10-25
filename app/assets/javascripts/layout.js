var Welcome = function() {
	/**
	*	Private Methods (separated just by closing brace)
	*/

	return {
		/**
		*	Public Methods (separated by commas)
		*/
		documentReady: function() {
			$('#tv').prop('checked', true);
			
			$('#tv').click(function() {
				if ($(this).is(':checked')) {
					// checkbox is now being checked
					$('#tv_section').slideDown('slow');
				} else {
					// checkbox is now being unchecked
					$('#tv_section').slideUp('slow');
				}
			});

			$(".poster").hover(function(){
				if ($(this).data("bouncing") == false || $(this).data("bouncing") == undefined){
				    $(this).effect("bounce", { distance: 5, times: 1 }, 500);
				    $(this).data("bouncing", true);
				}
			},function () {
			   	$(this).data("bouncing", false);
			});

			$(".chzn-select").chosen(); 
			$(".chzn-select-deselect").chosen({allow_single_deselect:true});
		}
	};
}();

$(document).ready(function() {
	Welcome.documentReady();
});
