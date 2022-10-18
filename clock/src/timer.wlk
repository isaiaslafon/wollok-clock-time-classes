import wollok.game.*
import clock.*

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