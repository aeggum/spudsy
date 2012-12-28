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
	function _determineYourPrevious(your_picks_times_forward) {
		if (your_picks_times_forward > 0) {
			$("#previous_picks").show();
		}
		else {
			$("#previous_picks").hide();
		}
	}
	
	/**
	 * Shows the 'previous' netflix link if the parameter is > 0, hides otherwise.
	 * For the 'netflix' section.
	 */
	function _determineNetflixPrevious(netflix_times_forward) {
		if (netflix_times_forward > 0) {
			$("#previous_netflix").show();
		}
		else {
			$("#previous_netflix").hide();
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
		$.ajax({
			url: "/welcome/twitter"
		}).done(function(data) {
			$("#twitter_section").html(data);
		});
	}
	
	/**
	 * Binds the provider select box so that a user can change providers.
	 * Called when the service type select box is changed.
	 */
	function _providerBinding() {
		$("#choose_provider").on('change', function() {
			$("#stations").css('opacity','0.9');
			$("#stations").css('background-color','#CCC');
			$('#ajax-loader').show(); 			
			var type = $("#service_type option:selected").val();
 			var desc = $("#choose_provider option:selected").val(); 
 			$.ajax({
 				url: "/welcome/change_provider?",//type=" + type + "&desc=" + desc,
 				data: { type: type, desc: desc } //"type=" + type + "desc=" + desc //....
 			}).done(function(data) {
 				$("#stations").html(data); //console.log(data)
 				_regenYourPicks();
 			}).fail(function(data) {	// TODO: Should be something more user friendly
 				alert("There was an error with the request. Sorry.");
 			}).always(function() {
 				$('#ajax-loader').hide();
				$("#stations").css('opacity','1');
				$("#stations").css('background-color','white');
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
				
		$(".poster, .popBad, .popGood, .popTop").on('click', function() {
			_showOverlay(this);
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
			}).done(function(data) {
				$("#your_picks_section").html(data).slideDown(500).show();
				_initBinding();
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

	function _showOverlay(thiz) {
		$.ajax({
			url: $(thiz).attr('data-id')  // get movie#show for this movie
		
		}).done(function(data) { 
			//console.log(data);
			$("#info_overlay").html(data);
		});
	
		$(thiz).colorbox({	
	    	width:"800px",
	   		height:"650px",
	   		inline: true,
	   		href: "#info_overlay",
	   		speed: 500,
	   		onLoad:function() { 
				document.documentElement.style.overflow = "hidden";
				var id = $(thiz).attr('data-id');
	   		},
	   		onClosed:function() {
	   			$(".overlay_info").css("overflow", "hidden");
				$(".overlay_info").css("height", "200px");
				$("#overlay_more_info").show();
				document.documentElement.style.overflow = "auto";
	   		}
	  	})
	}

	return {
		/**
		*	Public Methods (separated by commas)
		*/
		documentReady: function() {
			var your_picks_times_forward = 0;
			var netflix_times_forward = 0;
			
			$('#type_type_key').hide();
			$('#service_type').change(function() {
			  $('#type_type_key').fadeIn();
			});
			$('#ajax-loader').hide();	
					

			$('#tv').prop('checked', true);
			$("#tv_show").prop('checked', true);
			$("#movie").prop('checked', true);
			
			
			$('#twitter_tab').click(function() {
				$('#twitter_section').slideDown('slow');
			});

			$('#facebook_tab').click(function() {
				$('#facebook_section').slideDown('slow');
			});			

			$('#tv').click(function() {
				if ($(this).is(':checked')) {
					$('#tv_section').slideDown('slow');
				} else {
					$('#tv_section').slideUp('slow');
				}
			});
			
			$("#tv_show, #movie").click(function() {
				$("#your_picks_section").hide();
				$("#netflix_section").hide();
				your_picks_times_forward = netflix_times_forward = 0;
				_determineYourPrevious(your_picks_times_forward);
				//_determineNetflixPrevious(netflix_times_forward);
				
				var netflix_bool = $("#netflix").is(':checked');
				var movie_bool = $("#movie").is(':checked');
				var tv_show_bool = $("#tv_show").is(':checked');
				
				$.ajax({
					url: "/welcome/show_media?",
					data: { "tv_show": tv_show_bool, "movie": movie_bool, "netflix": netflix_bool } 
				}).done(function(data) {
					$("#your_picks_section").html(data);
					_initBinding();
				}).always(function() {
					$("#your_picks_section").show();
					_initBinding();
				});
				
				$.ajax({
					url: "/welcome/render_netflix"
				}).done(function(data) {
					$("#netflix_section").html(data);
				}).always(function() {
					if (netflix_bool) {
						$("#netflix_section").show();
						_initBinding();
					}
				});
			});
			
			$('#netflix').click(function() {
				your_picks_times_forward = netflix_times_forward = 0;
				_determineYourPrevious(your_picks_times_forward);
				// _determineNetflixPrevious(netflix_times_forward);
				
				var netflix_checked = $("#netflix").is(':checked');
				var movie_checked = $("#movie").is(':checked');
				var tv_show_checked = $("#tv_show").is(':checked');
				
				if (netflix_checked) {
					$("#netflix_container").show();
					$("#your_picks_section").hide();
				}
				else {
					$("#netflix_section").hide();//('fast');
					$("#your_picks_section").hide(); //('fast'); //hide();
					$("#netflix_container").hide();
				}
					
				
				// change the media to reflect the netflix update
				$.ajax({
					url: "/welcome/show_media?",
					data: { "tv_show": tv_show_checked, "movie": movie_checked, "netflix": netflix_checked } 
				}).done(function(data) {
					$("#your_picks_section").html(data);
				}).always(function() {
					$("#your_picks_section").slideDown();
					_initBinding();
					// render the netflix section
					$.ajax({
						url: "/welcome/render_netflix"
					}).done(function(data) {
						$("#netflix_section").html(data);
						if (netflix_checked) {
							$("#netflix_section").slideDown();
						}
						//TODO: The binding here may not need to be the initBinding() function, but instead a new netflixBinding, or something
						//_initBinding();
					});
				});
				
				
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
						
			
			// shows a different selection of picks when the view more link is pressed
			$("#view_more").on('click', function(event) {
				var yourPicksHeight = $("#your_picks_container").height();
				$("#your_picks_container").css('height', yourPicksHeight);
				$.ajax({
					url: "/welcome/rotate_picks?forward=true&your_picks=true"
					
				}).done(function(data) {
					event.preventDefault();
					$("#your_picks_section").hide();
					$("#your_picks_section").html(data).slideDown(500).show();
					_initBinding();
					_determineYourPrevious(++your_picks_times_forward);
				});
			});
			
			$("#view_more_netflix").on('click', function(event) {
				var netflixPicksHeight = $("#netflix_container").height();
				$("#netflix_container").css("height", netflixPicksHeight);
				$("#netflix_section").hide();
				$.ajax({
					url: "/welcome/rotate_picks?forward=true&netflix=true"
				}).done(function(data) {
					$("#netflix_section").html(data).show();
					//_determineNetflixPrevious(++netflix_times_forward);
				}).fail(function() {
					$("#previous_netflix").hide();
					$("#view_more_netflix").hide();
				});
			});
			
			$("#overlay_more_info").on('click', function() {
				$(".overlay_info").css("overflow", "auto");
				$(".overlay_info").css("height", "100%");
				$("#overlay_more_info").hide();
			});
			
			$("#previous_picks").on('click', function(event) {
				$.ajax({
					url: "/welcome/rotate_picks?forward=false&your_picks=true"
				}).done(function(data) {
					$("#your_picks_section").hide();
					$("#your_picks_section").html(data).slideDown(500).show();
					_initBinding();
					_determineYourPrevious(--your_picks_times_forward);
				});
			});
			
			$("#previous_netflix").on('click', function() {
				$("#netflix_section").hide();
				$.ajax({
					url: "/welcome/rotate_picks?forward=false&netflix=true"
				}).done(function(data) {
					console.log(data)
					$("#netflix_section").html(data).show();
					//_determineNetflixPrevious(--netflix_times_forward);
				}).fail(function() {
					$("#previous_netflix").hide();
					$("#view_more_netflix").hide();
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
			
			
			/**
			 * When the update zip code box is updated, stop the default action
			 * and turn it into an ajax action.
			 */
			$("#update_zip").on('submit', function() {
				var newZip = $("#new_zip").val();
				if ( newZip.length != 5 || !(/^(\d)+$/.test(newZip)) ) {
					alert("There was a problem with the new zip code.");
					return false;
				}
				
				$("#choose_provider").hide().empty();
				$("#stations").css('opacity','0.9');
				$("#stations").css('background-color','#CCC');
				$('#ajax-loader').show(); 
				
				$.ajax({
					url: "/welcome/update_zip",
					data: { zip_code: newZip }
				}).done(function(data) {
					$("#stations").html(data);
					_regenYourPicks();
				}).fail(function(data) {
					alert("There was a failure.  This cannot ever happen.");
				}).always(function() {
					$('#ajax-loader').hide();
					$("#stations").css('opacity','1');
					$("#stations").css('background-color','white');
				});
				
				// prevent the default form action from occurring		
				return false;
			});
		
			
			_initBinding();
			_providerBinding();
			_regenYourPicks();
		}
	};
}();







