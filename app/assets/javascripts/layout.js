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
			
			$('#netflix').click(function() {
				if ($(this).is(':checked')) {
					$("#netflix_section").slideDown('slow');
					//$("#netflix_section").slideDown('slow');
				}
				else {
					$("#netflix_section").slideUp('slow');
				}
			});
			
			
			$('#hulu').click(function() {
				if ($(this).is(':checked')) {
					$("#hulu_section").slideDown('slow');
					//$("#netflix_section").slideDown('slow');
				}
				else {
					$("#hulu_section").slideUp('slow');
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
			    	width:"500px",
			   		height:"600px",
			   		inline: true,
			   		href: "#info_overlay",
			   		speed: 500,
			   		onLoad:function() { 
						document.documentElement.style.overflow = "hidden";
						var id = $(this).attr('data-id');
						//console.log(id);
						//alert(id)
						//$.get('tv_shows/' + id, function(data) {
							//alert(data);
							//console.log(data);
      						// Handle the result
      						//$('.article-window').html(data);
    					//});
						
			   		},
			   		onClosed:function() {
			   			$(".overlay_info").css("overflow", "hidden");
						$(".overlay_info").css("height", "200px");
						$("#overlay_more_info").show();
						document.documentElement.style.overflow = "auto";
			   		}
			   		
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
			
			$("#overlay_more_info").on('click', function() {
				$(".overlay_info").css("overflow", "auto");
				$(".overlay_info").css("height", "100%");
				$("#overlay_more_info").hide();
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
