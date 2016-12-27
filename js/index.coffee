typedLetters = 0
atoz = "abcdefghijklmnopqrstuvwxyz"
if(Cookies.get("time")?)
	fastestTime = Cookies.get("time")
else
	fastestTime = ""

advanceChar = (char) ->
	if(char - 97 == typedLetters)
		nextCharacter = String.fromCharCode(char)
		currentTyped = $("#typed").text()
		$("#typeHere").html('<span id="typed">' + currentTyped + nextCharacter + '</span>' + atoz.substring(typedLetters + 1, 26))
		console.log('yes')
		typedLetters++
		if(typedLetters == 26)
			stop()
			if fastestTime.length != 0
				fastestTime = Math.min(fastestTime, $("#time").text())
			else
				fastestTime = $("#time").text()
			document.cookie = "time=" + fastestTime
			$("#fastestTime").text(fastestTime)
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
			reset()
			start()
		advanceChar(e.which)

$ ->
	$("#reset").click -> reset()
	if fastestTime.length == 0
		$("#fastestTime").text(0)
	else
		$("#fastestTime").text(fastestTime)
	if(Cookies.get("cookieUserConsent") != "true")
		# hideCookies()
	# else
		$("#cookies").css("visibility", "visible")

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

clockRunning = ->
	currentTime = new Date()
	timeElapsed = new Date(currentTime - timeBegan - stoppedDuration)
	sec = timeElapsed.getUTCSeconds()
	ms = timeElapsed.getUTCMilliseconds()
	$("#time").text(sec + "." + ms)
	# set text

reset = ->
	console.log("resetted")
	$("#typeHere").html('<span id="typed"></span>' + atoz)
	typedLetters = 0
	clearInterval(started)
	stoppedDuration = 0
	timeBegan = null
	timeStopped = null

computeWPM = ->
	currentTime = new Date()
	Math.min(400, Math.floor((typedLetters * 1000 * 60 / 5) / (new Date(currentTime - timeBegan))))


@hideCookies = ->
	Cookies.set("cookieUserConsent", "true")
	$("#cookies").fadeOut()
