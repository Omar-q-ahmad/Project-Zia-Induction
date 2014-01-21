$(document).ready ()->

	# Check if url contains forwarding
	_index = window.location.href.indexOf '#!'
	if _index > -1 
		_ffd = window.location.href.slice 45
		console.log _ffd
		history = history || window.history
		history.pushState "Page-"+_ffd, null, window.location.href.slice(0,43)
		console.log "Shifting to forwarding page"
		T.navigate( _ffd.toString() )

	
	T.handleLoading()
	T.init()
	

	# Handle .runAction classes
	$(document).on 'click', '.runAction', (e)->
		_action = $(@).attr 'data-action'
		_target = $(@).attr 'data-target'
		T.actions _action, _target
		null

	# Handle .btn-hex buttons
	$(document).on 'click', '.btn-hex', (e)->
		e.preventDefault()
		_target = $(@).attr 'href'
		console.log _target
		T.navigate _target.toString()
		
		# Hide the .overlay
		$(".overlay").hide()
		null

	$(document).on 'click', '.tagBinMain', (e)->
		$(".overlay").fadeIn()

	# Handle Song Clicks
	$(document).on 'click', '.song', (e)->

		# Passing the data-id and target element for further changes
		T.Music.onSongClick $(@).attr('data-id'), $(@)
		console.log "MUSIC: Song Clicked"

	null

 