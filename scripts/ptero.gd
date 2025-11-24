class_name ptero extends dino

var theta := 0.0
var a = 3
var b = 4
func jump():
	pass

func _process(_delta)->void:
	if theta < 360:
		theta += 0.01
		position.x = a**2*cos(theta)**2
		position.z = b**2*sin(theta)**2
	else : theta = 0
