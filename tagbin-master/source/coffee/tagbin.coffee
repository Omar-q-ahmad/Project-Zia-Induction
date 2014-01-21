
# Main Namespace for tagbin functions
T =
	testData: {}
	user: {}
	init: null 			# The initialization function

	notify: null		# Notification module
	picReady: 0
	cI: null
	socket: null
	ninja: document.createElement 'div'

	useOffline: false
	Utils: {}

T.init = ()->
	
	### Check facebook login
	if not FB.getUserID()
		FB.login (_response)->
			console.log "Signed into facebook."
			console.log _response
		, {scope: 'publish_stream'}
	###

	# Full height of .box.app container
	$('.box.app').css('height', (document.height-50).toString() + 'px')

	# T.canvas_sea()

	# Initalize C Sockets
	# T.sockets()

	# Return null
	null

T.handleLoading = ()->

	$(".tb-loader").hide()

	# If .loader is present, set .overlay display: block
	if $(".loading").length then $(".overlay").css('display', 'block')

	$(".tb-loader").show "drop", {direction: "up"}, 500, ()->
		#T.canvasAnim()
		#$(".loading canvas").show()
		null

	window.setTimeout ()->
		$(".tb-loader .anim").removeClass 'anim'
		$(".tb-loader").hide "drop", {direction: 'down'}, 300, ()->
			###$(".loading").hide "fade", ()->
				$(".overlay").css 'display', 'none'
				window.location.href = './pic-upload.html'
			###
			# Show the menu after tagbin animation
			$("ul.loader-menu").show "drop",{direction: "down"}, 400
			console.log "Loading Handled"

	,4000
	null

T.canvasAnim = (_params)->
	#window.clearInterval T.cI
	osfn = _params ? [Math.sin,Math.cos]
	canvas = $(".ldcanvas")[0]
	ctx = canvas.getContext '2d'
	ctx.fillStyle = '#555'
	ctx.strokeStyle = '#555'
	draw = (params)->
		canvas.width = document.width + 2000
		canvas.height = document.height 
		ctx.clearRect 0,0,canvas.width, canvas.height
		x = y = 0
		loop
			xVal = Math.PI/180*(x%360)
			yVal = Math.round ((canvas.height/2) + (Math.sin(xVal)*50)) 

			xVal2 = Math.PI/180*(x%360)
			yVal2 = Math.round ((canvas.height/2) + (Math.cos(xVal)*60)) 

			xVal3 = Math.PI/180*(x%360)
			yVal3 = Math.round ((canvas.height/2) + (Math.sin(xVal+9)*40)) 

			ctx.fillRect(x, yVal, 1,1)
			ctx.fillRect(x, yVal2, 1,1)
			ctx.fillRect(x, yVal3, 1,1)
			#console.log( [xVal,yVal] , [xVal2,yVal2], [xVal3,yVal3] )
			x = x+4
			break if x >= canvas.width
		ctx.save()
		null
	draw(osfn)
	#T.cI = window.setInterval draw(osfn), 3000
	null

T.reset = ()->
	$(".box.main .footer")
		.removeClass("animated")
		.removeClass("needy")
		.text("")
	