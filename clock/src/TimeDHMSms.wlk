import TimeDHMS.*

class TimeDHMSms inherits TimeDHMS{
	//Time implementation with harder tick/unTick methods
	var frameRate = 1
	var frame = 0
	
	method frameRate() { 
		return frameRate
	}
	
	method validateFrameRate(newFrameRate){
		if(newFrameRate < 0 or newFrameRate.trincate(0) != 0){ self.error("Frame Rate must be a whole number and > 0!")}	
	}
	
	method frameRate(newFrameRate) { 
		self.validateFrameRate(newFrameRate)
		frameRate = newFrameRate
	}
	
	override method frame() { 
		return frame
	}
	
	override method isZeroTime(){
		return frame == 0 and super() 
	}
	
	override method setTimeSeconds(fullSeconds){
		super(fullSeconds)
		frame = 0
	}
	
	override method setTimeMS(fullMinutes,_seconds){
		super(fullMinutes, _seconds)
		frame = 0
	}
	
    override method setTimeHMS(fullHours,_minutes,_seconds){
		super(fullHours, _minutes, _seconds)
		frame = 0
	}
	
    override method setTimeDHMS(_days, _hours,_minutes,_seconds){
    	super(_days, _hours, _minutes, _seconds)
		frame = 0
	}	
	
	method millisecondsBySecond(){
		return 1000
	}
	
	method millisecondsByframe(){
		return self.millisecondsBySecond() / frameRate 
	}
	method milliseconds(){
		return self.millisecondsByframe() * frame
	}
	
	override method tick(){
		if (frame < frameRate) { frame +=1} else { self.tickSeconds()}
	}
	
	override method unTick(){
		self.validateUnTick()
		if(frame == 0) {self.unTickSeconds()} else { frame -= 1 }
	}
	
	method tickSeconds(){
		frame = 0
		if(seconds == 0){ self.tickMinutes() } else { seconds += 1}
	}
	
	method unTickSeconds(){
		frame = frameRate
		if(seconds == 0){ self.unTickMinutes() } else { seconds -= 1}
	}
}