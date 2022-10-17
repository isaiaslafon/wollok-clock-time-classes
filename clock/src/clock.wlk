import wollok.game.*

class BaseTime{
	//Used to calculate minutes and hours
	method secondsByMinute() {
		return 60
	}

	method secondsByHour() {
		return self.secondsByMinute() * self.minutesByHour()
	}
	
	method secondsByDay(){
		return self.minutesByDay() * self.secondsByMinute()
		//return self.hoursByDay() * self.secondsByHour()
	}
	
	method minutesByHour(){
		return self.secondsByMinute() //es equivalente o 60
	}
	
	method minutesByDay(){
		return self.minutesByHour() * self.hoursByDay()
	}
	
	method hoursByDay(){
		return 24
	}
	
	method secondsByMinutes(_minutes){
		return self.secondsByMinute() * _minutes
	}
	
	method secondsByHours(_hours){
		return self.secondsByHour() * _hours
	}
	
	method secondsByDays(_days){
		return self.secondsByDay() * _days
	}
	
	method minutesByHours(_hours){
		return self.minutesByHour() * _hours
	}
	
	method minutesByDays(_days){
		return self.minutesByDay() * _days
	}
	
	method hoursByDays(_days){
		return self.hoursByDay() * _days
	}
	
	
	method daysBySeconds(_seconds){
		return (_seconds / self.secondsByDay()).truncate(0)
	}
	
	method daysByMinutes(_minutes){
		return (_minutes / self.minutesByDay()).truncate(0)
	}
	
	method daysByHours(_hours){
		return (_hours / self.hoursByDay()).truncate(0)
	}
		
	method hoursByMinutes(_minutes){
		return (_minutes / self.minutesByHour()).truncate(0)
	}
	
	method hoursBySeconds(_seconds){
		return (_seconds / self.secondsByHour()).truncate(0)
	}
	
	method minutesBySeconds(_seconds){
		return (_seconds / self.secondsByMinute()).truncate(0)
	}
	
	method isZeroTime()

    method setTime(_time)
    method setTimeSeconds(_seconds)
    method setTimeMS(_minutes,_seconds)
    method setTimeHMS(_hours,_minutes,_seconds)
    method setTimeDHMS(_days, _hours,_minutes,_seconds)	

	method validateUnTick(){
		if(self.isZeroTime()){ self.error("There is not more time left to untick!") }
	}
	
	//Use to create a new time of the available implementations.
	method toTimeSeconds()
	method toTimeMS()
	method toTimeHMS()
	method toTimeDHMS()
	
	//Base time data
	method days()
	method hours()
	method minutes()
	method seconds()
	
	//Convert time to Minutes and Seconds
	method fullHours()
	method fullMinutes()
	method fullSeconds() //Necessary for reach() method implementation
	
	//Actions Order to advance and rewind time by the second.
	method tick()
	method unTick()
	
	//actual time is equal to time limit. 
	method reach(timeLimit){
		return self.fullSeconds() == timeLimit.fullSeconds()
	}	
}

class TimeSeconds inherits BaseTime{
	//Time implementation with harder minute seconds query calculation
	var seconds = 0 //Seconds are full, but can rename variable for compatibility with TimeMS, TImeHMS, TImeDHMS.
	
	override method isZeroTime(){
		return seconds == 0
	}
	
	override method setTime(time){
		seconds = time.fullSeconds()
	}
	
	method validateFull(amount){
		if(amount < 0){ self.error(amount + " must be >= 0 ") }
	}
	
	method validate0ToUnder(amount, limit){
		if(not amount.between(0,limit-1)){ self.error( amount + " must be between 0 and " + limit) }
	}
	
	method validate0ToUnder60(amount){
		self.validate0ToUnder(amount, 60)
	}	
	
	method validate0ToUnder24(amount){
		self.validate0ToUnder(amount, 24)
	}
	
	override method setTimeSeconds(_fullSeconds){
		self.validateFull(_fullSeconds)
		seconds = _fullSeconds
	}
	
	override method setTimeMS(_fullMinutes,_seconds){
		self.validate0ToUnder60(_seconds)
		self.validateFull(_fullMinutes)
		seconds = self.secondsByMinutes(_fullMinutes) + _seconds
	}
	
    override method setTimeHMS(_fullHours,_minutes,_seconds){
		self.validate0ToUnder60(_seconds)
		self.validate0ToUnder60(_minutes)
		self.validateFull(_fullHours)
		seconds = self.secondsByHours(_fullHours) + self.secondsByMinutes(_minutes) + _seconds
	}
	
    override method setTimeDHMS(_days, _hours,_minutes,_seconds){
    	self.validate0ToUnder60(_seconds)
		self.validate0ToUnder60(_minutes)
		self.validate0ToUnder24(_hours)
		self.validateFull(_days)
		seconds = self.secondsByDays(_days) + self.secondsByHours(_hours) + self.secondsByMinutes(_minutes) + _seconds
	}	
	
	override method toTimeSeconds(){
		return new TimeSeconds(seconds = seconds)	
	}	
	
	override  method toTimeMS(){
		return new TimeMS(seconds = self.seconds(), minutes = self.fullMinutes())	
	}
	
	override method toTimeHMS(){
		return new TimeHMS(seconds = self.seconds(), minutes = self.minutes(), hours = self.fullHours())	
	}
	
	override method toTimeDHMS(){
		return new TimeDHMS(seconds = self.seconds(), minutes = self.minutes(), hours = self.hours(), days = self.days())	
	}
	
	override method days(){
		return self.daysBySeconds(seconds)
	}
	
	override method hours(){
		return self.fullHours() - self.hoursByDays(self.days()) 
	}
	
	override method minutes(){
		return self.fullMinutes() - self.minutesByHours(self.fullHours())
	}
	
	override method seconds(){
		return seconds - self.secondsByMinutes(self.fullMinutes())
	}
		
	override method fullHours(){
		return self.hoursBySeconds(seconds)
	}
		
	override method fullMinutes(){
		return self.minutesBySeconds(seconds)
	}
	
	override method fullSeconds(){
		return seconds
	}
	
	override method tick(){
		seconds += 1
	}
	
	override method unTick(){
		self.validateUnTick()
		seconds -= 1
	}
}

class TimeMS inherits TimeSeconds{
	//Time implementation with harder tick/unTick methods
	//seconds = 0 is in Parent but here is limited to 59
	var minutes = 0
	
	override method isZeroTime(){
		return minutes == 0 and super() 
	}
	
	override method setTimeSeconds(fullSeconds){
		self.validateFull(fullSeconds)
		minutes = self.minutesBySeconds(fullSeconds)
		//If the order is inverted it fails!!!
		seconds = fullSeconds - self.secondsByMinutes(minutes)
	}
	
	override method setTimeMS(fullMinutes,_seconds){
		self.validate0ToUnder60(_seconds)
		self.validateFull(fullMinutes)
		minutes = fullMinutes
		seconds = _seconds
	}
	
    override method setTimeHMS(fullHours,_minutes,_seconds){
		self.validateFull(fullHours)
		self.validate0ToUnder60(_minutes)
		self.validate0ToUnder60(_seconds)
		minutes = self.minutesByHours(fullHours) + _minutes
		seconds = _seconds
	}
	
    override method setTimeDHMS(days, hours,_minutes,_seconds){
    	self.validateFull(days)
    	self.validate0ToUnder24(hours)
    	self.validate0ToUnder60(_minutes)
    	self.validate0ToUnder60(_seconds)
		minutes = self.minutesByDays(days) + self.minutesByHours(hours) + _minutes
		seconds = _seconds
	}	
	
	override method toTimeSeconds(){
		return new TimeSeconds(seconds = self.fullSeconds())	
	}	
	
	override  method toTimeMS(){
		return new TimeMS(minutes = minutes, seconds = seconds)	
	}
	
	override  method toTimeHMS(){
		return new TimeHMS(hours = self.fullHours(), minutes = self.minutes(), seconds = self.seconds())	
	}
	
	override  method toTimeDHMS(){
		return new TimeDHMS(days = self.days(), hours = self.hours(), minutes = self.minutes(), seconds = seconds)	
	}
	
	override method days(){
		return self.daysByMinutes(minutes)
	}
	
	override method hours(){
		return self.fullHours() - self.hoursByDays(self.days()) 
	}
	
	override method minutes(){
		return minutes - self.minutesByHours(self.fullHours()) 
	}
	
	override method seconds(){
		return seconds 
	}
			
	override method fullHours(){
		return self.hoursByMinutes(minutes)
	}
		
	override method fullMinutes(){
		return minutes
	}
	
	override method fullSeconds(){
		return self.secondsByMinutes(minutes) + seconds
	}
		
	override method tick(){
		if(seconds == 59) {self.tickMinutes()} else { seconds += 1 }
	}
	
	override method unTick(){
		self.validateUnTick()
		if(seconds == 0) {self.unTickMinutes()} else { seconds -= 1 }
	}
	
	method tickMinutes(){
		seconds = 0
		minutes += 1 
	}
	
	method unTickMinutes(){ //only for unTick internal use
		seconds = 59
		minutes -= 1 
	}	
}

class TimeHMS inherits TimeMS{
	//Time implementation with harder tick/unTick methods
	var hours = 0
	
	override method isZeroTime(){
		return hours == 0 and super() 
	}
	
	override method setTimeSeconds(fullSeconds){
		self.validateFull(fullSeconds)
		
		hours = self.hoursBySeconds(fullSeconds)
		//If the order is inverted it fails!!!
		minutes = self.minutesBySeconds(fullSeconds) - self.minutesByHours(hours)
		seconds = fullSeconds - (self.secondsByMinutes(minutes) + self.secondsByHours(hours))
	}
	
	override method setTimeMS(fullMinutes,_seconds){
		self.validate0ToUnder60(_seconds)
		self.validateFull(fullMinutes)
		
		hours = self.hoursByMinutes(fullMinutes)
		//If the order is inverted it fails!!!
		minutes = fullMinutes - self.minutesByHours(hours)
		seconds = _seconds
	}
	
    override method setTimeHMS(fullHours,_minutes,_seconds){
		self.validateFull(fullHours)
		self.validate0ToUnder60(_minutes)
		self.validate0ToUnder60(_seconds)
		
		hours = fullHours
		minutes = _minutes
		seconds = _seconds
	}
	
    override method setTimeDHMS(days, _hours,_minutes,_seconds){
    	self.validateFull(days)
    	self.validate0ToUnder24(hours)
    	self.validate0ToUnder60(_minutes)
    	self.validate0ToUnder60(_seconds)
		
		hours = _hours + self.hoursByDays(days)
		minutes = _minutes
		seconds = _seconds
	}	
	
	override method toTimeSeconds(){
		return new TimeSeconds(seconds = self.fullSeconds())	
	}	
	
	override  method toTimeMS(){
		return new TimeMS(seconds = self.seconds(), minutes = self.fullMinutes())	
	}
	
	override  method toTimeHMS(){
		return new TimeHMS(seconds = self.seconds(), minutes = self.minutes(), hours = hours)	
	}
	
	override  method toTimeDHMS(){
		return new TimeDHMS(seconds = self.seconds(), minutes = self.minutes(), hours = self.hours(), days = self.days())	
	}
	
	
	override method days(){
		return self.daysByHours(hours)
	}
	
	override method hours(){
		return hours - self.hoursByDays(self.days()) 
	}
	
	override method minutes(){
		return minutes
	}
			
	override method fullHours(){
		return hours
	}
		
	override method fullMinutes(){
		return self.minutesByHours(hours) + minutes
	}
	
	override method fullSeconds(){
		return (self.fullMinutes() * self.secondsByMinute()) + seconds
	}
	
	override method tick(){
		if(seconds == 59) {self.tickMinutes()} else { seconds += 1 }
	}
	
	override method tickMinutes(){
		seconds = 0
		if(minutes == 59) {self.tickHours()} else { minutes += 1 } 
	}
	
	method tickHours(){
		minutes = 0
		hours += 1
	}
	
	override method unTick(){
		self.validateUnTick()
		if(seconds == 0) {self.unTickMinutes()} else { seconds -= 1 }
	}
	
	override method unTickMinutes(){ //only for unTick internal use
		seconds = 59
		if(minutes == 0) {self.unTickHours()} else { minutes -= 1 } 
	}
	
	method unTickHours(){ //only for unTick internal use
		minutes = 59
		hours -= 1
	}
	
}



class TimeDHMS inherits TimeHMS{
	//Time implementation with harder tick/unTick methods
	var days = 0
		
	override method isZeroTime(){
		return days == 0 and super() 
	}
	
	override method setTimeSeconds(fullSeconds){
		self.validateFull(fullSeconds)
		
		days = self.daysBySeconds(fullSeconds)
		//If the order is inverted it fails!!!
		hours =  self.hoursBySeconds(fullSeconds) - self.hoursByDays(days)
		minutes = self.minutesBySeconds(fullSeconds) - self.minutesByHours(hours)
		seconds = fullSeconds - (self.secondsByMinutes(minutes) + self.secondsByHours(hours) + self.secondsByDays(days))
	}
	
	override method setTimeMS(fullMinutes,_seconds){
		self.validate0ToUnder60(_seconds)
		self.validateFull(fullMinutes)
		
		days = self.daysByMinutes(fullMinutes)
		//If the order is inverted it fails!!!
		hours = self.hoursByMinutes(fullMinutes) - self.hoursByDays(days)
		minutes = fullMinutes - (self.minutesByDays(days) +  self.minutesByHours(hours))
		seconds = _seconds
	}
	
    override method setTimeHMS(fullHours,_minutes,_seconds){
		self.validateFull(fullHours)
		self.validate0ToUnder60(_minutes)
		self.validate0ToUnder60(_seconds)
				
		days = self.daysByHours(fullHours)
		//If the order is inverted it fails!!!
		hours = fullHours - self.hoursByDays(days)
		minutes = _minutes
		seconds = _seconds
	}
	
    override method setTimeDHMS(_days, _hours,_minutes,_seconds){
    	self.validateFull(_days)
    	self.validate0ToUnder24(_hours)
    	self.validate0ToUnder60(_minutes)
    	self.validate0ToUnder60(_seconds)
		
		days = _days
		hours = _hours
		minutes = _minutes
		seconds = _seconds
	}	
	
	override  method toTimeHMS(){
		return new TimeHMS(seconds = self.seconds(), minutes = self.minutes(), hours = self.fullHours())	
	}
	
	override  method toTimeDHMS(){
		return new TimeDHMS(seconds = self.seconds(), minutes = self.minutes(), hours = hours, days = days)	
	}
	
	override method days(){
		return days
	}
	
	override method hours(){
		return hours 
	}
	
	override method minutes(){
		return minutes
	}
			
	override method fullHours(){
		return hours + self.hoursByDays(days)
	}
		
	override method fullMinutes(){
		return self.minutesByHours(self.fullHours()) + minutes
	}
	
	override method fullSeconds(){
		return (self.fullMinutes() * self.secondsByMinute()) + seconds
	}
	
	
	
	override method tickHours(){
		minutes = 0
		if(hours == 23) { self.tickDays() } else { hours += 1}
	}
	
	override method unTickHours(){ //only for unTick internal use
		minutes = 59
		if(hours == 0) {self.unTickDays()} else { hours -= 1 }
	}
	
	method tickDays(){
		hours = 00
		days += 1
	}

	method unTickDays(){	
		hours = 23
		days -= 1 
	}
}

class Clock {
	var time 
	var startTime
	var timeLimit  //
	
	method reachTimeLimit(){
		return time.reach(timeLimit)	
	}
	
	
	method setTimeHMS(hours, minutes, seconds) {
		time.setTimeHMS(hours, minutes, seconds)
	}
	
	method setLimit(hours, minutes, seconds) {
		timeLimit = new TimeHMS(hours = hours, minutes = minutes, seconds = seconds)
	}
	
	method setStart(hours, minutes, seconds) {
		startTime = new TimeHMS(hours = hours, minutes = minutes, seconds = seconds)
	}
	
	method reset() {
		time = startTime
	}
	
	method hours(){
		return time.hours()
	}
	
	method minutes(){
		return time.minutes()
	}
	
	method seconds(){
		return time.seconds()
	}
	
	method fullMinutes(){
		return time.fullMinutes()
	}
	
	method fullSeconds(){
		return time.fullSeconds()
	}
	
	method tick(){
		time.tick()
	}
	
	method unTick(){
		time.unTick()
	}
}


class Timer inherits Clock {
	var property forward = true
	var property timerName
	
	method next(){
		if(forward){ self.tick() } else{ self.unTick() }	
	}
	
	method resume(){
		game.onTick(1000,  timerName, {self.next()})
	}
	
	method pause(){ 
		game.removeTickEvent(timerName)
	}
}

class DigitDraw {
	const format = ".png"
	var property position
	var property digit
	
	method image(){
		return digit + format
	}
}

class TimerMSDraw inherits Timer{
	var property position 
	
	const digits = [new DigitDraw(position = position, digit = "questionMark"),
					new DigitDraw(position = position, digit = "questionMark"),
					new DigitDraw(position = position, digit = "colon"), 
					new DigitDraw(position = position, digit = "questionMark"),
					new DigitDraw(position = position, digit = "questionMark")]
	
	method draw(){
		digits.get(0).digit(self.firstDigit(self.minutes()))		
		digits.get(1).digit(self.secondDigit(self.minutes()))
		digits.get(3).digit(self.firstDigit(self.seconds()))
		digits.get(4).digit(self.secondDigit(self.seconds()))
	}
	
	method firstDigit(doubleDigit) {
		return (doubleDigit / 10).abs()
	}
	
	method secondDigit(doubleDigit) {
		return doubleDigit - (self.firstDigit(doubleDigit) * 10)
	}
	
	
}
