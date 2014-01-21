


T.actions = (_action, _target)->
	switch _action 
	
		when 'navigate' then T.navigate(_target)
		when 'initCamera' then T.initCamera(_target)
		when 'takePicture' then T.captureImage(_target)
		when 'getLatestPostShare' then T.getLatestPostShare(_target)
		when 'publishWelcome' then T.publishWelcome(_target)
		when 'prevPost' then T.likePosts.prev()
		when 'nextPost' then T.likePosts.next()
		when 'getLikePosts' then T.get5LikePosts(_target)
		when 'populateMP3' then T.Music.Populate(_target)
		else console.log "Unknown Action"

	null 





T.publishWelcome = (_target)->
	_url = "http://tagbin.in/phpHandler/status_post.php"

	$('.box.main .footer').addClass('needy').text "Swipe to Post"

	T.serial.readM (_tagid)->
		console.log _tagid
		$('.box.main .footer').text "Got tagID, Posting..."	
		
		$.post _url, {tagID: T.serial.tagID}, (response)->
			console.log response
			$('.box.main .footer').text("Successfully Posted").delay(2000).hide "slide", {direction: "up"}, 400, ()->
				$(".overlay").show("fade")
			null
		null
	null





