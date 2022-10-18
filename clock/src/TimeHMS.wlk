import BaseTime.*
import TimeSeconds.*
import TimeMS.*
import TimeDHMS.*

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
