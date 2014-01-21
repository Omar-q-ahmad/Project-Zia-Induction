
# Various utilities used by the app are defined here
T.Utils =

	# To Return random coordinates
	RandCoord: ()->
		_x = Math.floor Math.random()*document.width
		_y = Math.floor Math.random()*document.height
		return [parseInt(_x), parseInt(_y)]

	# Returns distance between two points
	# 		Points are defined as {x:0, y:0}
	Distance: (p1,p2)->
		dx = p2.x - p1.x
		dy = p2.y - p1.y
		return Math.sqrt(dx*dx + dy*dy)


	# Returns a post object based on data
	NewPost: (_data)->

		### Structure of _data
			|-- likes
			|	-- count
			|	-- data[]
			|     -- id
			|     -- name
			|-- from 
			|	-- id 
			|	-- name
			|-- id
			|-- message

		###

		likes_count = _data.likes.count ? "0"
		likes_data = _data.likes.data ? null
		message = _data.message ? "No Message"
		from_name = _data.from.name ? "User"
		from_id = _data.from.id ? "No ID"
		post_id = _data.id 

		# Create Post Object
		_pobj = $("<div/>")
		_pobj.addClass("social-post row-fluid")
			.append( $("<div/>").addClass('span3')  )
			.append( $("<div/>").addClass('span9') )
			.attr 'data-post-id', post_id

		# Add inner fields
		_pobj.find('.span3')
			.append( $("<div/>").addClass('pic-whoposted').attr('data-user-id', from_id ) )

		# Add picture
		console.log "Adding Picture: " + from_id
		_pobj.find('.pic-whoposted').css 'background-image', 'url("http://graph.facebook.com/'+from_id+'/picture?type=large")'
		
		_pobj.find('.span9')
			.append( $("<div/>").addClass('who-posted').text(from_name) )
			.append( $("<div/>").addClass('post-text') )
			.append( $("<div/>").addClass('post-likes') )
		_pobj.find('.post-likes')
			.append(  $("<div/>").addClass('count').text( likes_count ) )
			.append( $("<div/>").addClass('text').text( 'people like this' ) )
		_pobj.find('.post-text')
			.append(  $("<p/>").text( message ) )
		_pobj.addClass('hidden tiltup')

		# Add Pictures of users who liked the post
		_pobj.find('.span9').append( $("<ul/>").addClass("like-users") )
		
		_k = 0
		loop
			_tt = likes_data[_k]
			_ll = $("<li/>")
					.attr('data-id', _tt.id)
					.attr('data-name', _tt.name)
					.css 'background-image', 'url("http://graph.facebook.com/'+_tt.id+'/picture?type=large")'

			_pobj.find("ul.like-users").append( _ll )
			_k++
			break if _k is likes_data.length
		
		return _pobj






T.addPicture = (_source, _target)->
	_webv = document.createElement 'webview'
	

T.getCSSProps = (_target, _array)->
	


T.setCSSProps = (_target, _array)->
