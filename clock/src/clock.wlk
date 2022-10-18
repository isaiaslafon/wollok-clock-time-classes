import wollok.game.*
import TimeSeconds.*
import TimeMS.*
import TimeHMS.*
import TimeDHMS.*
import TimeDHMSms.*

class Clock {
	var time 
	var startTime
	var timeLimit  //
	
	method reachTimeLimit(){
		return time.reach(timeLimit)	
	}
	
	
	method setTime(_time) {
		time = _time
	}
	
	method setLimit(_time) {
		timeLimit = _time
	}
	
	method setStart(_time) {
		startTime = _time
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
