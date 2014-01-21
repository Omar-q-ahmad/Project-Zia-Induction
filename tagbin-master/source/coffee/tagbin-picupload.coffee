T.picUpload = (_imgdata)->

	T.picReady = 1
	console.log "Ready to post the details"
	console.log "Ask for tag swipe"

	T.readyImageData = _imgdata
	console.log "Swipe the Tag Now"

	T.serial.readM (_tagid)->
		console.log _tagid
		$(".box.main .footer").addClass('needy').text "Got TagID, Now Uploading"
		$(T.ninja).trigger 'sendPhoto'

	null
