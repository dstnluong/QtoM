qwerty = ["q", "w", "e", "r", "t", "y", "u", "i", "o", "p", "a", "s", "d", "f", "g", "h", "j", "k", "l", "z", "x", "c", "v", "b", "n", "m"]

numberOfStartingLetters = 0
typedLetters = 0
typedWrongLetters = 0
if(Cookies.get("time")?)
	fastestTime = Cookies.get("time")
else
	fastestTime = ""

advanceChar = (char) ->
	nextCharacter = String.fromCharCode(char)
	id = "#" + String.fromCharCode(typedLetters + typedWrongLetters + 97)
	if(char - 97 == qwerty[typedLetters + typedWrongLetters])
		typedLetters++
		$(id).addClass("correct")
	else
		typedWrongLetters++
		$(id).addClass("wrong")
	if(typedLetters == 26)
		stop()
		if(numberOfStartingLetters == 0)
			if fastestTime.length != 0
				fastestTime = Math.min(fastestTime, $("#time").text())
			else
				fastestTime = $("#time").text()
			document.cookie = "time=" + fastestTime
			$("#fastestTime").text(fastestTime)
	$("#speed").text(computeWPM())

$(document).keypress (e)->
	if(e.which == 13)
		reset()
	else if(typedLetters + typedWrongLetters == 26)
		return
	else if (e.shiftKey)
		chooseStart(String.fromCharCode(e.which + 32))
	else
		if(typedLetters == 0)
			reset()
			typedLetters = numberOfStartingLetters
			start()
		advanceChar(e.which)

$(document).keydown (e) -> # dumb workaround
	if(e.keyCode == 8)
		idprev = "#" + String.fromCharCode(typedLetters + typedWrongLetters + 96)
		if($(idprev).hasClass("correct"))
			$(idprev).removeClass("correct")
			typedLetters--
		else if($(idprev).hasClass("wrong"))
			$(idprev).removeClass("wrong")
			typedWrongLetters--

$ ->
	$("#reset").click -> reset()
	if fastestTime.length == 0
		$("#fastestTime").text(0)
	else
		$("#fastestTime").text(fastestTime)
	if(Cookies.get("cookieUserConsent") != "true")
		$("#cookies").css("visibility", "visible")
	$("#a, #b, #c, #d, #e, #f, #g, #h, #i, #j, #k, #l, #m, #n, #o, #p, #q, #r, #s, #t, #u, #v, #w, #x, #y, #z").click -> chooseStart(this.innerHTML)

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
	typedLetters = 0
	typedWrongLetters = 0
	clearInterval(started)
	stoppedDuration = 0
	timeBegan = null
	timeStopped = null
	for number in [1..26]
		currentChar = String.fromCharCode(number + 96)
		currentId = "#" + currentChar
		$(currentId).removeClass("correct")
		$(currentId).removeClass("wrong")

computeWPM = ->
	currentTime = new Date()
	wpm = Math.floor((typedLetters)*1000*60/(5 * new Date(currentTime - timeBegan)))
	Math.min(400, wpm)


@hideCookies = ->
	Cookies.set("cookieUserConsent", "true")
	$("#cookies").fadeOut()

chooseStart = (a) ->
	stop()
	reset()
	for number in [1..26]
		currentChar = String.fromCharCode(number + 96)
		currentId = "#" + currentChar
		$(currentId).removeClass("inactive")
	$("#fastestTime").removeClass("inactive")
	# id = "#" + a
	index = a.charCodeAt(0) - 96
	if(index != 1)
		$("#fastestTime").addClass("inactive")
		for number in [1..index - 1]
			currentChar = String.fromCharCode(number + 96)
			currentId = "#" + currentChar
			$(currentId).addClass("inactive")
	numberOfStartingLetters = index - 1
	console.log(numberOfStartingLetters)
