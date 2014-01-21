
# Ninja Handlers here
$(T.ninja).on 'sendPhoto', (e)->
	_url = "http://tagbin.in/phpHandler/fb_post.php"
	_urlTemp = "http://tagbinphp-temp.herokuapp.com/phpHandler/fb_post.php"

	$.post _url, {
		imgdata: T.readyImageData
		tagID: T.serial.tagID
	}, (response)->
		console.log response

		$(".box.main .footer").text("Successfully Uploaded").delay(2000).hide "slide", {direction: "up"}, 400, ()->
			$(".overlay").show("fade")			
		null
	null


$(T.ninja).on 'likePost', (e)->
	_url = "http://tagbin.in/phpHandler/fb_likepost.php"
	_options = 
		postID: T.latestPostData.id
		tagID: T.serial.tagID
	$.post _url, _options, (_response)->
		console.log _response
		$('.box.main .footer').removeClass('animated').addClass('success').text("Successfully Liked!").delay(2000).hide "slide", {direction: "up"}, 400, ()->
			$(".overlay").show("fade")			
			$(".post-likes .count").text T.latestPostData.likes.count + 1
		null
	null


$(T.ninja).on 'sharePost', (e)->
	_url = "http://tagbin.in/phpHandler/share.php"
	_options = 
		postID: T.latestPostData.id
		tagID: T.serial.tagID
	$.post _url, _options, (_response)->
		console.log _response
		$('.box.main .footer').removeClass('animated').addClass('success').text("Successfully Shared!").delay(2000).hide "slide", {direction: "up"}, 400, ()->
			$(".overlay").show("fade")			
		null
	null
