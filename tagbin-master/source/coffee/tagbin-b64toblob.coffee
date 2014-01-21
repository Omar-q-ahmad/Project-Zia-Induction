
T.b64toblob = (b64Data, contentType, sliceSize)->
	contentType = contentType || ''
	sliceSize = sliceSize || 1024

	charCodeFromCharacter = (c)->
		return c.charCodeAt(0)

	byteCharacters = atob(b64Data)
	byteArrays = []

	offset = 0

	while offset < byteCharacters.length
		slice = byteCharacters.slice(offset, offset + sliceSize)
		byteNumbers = Array::map.call(slice, charCodeFromCharacter)
		byteArray = new Uint8Array(byteNumbers)
		byteArrays.push byteArray
		offset += sliceSize

	blob = new Blob(byteArrays, {type: contentType})
	return blob;

T.imgToB64 = (url, _callback)->
	cc = document.createElement 'canvas'
	ctx = cc.getContext '2d'
	img = document.createElement 'img'
	img.src = url
	cc.width = img.width 
	cc.height = img.height 
	ctx.drawImage img, 0, 0
	if _callback then _callback(cc.toDataURL())
	else return cc.toDataURL()
