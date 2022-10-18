import AbsBaseTime.*
import TimeSeconds.*

import TimeHMS.*
import TimeDHMS.*

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