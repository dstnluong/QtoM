numberOfStartingLetters = 0
typedLetters = 0
typedWrongLetters = 0
# original = '<span id="a">a</span><span id="b">b</span><span id="c">c</span><span id="d">d</span><span id="e">e</span><span id="f">f</span><span id="g">g</span><span id="h">h</span><span id="i">i</span><span id="j">j</span><span id="k">k</span><span id="l">l</span><span id="m">m</span><span id="n">n</span><span id="o">o</span><span id="p">p</span><span id="q">q</span><span id="r">r</span><span id="s">s</span><span id="t">t</span><span id="u">u</span><span id="v">v</span><span id="w">w</span><span id="x">x</span><span id="y">y</span><span id="z">z</span>'
if(Cookies.get("time")?)
	fastestTime = Cookies.get("time")
else
	fastestTime = ""

advanceChar = (char) ->
	nextCharacter = String.fromCharCode(char)
	id = "#" + String.fromCharCode(typedLetters + typedWrongLetters + 97)
	if(char - 97 == typedLetters + typedWrongLetters)
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
	$("#a, #b, #c, #d, #e, #f, #g, #h, #i, #j, #k, #l, #m, #n, #o, #p, #q, #r, #s, #t, #u, #v, #w, #x, #y, #z").click -> chooseStart(this)

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
	# Math.min(400, Math.floor((typedLetters * 1000 * 60 / 5) / (new Date(currentTime - timeBegan))))


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
	# id = "#" + a.innerHTML
	index = a.innerHTML.charCodeAt(0) - 96
	if(index != 1)
		$("#fastestTime").addClass("inactive")
		for number in [1..index - 1]
			currentChar = String.fromCharCode(number + 96)
			currentId = "#" + currentChar
			$(currentId).addClass("inactive")
	numberOfStartingLetters = index - 1
	console.log(numberOfStartingLetters)
