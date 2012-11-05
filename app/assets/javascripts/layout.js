var Welcome = function() {
	/**
	*	Private Methods (separated just by closing brace)
	*/
	var page = 1;

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
						
			$(".poster").on('click', function() {
				$(this).colorbox({
			    	width:"50%",
			   		height:"50%",
			   		opacity: 1.0,
			   		html: "<h1> FUCK </h1>"
			  })
			})


			$(".chzn-select").chosen(); 
			$(".chzn-select-deselect").chosen({allow_single_deselect:true});
			
			$("#view_more").on('click', function() {
				page++;
				$("#poster_slider_" + page).slideDown(250);
				if (page >= 3) {
					$("#view_more").hide();
				}
			});
		}
	};
}();

$(document).ready(function() {
	Welcome.documentReady();
});


function expandPhoto() {

   var overlay = document.createElement("div");
   overlay.setAttribute("id","overlay");
   overlay.setAttribute("class", "overlay");
   document.body.appendChild(overlay);
}

function restore() {
   document.body.removeChild(document.getElementById("overlay"));
}
