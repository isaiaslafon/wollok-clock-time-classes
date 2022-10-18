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
	method frame(){ 
		return 0
	}
	
	//Convert time to Minutes and Seconds
	method fullHours()
	method fullMinutes()
	method fullSeconds() //Necessary for reach() method implementation
	
	//Actions Order to advance and rewind time by the second.
	method tick()
	method unTick()
	
	//actual time is equal to time limit. 
	method reach(timeLimit){
		return self.fullSeconds() == timeLimit.fullSeconds() and self.frame() == 0
	}	
}