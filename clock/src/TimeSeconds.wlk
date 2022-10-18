import AbsBaseTime.*

import TimeMS.*
import TimeHMS.*
import TimeDHMS.*

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