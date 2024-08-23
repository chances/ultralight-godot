@tool extends DirectionalLight3D

@onready var env = $Environment as WorldEnvironment

func _ready():
  self.request_ready()
  env.environment.connect("property_list_changed", _envChanged)
  _envChanged()

func _exit_tree():
  env.environment.disconnect("property_list_changed", _envChanged)

func _envChanged():
  # The ambient light color controls the sky's color.
  var sky = env.environment.sky.sky_material as ShaderMaterial
  # TODO: Derive sky color from ambient light, or vice versa
  # sky.set_shader_parameter("color", env.environment.ambient_light_color)
