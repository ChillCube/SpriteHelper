# sprite_helper.gd
extends RefCounted
class_name SpriteHelper

# ============================================
# SPRITE HELPER - Utility functions for Godot Sprites
# Version: 1.0
# ============================================

# Prevent instantiation
func _init(): ## Called when class is instantiated - prevents creating instances
	if not Engine.is_editor_hint():
		push_warning("SpriteHelper is a static class - use SpriteHelper.function_name() directly")

# ============================================
# SIZE & DIMENSIONS
# ============================================

static func get_size(sprite: Sprite2D) -> Vector2: ## Get the actual size of the sprite in world units
	if not sprite or not sprite.texture:
		return Vector2.ZERO
	return sprite.get_rect().size

static func get_width(sprite: Sprite2D) -> float: ## Get sprite width in world units
	return get_size(sprite).x

static func get_height(sprite: Sprite2D) -> float: ## Get sprite height in world units
	return get_size(sprite).y

static func get_center(sprite: Sprite2D) -> Vector2: ## Get the center position of the sprite (local coordinates)
	return get_size(sprite) / 2

static func get_global_center(sprite: Sprite2D) -> Vector2: ## Get the global center position of the sprite
	return sprite.global_position + get_center(sprite)

static func set_size(sprite: Sprite2D, new_size: Vector2) -> void: ## Set sprite size by changing scale
	if not sprite or not sprite.texture:
		return
	
	var original_size = get_size(sprite)
	if original_size == Vector2.ZERO:
		return
	
	sprite.scale = new_size / original_size

static func set_width(sprite: Sprite2D, width: float) -> void: ## Set sprite width while maintaining aspect ratio
	if not sprite or not sprite.texture:
		return
	
	var current_size = get_size(sprite)
	if current_size.x == 0:
		return
	
	var aspect = current_size.y / current_size.x
	set_size(sprite, Vector2(width, width * aspect))

static func set_height(sprite: Sprite2D, height: float) -> void: ## Set sprite height while maintaining aspect ratio
	if not sprite or not sprite.texture:
		return
	
	var current_size = get_size(sprite)
	if current_size.y == 0:
		return
	
	var aspect = current_size.x / current_size.y
	set_size(sprite, Vector2(height * aspect, height))

static func scale_to_fit(sprite: Sprite2D, target_size: Vector2) -> void: ## Scale sprite to fit within target size while maintaining aspect ratio
	var current_size = get_size(sprite)
	if current_size == Vector2.ZERO:
		return
	
	var scale_x = target_size.x / current_size.x
	var scale_y = target_size.y / current_size.y
	var scale = min(scale_x, scale_y)
	
	sprite.scale = Vector2(scale, scale)

static func scale_to_fill(sprite: Sprite2D, target_size: Vector2) -> void: ## Scale sprite to fill target size while maintaining aspect ratio (may crop)
	var current_size = get_size(sprite)
	if current_size == Vector2.ZERO:
		return
	
	var scale_x = target_size.x / current_size.x
	var scale_y = target_size.y / current_size.y
	var scale = max(scale_x, scale_y)
	
	sprite.scale = Vector2(scale, scale)

# ============================================
# POSITIONING & ALIGNMENT
# ============================================

static func center_in_parent(sprite: Sprite2D) -> void: ## Center sprite relative to its parent
	var parent = sprite.get_parent()
	if not parent:
		return
	
	if parent is Node2D:
		sprite.position = Vector2.ZERO
	elif parent is Control:
		sprite.position = parent.size / 2

static func align_to_screen_center(sprite: Sprite2D) -> void: ## Align sprite to screen center
	var viewport = sprite.get_viewport()
	if not viewport:
		return
	
	var screen_center = viewport.get_visible_rect().size / 2
	sprite.global_position = screen_center

enum ScreenCorner { TOP_LEFT, TOP_RIGHT, BOTTOM_LEFT, BOTTOM_RIGHT }

static func align_to_screen_corner(sprite: Sprite2D, corner: ScreenCorner, margin: Vector2 = Vector2(10, 10)) -> void: ## Align sprite to screen corner
	var viewport = sprite.get_viewport()
	if not viewport:
		return
	
	var screen_size = viewport.get_visible_rect().size
	var sprite_size = get_size(sprite)
	
	match corner:
		ScreenCorner.TOP_LEFT:
			sprite.global_position = margin + sprite_size / 2
		ScreenCorner.TOP_RIGHT:
			sprite.global_position = Vector2(screen_size.x - margin.x - sprite_size.x / 2, margin.y + sprite_size.y / 2)
		ScreenCorner.BOTTOM_LEFT:
			sprite.global_position = Vector2(margin.x + sprite_size.x / 2, screen_size.y - margin.y - sprite_size.y / 2)
		ScreenCorner.BOTTOM_RIGHT:
			sprite.global_position = screen_size - margin - sprite_size / 2

static func position_relative_to(sprite: Sprite2D, target: Node2D, offset: Vector2 = Vector2(50, 0), relative_pos: String = "right") -> void: ## Position sprite relative to another node
	match relative_pos:
		"right":
			sprite.global_position = target.global_position + Vector2(get_width(sprite) / 2 + offset.x, offset.y)
		"left":
			sprite.global_position = target.global_position + Vector2(-get_width(sprite) / 2 - offset.x, offset.y)
		"above":
			sprite.global_position = target.global_position + Vector2(offset.x, -get_height(sprite) / 2 - offset.y)
		"below":
			sprite.global_position = target.global_position + Vector2(offset.x, get_height(sprite) / 2 + offset.y)

# ============================================
# VISUAL EFFECTS
# ============================================

static func set_color(sprite: Sprite2D, color: Color) -> void: ## Set sprite color tint
	sprite.modulate = color

static func set_opacity(sprite: Sprite2D, opacity: float) -> void: ## Set sprite opacity (0 = invisible, 1 = fully visible)
	sprite.modulate.a = clamp(opacity, 0.0, 1.0)

static func make_grayscale(sprite: Sprite2D) -> void: ## Convert sprite to grayscale using shader
	var shader_material = ShaderMaterial.new()
	var shader_code = """
	shader_type canvas_item;
	
	void fragment() {
		vec4 color = texture(TEXTURE, UV);
		float gray = dot(color.rgb, vec3(0.299, 0.587, 0.114));
		COLOR = vec4(gray, gray, gray, color.a);
	}
	"""
	shader_material.shader = Shader.new()
	shader_material.shader.code = shader_code
	sprite.material = shader_material

static func make_outline(sprite: Sprite2D, color: Color = Color.BLACK, size: float = 2.0) -> void: ## Add outline effect to sprite
	var shader_material = ShaderMaterial.new()
	var shader_code = """
	shader_type canvas_item;
	
	uniform vec4 outline_color : source_color;
	uniform float outline_size : hint_range(0, 10);
	
	void fragment() {
		vec4 color = texture(TEXTURE, UV);
		float alpha = color.a;
		
		for (float x = -outline_size; x <= outline_size; x++) {
			for (float y = -outline_size; y <= outline_size; y++) {
				if (x == 0.0 && y == 0.0) continue;
				float outline_alpha = texture(TEXTURE, UV + vec2(x, y) / TEXTURE_PIXEL_SIZE).a;
				alpha = max(alpha, outline_alpha);
			}
		}
		
		COLOR = mix(outline_color, color, color.a);
		COLOR.a = alpha;
	}
	"""
	shader_material.shader = Shader.new()
	shader_material.shader.code = shader_code
	shader_material.set_shader_parameter("outline_color", color)
	shader_material.set_shader_parameter("outline_size", size)
	sprite.material = shader_material

static func remove_effects(sprite: Sprite2D) -> void: ## Remove all shader effects from sprite
	sprite.material = null

# ============================================
# FLIP & ROTATION
# ============================================

static func flip_horizontal(sprite: Sprite2D, flipped: bool = true) -> void: ## Flip sprite horizontally
	sprite.flip_h = flipped

static func flip_vertical(sprite: Sprite2D, flipped: bool = true) -> void: ## Flip sprite vertically
	sprite.flip_v = flipped

static func reset_flip(sprite: Sprite2D) -> void: ## Reset both flip states
	sprite.flip_h = false
	sprite.flip_v = false

static func rotate_to_angle(sprite: Sprite2D, angle_degrees: float) -> void: ## Rotate sprite to specific angle in degrees
	sprite.rotation_degrees = angle_degrees

static func rotate_to_direction(sprite: Sprite2D, target_position: Vector2) -> void: ## Rotate sprite to face a target position
	var direction = target_position - sprite.global_position
	sprite.rotation = direction.angle()

static func look_at_target(sprite: Sprite2D, target: Node2D) -> void: ## Rotate sprite to face another node
	rotate_to_direction(sprite, target.global_position)

# ============================================
# ANIMATIONS (Requires sprite to be in scene tree)
# ============================================

static func fade_in(sprite: Sprite2D, duration: float = 0.5) -> void: ## Fade in sprite
	if not sprite.is_inside_tree():
		push_warning("Sprite not in scene tree, cannot animate")
		return
	
	var tween = sprite.create_tween()
	sprite.modulate.a = 0
	tween.tween_property(sprite, "modulate:a", 1.0, duration)

static func fade_out(sprite: Sprite2D, duration: float = 0.5, free_on_complete: bool = false) -> void: ## Fade out sprite
	if not sprite.is_inside_tree():
		push_warning("Sprite not in scene tree, cannot animate")
		return
	
	var tween = sprite.create_tween()
	tween.tween_property(sprite, "modulate:a", 0.0, duration)
	if free_on_complete:
		tween.tween_callback(sprite.queue_free)

static func scale_pulse(sprite: Sprite2D, scale_amount: float = 1.2, duration: float = 0.5) -> void: ## Pulse scale animation
	if not sprite.is_inside_tree():
		push_warning("Sprite not in scene tree, cannot animate")
		return
	
	var original_scale = sprite.scale
	var tween = sprite.create_tween()
	tween.set_loops()
	tween.tween_property(sprite, "scale", original_scale * scale_amount, duration / 2)
	tween.tween_property(sprite, "scale", original_scale, duration / 2)

static func bounce(sprite: Sprite2D, height: float = 50.0, duration: float = 0.5) -> void: ## Bounce animation
	if not sprite.is_inside_tree():
		push_warning("Sprite not in scene tree, cannot animate")
		return
	
	var original_y = sprite.position.y
	var tween = sprite.create_tween()
	tween.set_loops()
	tween.tween_property(sprite, "position:y", original_y - height, duration / 2).set_ease(Tween.EASE_OUT)
	tween.tween_property(sprite, "position:y", original_y, duration / 2).set_ease(Tween.EASE_IN)

static func shake(sprite: Sprite2D, intensity: float = 10.0, duration: float = 0.3) -> void: ## Shake animation
	if not sprite.is_inside_tree():
		push_warning("Sprite not in scene tree, cannot animate")
		return
	
	var original_pos = sprite.position
	var tween = sprite.create_tween()
	
	for i in range(5):
		var offset = Vector2(randf_range(-intensity, intensity), randf_range(-intensity, intensity))
		tween.tween_property(sprite, "position", original_pos + offset, duration / 10)
	
	tween.tween_property(sprite, "position", original_pos, duration / 10)

static func wobble(sprite: Sprite2D, intensity: float = 5.0, duration: float = 0.2) -> void: ## Wobble/rotation shake animation
	if not sprite.is_inside_tree():
		push_warning("Sprite not in scene tree, cannot animate")
		return
	
	var original_rot = sprite.rotation_degrees
	var tween = sprite.create_tween()
	
	for i in range(4):
		tween.tween_property(sprite, "rotation_degrees", original_rot + intensity, duration / 4)
		tween.tween_property(sprite, "rotation_degrees", original_rot - intensity, duration / 4)
	
	tween.tween_property(sprite, "rotation_degrees", original_rot, duration / 4)

# ============================================
# TEXTURE MANAGEMENT
# ============================================

static func change_texture(sprite: Sprite2D, new_texture: Texture2D, keep_size: bool = true) -> void: ## Change sprite texture, optionally keeping current size
	if not sprite:
		return
	
	var old_size = get_size(sprite)
	sprite.texture = new_texture
	
	if keep_size and old_size != Vector2.ZERO:
		set_size(sprite, old_size)

static func set_region(sprite: Sprite2D, region: Rect2) -> void: ## Use only a region of the texture
	sprite.region_enabled = true
	sprite.region_rect = region

static func disable_region(sprite: Sprite2D) -> void: ## Disable region mode (use full texture)
	sprite.region_enabled = false

static func get_texture_name(sprite: Sprite2D) -> String: ## Get the name of the current texture
	if not sprite or not sprite.texture:
		return "No texture"
	return sprite.texture.resource_path.get_file()

# ============================================
# COLLISION & PHYSICS
# ============================================

static func add_collision_shape(sprite: Sprite2D) -> CollisionShape2D: ## Add a collision shape that matches sprite size
	if not sprite or not sprite.texture:
		push_warning("Cannot add collision shape: sprite or texture missing")
		return null
	
	var collision_shape = CollisionShape2D.new()
	var rect_shape = RectangleShape2D.new()
	var sprite_size = get_size(sprite)
	
	rect_shape.size = sprite_size
	collision_shape.shape = rect_shape
	
	sprite.add_child(collision_shape)
	return collision_shape

static func add_circle_collision(sprite: Sprite2D, radius_ratio: float = 0.5) -> CollisionShape2D: ## Add a circular collision shape
	if not sprite or not sprite.texture:
		push_warning("Cannot add collision shape: sprite or texture missing")
		return null
	
	var collision_shape = CollisionShape2D.new()
	var circle_shape = CircleShape2D.new()
	var sprite_size = get_size(sprite)
	
	circle_shape.radius = min(sprite_size.x, sprite_size.y) * radius_ratio
	collision_shape.shape = circle_shape
	
	sprite.add_child(collision_shape)
	return collision_shape

# ============================================
# CONVENIENCE FUNCTIONS
# ============================================

static func create_sprite(parent: Node, texture: Texture2D, position: Vector2, scale: Vector2 = Vector2.ONE) -> Sprite2D: ## Create a complete sprite node
	var sprite = Sprite2D.new()
	sprite.texture = texture
	sprite.position = position
	sprite.scale = scale
	
	parent.add_child(sprite)
	return sprite

static func duplicate_sprite(sprite: Sprite2D, parent: Node, position_offset: Vector2 = Vector2.ZERO) -> Sprite2D: ## Create a duplicate of a sprite
	var new_sprite = Sprite2D.new()
	new_sprite.texture = sprite.texture
	new_sprite.scale = sprite.scale
	new_sprite.modulate = sprite.modulate
	new_sprite.position = sprite.position + position_offset
	new_sprite.rotation = sprite.rotation
	new_sprite.flip_h = sprite.flip_h
	new_sprite.flip_v = sprite.flip_v
	
	parent.add_child(new_sprite)
	return new_sprite

static func toggle_visibility(sprite: Sprite2D) -> void: ## Toggle sprite visibility
	sprite.visible = not sprite.visible

static func is_visible_on_screen(sprite: Sprite2D) -> bool: ## Check if sprite is currently visible on screen
	if not sprite.is_inside_tree():
		return false
	
	var viewport = sprite.get_viewport()
	if not viewport:
		return false
	
	var camera = viewport.get_camera_2d()
	if not camera:
		return true
	
	var sprite_rect = Rect2(sprite.global_position - get_center(sprite), get_size(sprite))
	return camera.is_position_in_rect(sprite_rect)

# ============================================
# COLOR & BLENDING
# ============================================

static func set_blend_mode(sprite: Sprite2D, mode: String) -> void: ## Set sprite blend mode (mix, add, subtract, multiply)
	match mode:
		"mix":
			sprite.self_modulate = Color.WHITE
		"add":
			var mat = ShaderMaterial.new()
			mat.shader = Shader.new()
			mat.shader.code = "shader_type canvas_item; void fragment() { COLOR = texture(TEXTURE, UV) + vec4(0.5, 0.5, 0.5, 0); }"
			sprite.material = mat
		"multiply":
			var mat = ShaderMaterial.new()
			mat.shader = Shader.new()
			mat.shader.code = "shader_type canvas_item; void fragment() { COLOR = texture(TEXTURE, UV) * vec4(0.5, 0.5, 0.5, 1); }"
			sprite.material = mat

static func flash_white(sprite: Sprite2D, duration: float = 0.1) -> void: ## Flash sprite white (hit effect)
	if not sprite.is_inside_tree():
		return
	
	var original_color = sprite.modulate
	sprite.modulate = Color.WHITE
	await sprite.get_tree().create_timer(duration).timeout
	sprite.modulate = original_color

static func flash_red(sprite: Sprite2D, duration: float = 0.1) -> void: ## Flash sprite red (damage effect)
	if not sprite.is_inside_tree():
		return
	
	var original_color = sprite.modulate
	sprite.modulate = Color.RED
	await sprite.get_tree().create_timer(duration).timeout
	sprite.modulate = original_color
