
# Catch app launching event
chrome.app.runtime.onLaunched.addListener ()->

	# Create a window and render index.html in it
	chrome.app.window.create 'index.html', {
		"bounds": {
			"width": 800,
			"height": 450
		}
	},(win)->

		# After Initialization, maximize the window
		win.maximize()





# Catch app closing event
chrome.app.window.current().onClosed = (e)->

	# Destroy sockets
	console.log "Destroying socket: " + T.activeSocketID.toString()
	chrome.socket.destroy T.activeSocketID

	# Destroy Serial's
	chrome.serial.close T.serial.connId, (result)->
		console.log "Closing Serial Port: " + T.serial.DEVICE_PORT

