import AbsStaticTime.*

class BaseTime inherits StaticTime{
	method validateUnTick(){
		if(self.isZeroTime()){ self.error("There is not more time left to untick!") }
	}
	
	//Actions Order to advance and rewind time by the second.
	method tick()
	method unTick()
	
	//actual time is equal to time limit. 
	method reach(timeLimit){
		//return self.fullSeconds() == timeLimit.fullSeconds() and self.frame() == 0
		return  self.frame()   == timeLimit.frame() 
			and self.seconds() == timeLimit.seconds()
			and self.minutes() == timeLimit.minutes()
			and self.hours()   == timeLimit.hours()
			and self.days()    == timeLimit.days()
	}	
}
