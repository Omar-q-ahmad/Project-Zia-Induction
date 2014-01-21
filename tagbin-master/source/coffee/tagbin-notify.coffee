T.notifications = 

	# Create function
	# 		options is an object with the following format
	# 		options = { color: <colorvalue> , message: 'Sample Notification' }
	# 		<colorvalue> currently may include 'red', 'blue', 'green', 'purple'
	create: (options)->

		$(".frontlayer .notification").remove()

		# Create a notification element
		_nf = $("<div/>").addClass 'notification'
		_nf.addClass options.color
		_nf.text options.message

		# Append it to .frontlayer
		$(".frontlayer").append _nf

		# Center the notification by page width
		$(".frontlayer").eq(0).css 'margin-left', parseInt($(this).width()/-2)

		# Show with drop

		$(".frontlayer .notification").eq(0).show "drop", {direction: 'up'}, 400


	clear: ()->
		$(".notification").hide "drop", {direction: 'up'}, 400, ()->
			$(this).remove()




		



