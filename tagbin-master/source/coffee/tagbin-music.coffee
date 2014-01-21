T.Music = 

	LIB: null
	Player: document.createElement('audio')

	getLib: (_callback)->
		
		$.getJSON "./music.json", (response)->
			T.Music.LIB = JSON.parse response
			console.log "music.json loaded"

			T.Music.Player.preload = true
			T.Music.Player.autoplay = true
			T.Music.Player.volume = 1
			if(_callback) then _callback()

	Populate: (_target)->

		$.ajax {
			url: 'music.json',
			cache: false,
			type: 'GET'
			dataType: 'json'

			error: (err)->
				console.log "EFETCH: Error fetching music.json, " + err
			success: (response)->
				# Player Config
				T.Music.Player.preload = true
				T.Music.Player.autoplay = true
				T.Music.Player.volume = 1
				T.Music.LIB = response

				$(_target)
					.find('.title')
					.text "PLAYLIST [" + response.length.toString() + " Songs]"
				i = 1 
				loop
					item = response.data[i]
					_li = $("<li/>")
								.addClass('song')
								.attr('data-id', i.toString())
								.text(item.title[0])

					
					# Append to ul
					$(_target)
						.find('ul')
						.append( _li )
					i++
					break if i is response.length+1
					
		}
		null

	onSongClick: (_songID, _target)->
		dd = T.Music.LIB.data[_songID]
		$(".player li.title").text dd.title[0]
		$(".player li.artist").text dd.artist[0]
		$(".player li.album").text dd.album[0]

		T.Music.getArt dd, _target
		T.Music.Play dd, _target

	Play: (dd, el)->

		# Visual Notification for currently playing music
		$(".play-list ul li.active").removeClass 'active'
		el.addClass 'active'

		T.Music.Player.src = dd.filePath
		console.log 'MUSIC: Playing '+ dd.title[0]

	getArt: (_object, el)->
		dd = _object
		#1_url = "https://www.googleapis.com/customsearch/v1?key=__key__&searchType=image&q=__query__&alt=__alt__&cx=__cx__&filetype=__filetype__"
		_url = "https://www.googleapis.com/customsearch/v1?key=__key__&searchType=image&q=__query__&alt=__alt__&cx=__cx__"
		_url = _url.replace('__key__', "AIzaSyCNBmZI7X9zOF-UMocaXCpaMEV-prsCWCY")
		_url = _url.replace('__alt__', "json")
		_url = _url.replace('__cx__', "015983474732296187492:hmmm431-awc")
		#1_url = _url.replace('__filetype__', "jpg")
		
		query = dd.artist[0] + " " + dd.album[0] + " album art"
		_url = _url.replace '__query__', encodeURIComponent(query) 
		#console.log _url
		$.getJSON _url, (response)->
			console.log response.items[0].link
			$("img.player-art").attr('src', response.items[0].link)
			null


