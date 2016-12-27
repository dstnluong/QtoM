typedLetters = 0
atoz = "abcdefghijklmnopqrstuvwxyz"

advanceChar = (char) ->
	if(char - 97 == typedLetters)
		nextCharacter = String.fromCharCode(char)
		currentTyped = $("#typed").text()
		$("#typeHere").html('<span id="typed">' + currentTyped + nextCharacter + '</span>' + atoz.substring(typedLetters + 1, 26))
		console.log('hi')
		typedLetters++
	else
		console.log('no')

$(document).keypress (e)->
	if(e.which == 13)
		reset()
	else
		advanceChar(e.which)
		if(typedLetters == 26)
			console.log("good job!")
			# reset here
			typedLetters = 0


reset = ->
	console.log("clicked")
	$("#typeHere").html('<span id="typed"></span>' + atoz)
	typedLetters = 0

$ ->
	$("#reset").click -> reset()
