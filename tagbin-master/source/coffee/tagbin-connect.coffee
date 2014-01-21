T.connect = (options, _cb)->
	
	_postURL = "http://tagbin.in/phpHandler/getDetails.php"


	$.ajax({
		url: _postURL,
		type: 'post',
		data: {
				type: options.type
				tagID: options.tagID
			},
		cache: false,
		success: (data)->
			console.log data
			_cb(data) if (_cb)

		error: (e)->
			console.log e
	}).done ()->
		console.log "Finished"




T.getData = (_tagID, _callback)->
	T.connect {tagID: _tagID}, (_response)->
		_callback(_response) if _callback
		console.log "Details Done!"