@tool
class_name FontTexture extends Texture2D

@export
var font: FontFile :
    set(value):
        font = value
        if font != null:
            font.changed.connect(_update)
        _update()

@export
var font_size: int = ThemeDB.get_default_theme().default_font_size :
    set(value):
        font_size = value
        _update()

@export
var text: String = "" :
    set(value):
        text = value
        _update()

var _line: TextLine = TextLine.new()
var _size: Vector2
var _font_variation: FontVariation

func _update():
    emit_changed()
    _update_size()

func _update_size():
    if text.is_empty() or font_size == 0:
        _size = Vector2(0,0)
    else:
        _size = font.get_string_size(text, HORIZONTAL_ALIGNMENT_CENTER, -1, font_size, 3, TextServer.DIRECTION_AUTO, TextServer.ORIENTATION_HORIZONTAL)
    emit_changed()

func _get_offset_centered() -> Vector2:
    return Vector2(0, font.get_descent(font_size)*0.5)

func _get_height() -> int:
    return _size.y

func _get_width() -> int:
    return _size.x

func _draw_rect(to_canvas_item, rect, tile, modulate, transpose):
    _line.clear()
    if to_canvas_item == null:
        return
    _line.add_string(text, font, font_size)
    if transpose:
        _line.orientation = TextServer.ORIENTATION_VERTICAL
    _line.draw(to_canvas_item, rect.position + _get_offset_centered(), modulate)
