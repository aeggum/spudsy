$(document).ready(function() {
	Welcome.documentReady();
});

var Welcome = function() {
	/**
	*	Private Methods (separated just by closing brace)
	*/
	var page = 1;
	
	/**
	 * Determines whether there should be an option to go back 
	 * in the 'your picks' section
	 */
	function _determinePrevious(times_forward) {
		if (times_forward > 0) {
			$("#previous_picks").show();
		}
		else {
			$("#previous_picks").hide();
		}
	}
	
	/**
	 * Regenerate the 'your_picks' section.  Should be called after
	 * the tv grid is generated.
	 */
	function _regenYourPicks() {
		$.ajax({
			url: "/welcome/your_picks"
		}).done(function(data) {
			$("#your_picks_section").html(data);
			_initBinding();
		});
	}
	
	/**
	 * Binds the provider select box so that a user can change providers.
	 * Called when the service type select box is changed.
	 */
	function _providerBinding() {
		$("#choose_provider").on('change', function() {
 			var type = $("#service_type option:selected").val();
 			var desc = $("#choose_provider option:selected").val(); 
 			$.ajax({
 				url: "/welcome/change_provider?type=" + type + "&desc=" + desc //....
 			}).done(function(data) {
 				$("#stations").html(data); //console.log(data)
 				_regenYourPicks();
 			});
 		});
	}
	
	
	/**
	 * Does the initial binding of the colorboxes and like/dislike buttons.
	 */
	function _initBinding() {
		$(".poster").hover(function(){
			if ($(this).data("bouncing") == false || $(this).data("bouncing") == undefined){
			    $(this).effect("bounce", { distance: 5, times: 1 }, 500);
			    $(this).data("bouncing", true);
			}
		},function () {
		   	$(this).data("bouncing", false);
		});
				
		$(".poster").on('click', function() {
			//console.log($(this).attr('data-id'));
			$.ajax({
				url: $(this).attr('data-id')  // get movie#show for this movie
				
			}).done(function(data) { 
				//console.log(data);
				$("#info_overlay").html(data);
			});
			
			$(this).colorbox({	
		    	width:"800px",
		   		height:"600px",
		   		inline: true,
		   		href: "#info_overlay",
		   		speed: 500,
		   		onLoad:function() { 
					document.documentElement.style.overflow = "hidden";
					var id = $(this).attr('data-id');
		   		},
		   		onClosed:function() {
		   			$(".overlay_info").css("overflow", "hidden");
					$(".overlay_info").css("height", "200px");
					$("#overlay_more_info").show();
					document.documentElement.style.overflow = "auto";
		   		}
		  	})
		});
		
		
		$(".hide_media_button").on('click', function(event) {
			var liked = "";
			if (event.target.id == "hide_like") {
				liked = "true";
			} else if (event.target.id == "hide_dislike") {
				liked = "false";
			}
			
			var data = $(this).parent().attr('data-id').split(',');
			
			$.ajax({
					type: "GET",
					url: "/welcome/hide_media",
					data: {"like": liked, "media_type": data[0] , "media_id": data[1]}
			}).done (function(data) {
				$("#your_picks_section").html(data).slideDown(500, 'swing').show();
				initBinding();
			});
		});
	}
	
	function _expandPhoto() {
	   var overlay = document.createElement("div");
	   overlay.setAttribute("id","overlay");
	   overlay.setAttribute("class", "overlay");
	   document.body.appendChild(overlay);
	}
	
	function _restore() {
	   document.body.removeChild(document.getElementById("overlay"));
	}

	return {
		/**
		*	Public Methods (separated by commas)
		*/
		documentReady: function() {
			var times_forward = 0;
			
			$('#tv').prop('checked', true);
			
			$('#twitter_tab').click(function() {
				$('#twitter_section').slideDown('slow');
			});

			$('#facebook_tab').click(function() {
				$('#facebook_section').slideDown('slow');
			});			

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
				
				

			$(".chzn-select").chosen(); 
			$(".chzn-select-deselect").chosen({allow_single_deselect:true});
			
			//Hides the selected media for the logged in user
			
			
			// shows a different selection of picks when the view more link is pressed
			$("#view_more").on('click', function(event) {
				var yourPicksHeight = $("#your_picks_container").height();
				$("#your_picks_container").css('height', yourPicksHeight);
				$.ajax({
					url: "/welcome/rotate_picks?forward=true"
					
				}).done(function(data) {
					event.preventDefault();
					$("#your_picks_section").hide();
					$("#your_picks_section").html(data).slideDown(500).show();
					_initBinding();
					_determinePrevious(++times_forward);
				});
			});
			
			$("#overlay_more_info").on('click', function() {
				$(".overlay_info").css("overflow", "auto");
				$(".overlay_info").css("height", "100%");
				$("#overlay_more_info").hide();
			});
			
			$("#previous_picks").on('click', function(event) {
				$.ajax({
					url: "/welcome/rotate_picks?forward=false"
				}).done(function(data) {
					$("#your_picks_section").hide();
					$("#your_picks_section").html(data).slideDown(500).show();
					_initBinding();
					_determinePrevious(--times_forward);
				});
			});
			
			
			/**
			 * Update the shown providers when the service type option is changed.
			 */
			$("#service_type").on('change', function() {
				var type = $("#service_type option:selected").text();
			 	$.ajax({
			 		url: "/welcome/get_providers?type=" + type
			 	}).done(function(data) {
			 		$("#choose_provider").hide();
			 		$("#choose_provider").html(data).show();
			 	});
			 	
			});
			
			_initBinding();
			_providerBinding();
			_regenYourPicks();
		}
	};
}();







