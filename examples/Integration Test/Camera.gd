@tool extends InterpolatedCamera3D

func _init():
  self.add_child(Marker3D.new())
  # FIXME: self.add_gizmo(EditorNode3DGizmo.new())
  pass

func _ready():
  self.look_at((self.get_parent() as Node3D).global_position, Vector3.UP)
