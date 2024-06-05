@tool
class_name FontTexture extends Texture2D

@export
var font: Font :
    set(value):
        if value != font:
            font = value
            _string_size = font.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size)
            font.changed.connect(emit_changed)
            emit_changed()

var _font: FontFile :
    get:
        if font is FontFile:
            return font
        elif font is FontVariation:
            return font.base_font
        return _font

@export
var font_color: Color :
    set(value):
        if value != font_color:
            font_color = value
            emit_changed()

@export
var font_size: int = 24.0 :
    set(value):
        if value != font_size:
            font_size = value
            emit_changed()

@export
var text: String :
    set(value):
        if value != text:
            text = value
            _string_size = _font.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size)
            emit_changed()

var _string_size: Vector2
var _font_size: int :
    set(value):
        if value != _font_size:
            _font_size = value

func _draw_rect(to_canvas_item: RID, rect: Rect2, tile: bool, modulate: Color, transpose: bool) -> void:
    if _font != null and !text.is_empty():
        if tile:
            var txt: String
            for y in floor(rect.size.y/_string_size.y):
                for x in floor(rect.size.x/_string_size.x):
                    txt += text
                txt += "\n"
            var line := TextParagraph.new()
            line.add_string(txt, font, font_size)

            var position: Vector2 = rect.position
            line.draw(to_canvas_item, position, modulate.blend(font_color))
        else:
            var line := TextLine.new()
            _font_size = clampi(snappedi(mini(rect.size.y, rect.size.x), 8.0), font_size, 2000)
            line.add_string(text, font, _font_size)
            var line_size = line.get_size()

            var position: Vector2 = rect.position
            position -= line_size - rect.size
            line.draw(to_canvas_item, position, modulate.blend(font_color))

func _get_height() -> int:
    return _string_size.y

func _get_width() -> int:
    return _string_size.x
