# SpriteHelper API Reference
Generated: 2026-08-01

A bunch of helper function for managing sprite2D's in godot

## Class: SpriteHelper
**Inherits:** [RefCounted](https://docs.godotengine.org/en/stable/classes/class_refcounted.html)


### 🛠️ Methods
| Method | Arguments | Returns | Description |
| :--- | :--- | :--- | :--- |
| **static func get_size()** | `sprite: Sprite2D` | `Vector2` |  Get the actual size of the sprite in world units |
| **static func get_width()** | `sprite: Sprite2D` | `float` |  Get sprite width in world units |
| **static func get_height()** | `sprite: Sprite2D` | `float` |  Get sprite height in world units |
| **static func get_center()** | `sprite: Sprite2D` | `Vector2` |  Get the center position of the sprite (local coordinates) |
| **static func get_global_center()** | `sprite: Sprite2D` | `Vector2` |  Get the global center position of the sprite |
| **static func set_size()** | `sprite: Sprite2D`<br>`new_size: Vector2` | `void` |  Set sprite size by changing scale |
| **static func set_width()** | `sprite: Sprite2D`<br>`width: float` | `void` |  Set sprite width while maintaining aspect ratio |
| **static func set_height()** | `sprite: Sprite2D`<br>`height: float` | `void` |  Set sprite height while maintaining aspect ratio |
| **static func scale_to_fit()** | `sprite: Sprite2D`<br>`target_size: Vector2` | `void` |  Scale sprite to fit within target size while maintaining aspect ratio |
| **static func scale_to_fill()** | `sprite: Sprite2D`<br>`target_size: Vector2` | `void` |  Scale sprite to fill target size while maintaining aspect ratio (may crop) |
| **static func center_in_parent()** | `sprite: Sprite2D` | `void` |  Center sprite relative to its parent |
| **static func align_to_screen_center()** | `sprite: Sprite2D` | `void` |  Align sprite to screen center |
| **static func align_to_screen_corner()** | `sprite: Sprite2D`<br>`corner: ScreenCorner`<br>`margin: Vector2 = Vector2` | `void` |  Align sprite to screen corner |
| **static func position_relative_to()** | `sprite: Sprite2D`<br>`target: Node2D`<br>`offset: Vector2 = Vector2` | `void` |  Position sprite relative to another node |
| **static func set_color()** | `sprite: Sprite2D`<br>`color: Color` | `void` |  Set sprite color tint |
| **static func set_opacity()** | `sprite: Sprite2D`<br>`opacity: float` | `void` |  Set sprite opacity (0 = invisible, 1 = fully visible) |
| **static func make_grayscale()** | `sprite: Sprite2D` | `void` |  Convert sprite to grayscale using shader |
| **static func make_outline()** | `sprite: Sprite2D`<br>`color: Color = Color.BLACK`<br>`size: float = 2.0` | `void` |  Add outline effect to sprite |
| **static func remove_effects()** | `sprite: Sprite2D` | `void` |  Remove all shader effects from sprite |
| **static func flip_horizontal()** | `sprite: Sprite2D`<br>`flipped: bool = true` | `void` |  Flip sprite horizontally |
| **static func flip_vertical()** | `sprite: Sprite2D`<br>`flipped: bool = true` | `void` |  Flip sprite vertically |
| **static func reset_flip()** | `sprite: Sprite2D` | `void` |  Reset both flip states |
| **static func rotate_to_angle()** | `sprite: Sprite2D`<br>`angle_degrees: float` | `void` |  Rotate sprite to specific angle in degrees |
| **static func rotate_to_direction()** | `sprite: Sprite2D`<br>`target_position: Vector2` | `void` |  Rotate sprite to face a target position |
| **static func look_at_target()** | `sprite: Sprite2D`<br>`target: Node2D` | `void` |  Rotate sprite to face another node |
| **static func fade_in()** | `sprite: Sprite2D`<br>`duration: float = 0.5` | `void` |  Fade in sprite |
| **static func fade_out()** | `sprite: Sprite2D`<br>`duration: float = 0.5`<br>`free_on_complete: bool = false` | `void` |  Fade out sprite |
| **static func scale_pulse()** | `sprite: Sprite2D`<br>`scale_amount: float = 1.2`<br>`duration: float = 0.5` | `void` |  Pulse scale animation |
| **static func bounce()** | `sprite: Sprite2D`<br>`height: float = 50.0`<br>`duration: float = 0.5` | `void` |  Bounce animation |
| **static func shake()** | `sprite: Sprite2D`<br>`intensity: float = 10.0`<br>`duration: float = 0.3` | `void` |  Shake animation |
| **static func wobble()** | `sprite: Sprite2D`<br>`intensity: float = 5.0`<br>`duration: float = 0.2` | `void` |  Wobble/rotation shake animation |
| **static func change_texture()** | `sprite: Sprite2D`<br>`new_texture: Texture2D`<br>`keep_size: bool = true` | `void` |  Change sprite texture, optionally keeping current size |
| **static func set_region()** | `sprite: Sprite2D`<br>`region: Rect2` | `void` |  Use only a region of the texture |
| **static func disable_region()** | `sprite: Sprite2D` | `void` |  Disable region mode (use full texture) |
| **static func get_texture_name()** | `sprite: Sprite2D` | `String` |  Get the name of the current texture |
| **static func add_collision_shape()** | `sprite: Sprite2D` | `CollisionShape2D` |  Add a collision shape that matches sprite size |
| **static func add_circle_collision()** | `sprite: Sprite2D`<br>`radius_ratio: float = 0.5` | `CollisionShape2D` |  Add a circular collision shape |
| **static func generate_collision_polygon()** | `sprite: Sprite2D`<br>`dot_count: int = 8`<br>`alpha_threshold: float = 0.1` | `PackedVector2Array` |  Trace the sprite silhouette and return polygon points for a collision shape. Casts dot_count rays from the sprite center; each ray records the outermost opaque pixel. |
| **static func add_polygon_collision()** | `sprite: Sprite2D`<br>`dot_count: int = 8`<br>`alpha_threshold: float = 0.1` | `CollisionPolygon2D` |  Add a CollisionPolygon2D child whose shape traces the sprite silhouette |
| **static func create_sprite()** | `parent: Node`<br>`texture: Texture2D`<br>`position: Vector2`<br>`scale: Vector2 = Vector2.ONE` | `Sprite2D` |  Create a complete sprite node |
| **static func duplicate_sprite()** | `sprite: Sprite2D`<br>`parent: Node`<br>`position_offset: Vector2 = Vector2.ZERO` | `Sprite2D` |  Create a duplicate of a sprite |
| **static func toggle_visibility()** | `sprite: Sprite2D` | `void` |  Toggle sprite visibility |
| **static func is_visible_on_screen()** | `sprite: Sprite2D` | `bool` |  Check if sprite is currently visible on screen |
| **static func set_blend_mode()** | `sprite: Sprite2D`<br>`mode: String` | `void` |  Set sprite blend mode (mix, add, subtract, multiply) |
| **static func flash_white()** | `sprite: Sprite2D`<br>`duration: float = 0.1` | `void` |  Flash sprite white (hit effect) |
| **static func flash_red()** | `sprite: Sprite2D`<br>`duration: float = 0.1` | `void` |  Flash sprite red (damage effect) |

---

