extends AudioStreamPlayer

@export var fadeTime: float = 2.5
@export var maxVolume: float = 0.0


var loop_ativo: bool = true
var myTween: Tween
var timer : Timer

func _ready() -> void:
	# Conects Godot's native signal that warns when the music ends
	finished.connect(_on_music_ended)
	timer = Timer.new()
	add_child(timer)
	timer.timeout.connect(startFadeOut)

# Function to play with fade in
func playMusic(mp3Path : String) -> void:
	# Loads the mp3 file into RAM
	var newTrack = load(mp3Path)
	
	if newTrack:
		stream = newTrack
		startCompleteCycle()
	else:
		push_error("Error: It was not possible to find the specified file in the path: ", mp3Path)

# Function that takes care of beggining of the music and the fade out schedule
func startCompleteCycle() -> void:
	volume_db = -80.0 # Starts in silence
	play()
	
	# Interupts any current volume transitions
	if myTween: myTween.kill()
	
	# Applies the slow fade in
	myTween = create_tween()
	myTween.tween_property(self, "volume_db", maxVolume, fadeTime)
	
	# Schedules the auto fade out before the music ends
	# Calculates the music's total length minus fade out time
	var waitTime = stream.get_length() - fadeTime
	
	# Creates a timer that will play the fade out at the right time
	if waitTime > 0:
		timer.start(waitTime)

func safeCheck() -> void:
	pass

# Slowly lowers the volume until total silence
func startFadeOut() -> void:
	if not playing : return
	if myTween : myTween.kill()
	
	myTween = create_tween()
	myTween.tween_property(self, "volume_db", -80.0, fadeTime)
	

func switchMusic(newMp3Path: String, transitionSpeed: float = 2.0) -> void:
	# If nothing is playing, starts the new song
	if not playing:
		loop_ativo = true
		timer.stop()
		playMusic(newMp3Path)
		return
	
	# If something is already playing, turns off the loop so the old track doesn't restart
	loop_ativo = false
	
	if myTween : myTween.kill()
	
	myTween = create_tween()
	myTween.tween_property(self, "volume_db", -80.0, fadeTime)
	
	# Utizes a tween_callback to load and starts the new track the moment the old volume hits 0
	myTween.tween_callback(
		func():
			loop_ativo = true # Turns the loop system back on
			playMusic(newMp3Path)
	)


# Fade loop
func _on_music_ended() -> void:
	if loop_ativo:
		# If the loop is on, plays the same music again from the beggining
		startCompleteCycle()
