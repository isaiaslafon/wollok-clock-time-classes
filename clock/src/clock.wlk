import wollok.game.*

class BaseTime{
	
	//Used to calculate minutes and hours
	method secondsByMinute() {
		return 60
	}

	method minutesByHour(){
		return self.secondsByMinute()
	}
	
	method secondsByHour() {
		return self.secondsByMinute() * self.minutesByHour()
	}
		
	method secondsByMinutes(_minutes){
		return self.secondsByMinute() * _minutes
	}
	
	method secondsByHours(_hours){
		return self.secondsByHour() * _hours
	}
	
	method minutesByHours(_hours){
		return self.minutesByHour() * _hours
	}
	
	method isZeroTime()

    method setTime(_hours,_minutes,_seconds)
	
	method validateTime(_hours,_minutes,_seconds){
		self.validateHours(_hours)
		self.validateMinutes(_minutes)
		self.validateSeconds(_seconds)
	}
	
	method validateHours(_hours){
		if(_hours < 0){ self.error("Hours must be >= than 0") }
	}
	
	method validateMinutes(_minutes){
		if(not _minutes.between(0, 59)){ self.error("Minutes must between 0 and 59") }
	}
	
	method validateSeconds(_seconds){
		if(not _seconds.between(0, 59)){ self.error("Seconds must between 0 and 59") }
	}
	
	method validateUnTick(){
		if(self.isZeroTime()){ self.error("There is not more time left to untick!") }
	}

	
	//Use to create a new time of the available implementations.
	method toTimeSeconds()
	method toTimeHMS()
	
	//Base time data
	method hours()
	method minutes()
	method seconds()
	
	//Convert time to Minutes and Seconds
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
	var seconds = 0
	
	override method isZeroTime(){
		return seconds == 0
	}
	
	override method setTime(_hours, _minutes, _seconds){
		self.validateTime(_hours, _minutes, _seconds)
		seconds = self.secondsByHours(_hours) + self.secondsByMinutes(_minutes) + _seconds
	}
	
	override method toTimeSeconds(){
		return new TimeSeconds(seconds = seconds)	
	}	
	
	override  method toTimeHMS(){
		return new TimeHMS(seconds = self.seconds(), minutes = self.minutes(), hours = self.hours())	
	}
		
	override  method fullMinutes(){
		return (seconds / self.secondsByMinute()).truncate(0)
	}
	
	override method fullSeconds(){
		return seconds
	}
	
	override  method hours(){
		return (seconds / self.secondsByHour()).truncate(0)
	}
	
	override  method minutes(){
		return (seconds % self.secondsByHour() / self.secondsByMinute()).truncate(0)
	}
	
	override  method seconds(){
		return seconds % self.secondsByMinute()
	}
	
	override method tick(){
		seconds += 1
	}
	
	override method unTick(){
		self.validateUnTick()
		seconds -= 1
	}
}

class TimeHMS inherits BaseTime{
	//Time implementation with harder tick/unTick methods
	var seconds = 0
	var minutes = 0
	var hours = 0
	
	override method isZeroTime(){
		return hours == 0 and minutes == 0 and seconds == 0 
	}
	
	override method setTime(_hours, _minutes, _seconds){
		self.validateTime(_hours, _minutes, _seconds)
		hours = _hours
		minutes = _minutes
		seconds = _seconds
	}
	
	override method toTimeSeconds(){
		return new TimeSeconds(seconds = self.fullSeconds())	
	}	
	
	override method toTimeHMS(){
		return new TimeHMS(seconds = seconds, minutes = minutes, hours = hours)	
	}
	
	override method hours(){
		return hours
	}
	
	override method minutes(){
		return minutes
	}
	
	override method seconds(){
		return seconds
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
	
	method tickMinutes(){
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
	
	method unTickMinutes(){ //only for unTick internal use
		seconds = 59
		if(minutes == 0) {self.unTickHours()} else { minutes -= 1 } 
	}
	
	method unTickHours(){ //only for unTick internal use
		minutes = 59
		hours -= 1
	}
	
}

class Clock {
	var time 
	var startTime
	var timeLimit  //
	
	method reachTimeLimit(){
		return time.reach(timeLimit)	
	}
	
	method setTime(hours, minutes, seconds) {
		time.setTime(hours, minutes, seconds)
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

class TimeDHMS inherits TimeHMS{
	//Time implementation with harder tick/unTick methods
	var days = 0
		
	override method isZeroTime(){
		return hours == 0 and minutes == 0 and seconds == 0 
	}
	
	method validateDays(_days){
		if(_days < 0){ self.error("Days must be > than 0!")}
	}
	
 	method validateTime(_days, _hours, _minutes, _seconds){
		self.validateDays(_days)
		self.validateTime(_hours, _minutes, _seconds)
	}
	
	override method setTime(_hours, _minutes, _seconds){
		days = 0
		super(_hours, _minutes, _seconds)
	}
	
	method setTime(_days, _hours, _minutes, _seconds){
		self.validateTime(_days, _hours, _minutes, _seconds)
		days = _days
		hours = _hours
		minutes = _minutes
		seconds = _seconds
	}
	
	override method toTimeSeconds(){
		return new TimeSeconds(seconds = self.fullSeconds())	
	}	
	
	override method toTimeHMS(){
		return new TimeHMS(seconds = seconds, minutes = minutes, hours = hours)	
	}
	
	override method hours(){
		return hours
	}
	
	override method minutes(){
		return minutes
	}
	
	override method seconds(){
		return seconds
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
	
	method tickMinutes(){
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
	
	method unTickMinutes(){ //only for unTick internal use
		seconds = 59
		if(minutes == 0) {self.unTickHours()} else { minutes -= 1 } 
	}
	
	method unTickHours(){ //only for unTick internal use
		minutes = 59
		hours -= 1
	}
	
}

