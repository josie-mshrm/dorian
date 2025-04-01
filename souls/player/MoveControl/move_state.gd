## The base class for all movement related state machine objects. Each character should
## have it's own movement controller, but use the same state nodes
class_name MoveState
extends LimboState

var soul : DynamicSoul
var control : MoveControl

func add_min_timer_node(time) -> Timer:
	var enter_timer = Timer.new()
	soul.add_child.call_deferred(enter_timer)
	enter_timer.process_callback = Timer.TIMER_PROCESS_PHYSICS
	enter_timer.wait_time = time
	enter_timer.one_shot = true
	return enter_timer
