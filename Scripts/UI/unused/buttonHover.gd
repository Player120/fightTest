extends Button

@export var cor_neutral: Color = Color.WHITE
@export var cor_hover: Color = Color(0.7, 0.8, 1.0) # Um tom suave/pastel para o hover
@export var tempo_transicao: float = 0.2          # Tempo da suavização (em segundos)

var estilo_unico: StyleBoxTexture
var meu_tween: Tween

func _ready() -> void:
	# 1. Pegamos o sprite do estado normal do seu tema e o duplicamos
	var estilo_original = get_theme_stylebox("normal", "Button")
	
	if estilo_original is StyleBoxTexture:
		estilo_unico = estilo_original.duplicate() as StyleBoxTexture
		
		# 2. MÁGICA: Aplicamos o MESMO estilo tanto para o "normal" quanto para o "hover"
		# Isso impede a Godot de dar aquele "estalo" seco ao passar o mouse
		add_theme_stylebox_override("normal", estilo_unico)
		add_theme_stylebox_override("hover", estilo_unico)
		add_theme_stylebox_override("focus", estilo_unico) # Opcional: protege contra o foco do teclado
		
		# Define a cor inicial
		estilo_unico.modulate_color = cor_neutral

	# 3. Conecta os sinais nativos de entrada e saída do mouse
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered() -> void:
	_transicionar_cor(cor_hover)

func _on_mouse_exited() -> void:
	_transicionar_cor(cor_neutral)

func _transicionar_cor(cor_alvo: Color) -> void:
	if estilo_unico:
		# Se já existia uma transição rodando, paramos ela para não dar conflito
		if meu_tween:
			meu_tween.kill()
		
		# Cria a animação suave da cor do sprite
		meu_tween = create_tween()
		meu_tween.tween_property(estilo_unico, "modulate_color", cor_alvo, tempo_transicao)\
			.set_trans(Tween.TRANS_SINE)\
			.set_ease(Tween.EASE_OUT)
