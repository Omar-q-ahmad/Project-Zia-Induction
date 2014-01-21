
T.serial =
	DEVICE_READY: false
	DEVICE_TIMEOUT: 500
	DEVICE_PORT: "/dev/ttyUSB0"
	DEVICE_VENDORID: '2341'
	DEVICE_PRODUCTD: '0010'

	# Short Namespace for easy code
	S: chrome.serial

	interval:  null
	connInfo: null
	connId: null
	tagID: null

	isProcessing: false

	callback: null

	readM: (_cb)->
		if T.serial.isProcessing then window.clearInterval(T.serial.interval)
		T.serial.isProcessing = true
		T.serial.open()
		T.serial.callback = _cb
		null
	
	open: ()->
		###T.serial.S.getPorts (ports)->
			T.DEVICE_PORT = ports[0]
			console.log T.DEVICE_PORT, "Proceed to reading tag"
		###
		T.serial.S.open T.serial.DEVICE_PORT, {bitrate: 9600}, T.serial.onOpen
		null

	onOpen: (connectionInfo)->
		T.serial.connInfo = connectionInfo
		T.serial.connId = T.serial.connInfo.connectionId
		if T.serial.connInfo.connectionId is -1 then console.log "System Permissions error on: "+ T.serial.DEVICE_PORT
		if typeof T.serial.connInfo.connectionId is 'number' then T.serial.listen()
		else console.error "Port cannot be opened, Some other error has occured"

	listen: ()->
		setInterval = setInterval || window.setInterval
		T.serial.interval = setInterval ()->
			T.serial.S.read T.serial.connId, 128, T.serial.onRead
		, T.serial.DEVICE_TIMEOUT
		null

	onRead: (readInfo)->
		if not T.serial.connId then return
		if readInfo and readInfo.bytesRead > 0 and readInfo.data then T.serial.processOutput readInfo.data
		else console.log "Swipe tag to read"

			
	processOutput: (_arrayBuffer)->
		str = T.serial._ab2str _arrayBuffer
		# Filter out the tag from junk data
		str = str.split('\n')[0].split(' ')[0]
		
		if str is '' or NaN or " " or "\n"
			console.log "Retrying..."
			$(T.ninja).trigger 'showRetry'
		
		if str.length.toString() is '22' or str.length.toString() is '24'
			T.serial.tagID = str
			T.serial.readSuccess()
		
		else 
			doNothing = 1
	
	readSuccess: ()->
		
		# Clear the repeating interval
		clearInterval = clearInterval || window.clearInterval
		clearInterval T.serial.interval

		# Close the serial port 	#!IMPORTANT
		T.serial.S.close T.serial.connId, (result)->
			console.log "Serial Port Closed"
			console.log "Value of tag from T.serial.tagID"
			T.serial.isProcessing = false
		# Return Value to Callback
		if typeof(T.serial.callback) is 'function' then T.serial.callback(T.serial.tagID)
		else console.log "No Callbacks, use T.readM(_callback) for reading tag with a callback"

	readTag: (readInfo)->
		str = T.serial._ab2str readInfo.data
		console.log "Tag read successful, tagID: " + str.toString()
		console.log T.serial.tagID + str
		tmp = T.serial.tagID + str
		T.serial.tagID = tmp.split('\n')[0].split(' ')[0]
		$(T.ninja).trigger 'gotTagID'
		T.serial.reset()
		null

	fullTagID: (readInfo)->
		if not T.serial.connId then return 
		if readInfo and readInfo.bytesRead > 0 and readInfo.data
			_data = T.serial._ab2str readInfo.data
			T.serial.tagID = _data.split('\n')[0].split(' ')[0]
			console.log "tagID: "+ T.serial.tagID
			$(T.ninja).trigger 'gotTagID'
		else
			console.log "Swipe tag to read"

	reset: ()->
		clearInterval = clearInterval || window.clearInterval
		clearInterval T.serial.interval
		T.serial.S.close T.serial.connId, (result)->
			console.log "Closed Serial Port"
		T.serial.open()
		null

	_ab2str: (buf)->
		return String.fromCharCode.apply null, new Uint8Array(buf)

