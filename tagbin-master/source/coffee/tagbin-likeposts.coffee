T.likePosts = 
	
	# Variables
	_url: 'http//tagbin.in/phpHandler/fb_likeposts.php'
	_container: '.posts-list'
	_target: null
	
	get: (_callback)->

		# Fetches posts from server to embed
		#$.getJSON T.likePosts.url , (response)->
		# Assume that posts are fetched correctly...scroll view to active element
		$.post "http://tagbin.in/phpHandler/getDetails.php", {type:'get5Posts'}, (response)->
			


		T.likePosts.next()	# Assumes default active is 2nd elemnt
		T.likePosts.prev()
		T.likePosts.prev()

		$(".box.main .footer").text("Swipe to Like...")

	next: ()->
		target = $(".posts-list")
		_activePost = $(target).find(".social-post.active")
		
		actvP = $(_activePost)
		_aa = $(target).find('.social-post')
		if actvP[0] is _aa.eq(_aa.length-1)[0] then return
		nextP = $(_activePost).next()
		
		actvP
			.removeClass('active')
			.addClass('hidden')
			.removeClass('tiltdown')
			.addClass('tiltup')
		nextP
			.removeClass('hidden')
			.addClass('active')
			.parent()
			.stop()
			.animate({
				'scrollTop': actvP[0].offsetTop+100
			},300)


		return console.log "Next Post"

	prev: ()->
		target = $(".posts-list")
		_activePost = $(target).find(".social-post.active")
		
		actvP = $(_activePost)
		_aa = $(target).find('.social-post')
		if actvP[0] is _aa.eq(0)[0] then return
		prevP = $(_activePost).prev()

		actvP
			.removeClass('active')
			.addClass('hidden')
			.removeClass('tiltup')
			.addClass('tiltdown')
		prevP
			.removeClass('hidden')
			.addClass('active')
			.parent()
			.stop()
			.animate({
				'scrollTop': actvP[0].offsetTop-395
			},300)

		return console.log "Prev Post"

