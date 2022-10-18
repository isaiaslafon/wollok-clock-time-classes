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
