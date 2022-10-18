import TimeHMS.*

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