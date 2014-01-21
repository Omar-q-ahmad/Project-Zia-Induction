T.videoEl = null
T.webcamSource = null

T.initCamera = (_target)->

	navigator = navigator || window.navigator

	onSuccess = (stream)->
		if T.videEl
			console.log "Video Element Resume"
			T.videoEl.play()
			null
		else 
			video = $(_target)[0]
			video.autoplay = true
			T.webcamSource = window.URL.createObjectURL stream
			video.src = T.webcamSource
			video.play()
			T.videoEl = video
			null

	onError = ()->
		console.log "Failed to initialize camera"

	navigator.webkitGetUserMedia {video: true, audio: false}, onSuccess, onError

	console.log "Camera Initiated"

	window.setTimeout ()->
		console.log T.videoEl
		console.log "Now Resuming Play"
		$(".box.main .footer").text("Click on Capture")
		$(".box.main .footer").slideDown()
		T.videoEl.play() if T.videoEl
		null
	,1000	
	null


T.captureImage = (_target, _cb)->
	video = $(_target)[0]

	# Show a countdown
	for k in [1,2,3,4,5]
		$(video).parent().find(".countdown").append $("<div/>").addClass("c"+k.toString()).text(k.toString())

	$(video).parent().find(".countdown").append $("<div/>").addClass 'flash'

	window.setTimeout ()->
		video.pause()
		canvas = document.createElement 'canvas'
		canvas.width = 640
		canvas.height =  480
		ctx = canvas.getContext '2d'
		imgframe = document.createElement('img')
		imgframe.src = "./static/img/frame.png"
		ctx.drawImage video, 0, 0, 640, 480
		ctx.drawImage imgframe, 0, 0, 640, 480
		_data = canvas.toDataURL()
		console.log "Generated data-uri for image"
		
		$(".box.main .footer").text "Swipe your card"
		T.picUpload _data
		null
	, 5100

	### Re-create the image on canvas and export base64 encoded image data
	###
	
	if _cb then _cb(_data)

	null
