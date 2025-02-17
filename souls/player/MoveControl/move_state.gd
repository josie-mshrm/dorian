## The base class for all movement related state machine objects. Each character should
## have it's own movement controller, but use the same state nodes
class_name MoveState
extends LimboState

var soul : DynamicSoul
var control : LimboHSM
