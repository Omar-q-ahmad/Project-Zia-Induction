T.activeSocketID = 0


T.sockets = ()->
	
	s = null

	### Initialize Chrome socket to read rfid tag event
	chrome.socket.create "tcp", {"bind": "127.0.0.1", "port": "5556"}, (result)->
		s = result if result
		console.log result
	###
	T.socket = chrome.socket

	onSocketCreateSuccess = (socketInfo)->
		socketId = socketInfo.socketId
		T.activeSocketID = socketId
		address = '127.0.0.1'
		port = 6338

		T.socket.listen socketId, address, port, (result)->
			console.assert 0 is result	# Socket Failed
			T.socket.getInfo socketId, (info)->
				console.log 'tagMachine Listener on http://localhost:' + info.localPort
				# accept only one time
				T.socket.accept socketId, (acceptInfo)-> 
					console.assert 0 is acceptInfo.resultCode
					acceptedSocketId = acceptInfo.socketId
					console.log 'acceptedSocketID', acceptedSocketId
					T.socket.read acceptedSocketId, (readInfo)->
						T.aB2Str readInfo.data, (str)->
							nlen = str.toString().split("\n")
							T.gotID = nlen[nlen.length-1].slice(6)
							console.log 'readInfo.data', T.gotID
							$(T.ninja).trigger 'sendPhoto'
							$(".box.main .footer").text("Uploading your photo")
							null
						null 
					null
				null
			null
		null
				
	

	T.socket.create "tcp", {}, onSocketCreateSuccess


T.aB2Str = (buf, callback)->
	blob = new Blob([new Uint8Array(buf)])
	f = new FileReader()
	f.onload = (e)->
		callback e.target.result
	f.readAsText(blob)
	null

T.socketReset = ()->
	# Destroy the socket
	chrome.socket.destroy T.activeSocketID, (result)->
		console.log result
		console.log "Closed Socket"

	# Re-Create a socket
	console.log "Creating Socket..."
	T.sockets()