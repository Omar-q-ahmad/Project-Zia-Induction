T.navigate = (_target)->
	$.ajax({
		url: _target
		cache: false,
		success: (_res)->
		
			$(".app-content").hide "slide",{direction: 'down'}, 300, ()->
				$(".app-content").html _res
				$(".app-content").show "slide", {direction: 'up'}, 300

		
				# Full height of .box.app container
				$('.box.app').css('height', (document.height-50).toString() + 'px')

				console.log "Searching for .loadActions"
				
				# Search for actions available on load
				console.log $(".loadActions").length
				$(".loadActions").each (_index)->
					T.actions $(@).attr('data-action'), $(@).attr('data-target')
					null
				null

			null

		error: (_res)->
			console.log "Error results"
			null

	}).done (_res)->
		console.log "Navigation Done"
		###
		switch _target
			when 'pic-upload.html' then T.actionlist.replace(['Capture Image', 'Swipe Tag', 'Upload'])
			when 'like-post.html' then T.navActions('navLikePost')
			when 'share.html' then T.actionlist.replace(['Swipe Tag', 'Share Post'])
			when 'tagplay.html' then T.actionlist.replace(['Choose Track', 'Swipe Tag', 'Play'])
			when 'status-post.html' then T.actionlist.replace(['Swipe Tag', 'Post Status'])
			else console.log "Actionlist not defined"
		# Process the actions pane
		###
		
		null
		

T.navActions = (_action)->
	if _action is 'navLikePost'
		T.actionlist.replace(['Swipe Tag', 'Like Post'])
		console.log "done-navlikepost"
	else console.log "Default Nav Action"
	null


T.updateView = (_iconclass, _viewname)->
	$(".box.main i")[0].className = _icon
	$(".box.main h3").text _viewname
	$(".box.main").show "drop", {direction: "left"}, 300