typedLetters = 0
atoz = "abcdefghijklmnopqrstuvwxyz"

advanceChar = (char) ->
	if(char - 97 == typedLetters)
		nextCharacter = String.fromCharCode(char)
		currentTyped = $("#typed").text()
		$("#typeHere").html('<span id="typed">' + currentTyped + nextCharacter + '</span>' + atoz.substring(typedLetters + 1, 26))
		console.log('hi')
		typedLetters++
		if(typedLetters == 26)
			stop()
		$("#speed").text(computeWPM())
	else
		console.log('no')

$(document).keypress (e)->
	if(e.which == 13)
		reset()
	else if(typedLetters == 26)
		return
	else
		if(typedLetters == 0)
			start()
		advanceChar(e.which)

$ ->
	$("#reset").click -> reset()

computeWPM = ->
	currentTime = new Date()
	Math.floor((typedLetters * 1000 * 60 / 5) / (new Date(currentTime - timeBegan)))


# stopwatch
# http://stackoverflow.com/questions/26329900/how-do-i-display-millisecond-in-my-stopwatch

timeBegan = null
timeStopped = null
stoppedDuration = 0
started = null

start = ->
	if(timeBegan == null)
		timeBegan = new Date()
	
	if(timeStopped != null)
		stoppedDuration += (new Date() - timeStopped)
	started = setInterval(clockRunning, 1)

stop = ->
	timeStopped = new Date()
	clearInterval(started)

# reset = ->
	# change text to 0.000

clockRunning = ->
	currentTime = new Date()
	timeElapsed = new Date(currentTime - timeBegan - stoppedDuration)
	sec = timeElapsed.getUTCSeconds()
	ms = timeElapsed.getUTCMilliseconds()
	$("#time").text(sec + "." + ms)
	# set text

reset = ->
	console.log("clicked")
	$("#typeHere").html('<span id="typed"></span>' + atoz)
	typedLetters = 0
	clearInterval(started)
	stoppedDuration = 0
	timeBegan = null
	timeStopped = null

