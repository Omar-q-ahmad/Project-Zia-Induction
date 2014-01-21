T.actionlist = 

	target: null

	findTarget: ()->
		if $(".actionlist").length then T.actionlist.target = $(".actionlist")
		else console.log "No actionlist on this page"
	
	clear: ()->
		tt = T.actionlist.target
		tt.find('li').hide "slide", {direction: 'up'}, 400, ()->
			$(this).remove()

	addActions: (_actionsArray)->
		_jj = _actionsArray
		T.actionlist.findTarget() if not T.actionlist.target
		
		# Add actions to list
		for key in _jj
			T.actionlist.addOne _jj.indexOf(key), key

	addOne: (_id, _text)->
		_aa = $("<li/>").addClass('action').attr 'data-actionid', _id.toString()
		_aa.append $("<i/>").addClass('icomoon-minus')
		_aa.append $("<span/>").addClass('name').text(_text)

		T.actionlist.findTarget() if not T.actionlist.target

		T.actionlist.target.append _aa

	replace: (_actionsArray)->
		T.actionlist.findTarget() if not T.actionlist.target
		T.actionlist.clear()
		T.actionlist.addActions(_actionsArray)


