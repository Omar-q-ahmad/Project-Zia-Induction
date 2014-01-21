
T.gdURL = "http://tagbin.in/phpHandler/getDetails.php"

T.latestPostData = null

T.getLatestPost = (_target)->
	console.log "Fetching latest post"
	_url = "http://tagbin.in/phpHandler/getDetails.php"
	_ops = {type: 'getLatestPost'}
	
	$(".box.main .footer").addClass('needy').text("Fetching Latest Post...")
	
	$.post _url, _ops, (response)->
	
		console.log JSON.parse(response)
		window.RESPONSE1 = JSON.parse(response).data[0]
		T.latestPostData = window.RESPONSE1
		
		_message = T.latestPostData.message
		_id = T.latestPostData.from.id
		_from = T.latestPostData.from.name
		_likesCount = T.latestPostData.likes.count

		$("#latestpost .who-posted").text _from
		$("#latestpost .post-text p").text _message
		$("#latestpost .post-likes .count").text _likesCount.toString()
		
		$.post T.gdURL, {id: _id, type: 'getUserPicture'}, (_res)->
	
			_bb = T.b64toblob _res, 'image/jpg'
			_bburl = window.webkitURL.createObjectURL _bb
			$("#latestpost").parent().find('img').attr 'src', _bburl

			$(".box.main .footer").addClass('needy').text("Swipe to Like").slideDown()
			T.serial.readM (_tagid)->
				console.log _tagid
				$('.box.main .footer').text "Got TagID, Processing..."
				$(T.ninja).trigger 'likePost'



		null
	null

T.getLatestPostShare = (_target)->
	console.log "Fetching latest post"
	_url = "http://tagbin.in/phpHandler/getDetails.php"
	_ops = {type: 'getLatestPost'}
	
	$.post _url, _ops, (response)->
		console.log JSON.parse(response)
		window.RESPONSE1 = JSON.parse(response).data[0]
		T.latestPostData = window.RESPONSE1
		
		_message = T.latestPostData.message
		_id = T.latestPostData.from.id
		_from = T.latestPostData.from.name
		_likesCount = T.latestPostData.likes.count

		$("#latestpost-share .who-posted").text _from
		$("#latestpost-share .post-text p").text _message
		$("#latestpost-share .post-likes .count").text _likesCount.toString()
		
		$.post T.gdURL, {id: _id, type: 'getUserPicture'}, (_res)->
			_bb = T.b64toblob _res, 'image/jpg'
			_bburl = window.webkitURL.createObjectURL _bb
			$("#latestpost-share").parent().find('img').attr 'src', _bburl

			$(".box.main .footer").addClass('needy').text("Swipe to Share").slideDown()
			T.serial.readM (_tagid)->
				console.log _tagid
				$('.box.main .footer').text "Got TagID, Sharing..."
				$(T.ninja).trigger 'sharePost'


		null
	null




T.getImage  = (_url)->
	console.log _url
	_url = "http://tagbin.in/phpHandler/getDetails.php"
	_ops = {type: 'getLatestPost'}
	$.post _url, _ops, (response)->
		
	
T.updateLikes = (_target)->


T.get5LikePosts = (_target)->

	_TARGET = _target
	$(_TARGET).empty()	
	$.post "http://tagbin.in/phpHandler/fb_getposts.php", {type: 'get5Posts'}, (responseStr)->
		$(_TARGET).addClass 'inProcess'
		i = 0
		response = JSON.parse(responseStr.toString())
		console.log response.data
		loop
			_obj = response.data[i]
			_li = T.Utils.NewPost _obj
			_li.addClass('active') if response.data.indexOf( _obj ) is parseInt('2')
			$(_TARGET).append _li
			i++
			break if i is response.data.length
		$(_TARGET).removeClass 'inProcess'
		T.likePosts.next()
		T.likePosts.prev()
		T.likePosts.prev()

