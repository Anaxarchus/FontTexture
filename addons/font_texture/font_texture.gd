# ----------------------------------------------------------------------------
# FontTexture.gd
#
# This script allows generating Texture2D resources dynamically from fonts,
# particularly useful for icon fonts like Material Symbols.
#
# Documentation provided by: Google Gemini 2.5 Pro
# ----------------------------------------------------------------------------

@tool
class_name FontTexture2D extends Texture2D

## FontTexture
## Generates a dynamic Texture2D based on text rendered using a specified font.
## Primarily designed for using icon fonts like Material Symbols.
##
## @usage:
## 1. Create a new FontTexture resource in the Inspector.
## 2. Configure the properties (icon name in 'Text', size, color, padding, etc.).
## 3. Assign this resource to any property expecting a Texture2D (e.g., Sprite2D.texture, Button.icon).
##
## @see: Find Material Symbols icon names: https://mui.com/material-ui/material-icons/
## (Use the snake_case version of the name, e.g., "DoDisturb" -> "do_disturb").
## @see: Full list of Material Symbols codepoints: https://github.com/google/material-design-icons/blob/master/font/MaterialIcons-Regular.codepoints

#-----------------------------------------------------------------------------
# Exported Properties
#-----------------------------------------------------------------------------
## The text string or icon name to render. Defaults to "cookie".
## For Material Symbols, use the snake_case name (e.g., "settings", "check_circle").
@export var text: String = "cookie":
    set(value):
        if value != text:
            text = value
            _update_texture_properties()
            
@export_group("Font")
## The font resource used to render the text. Defaults to MaterialIcons-Regular.ttf.
@export var font: Font = ThemeDB.fallback_font:
    set(value):
        if value != font:
            font = value
            # Use fallback if the assigned font is invalid or null
            if font == null:
                font = ThemeDB.fallback_font
            _update_texture_properties()

## The color of the rendered text/icon. Defaults to white.
@export var font_color: Color = Color.WHITE:
    set(value):
        if value != font_color:
            font_color = value
            # Changing color only requires a redraw, not a resize.
            emit_changed()

## The size of the font in pixels. Defaults to 16. Must be at least 1.
@export var font_size: int = 16:
    set(value):
        # Ensure font size is positive
        var new_size := maxi(1, value)
        if new_size != font_size:
            font_size = new_size
            _update_texture_properties()

@export_group("Layout")
## Padding added around the text within the texture bounds (in pixels).
@export var padding: Vector2i = Vector2i.ZERO:
    set(value):
        # Ensure padding is non-negative
        var new_padding := Vector2i(max(0, value.x), max(0, value.y))
        if new_padding != padding:
            padding = new_padding
            _update_texture_properties()

## Justification flags for text rendering (controls alignment, wrapping - less relevant for single icons).
## Default: 163 = KASHIDA | WORD_BOUND | SKIP_LAST_LINE | DO_NOT_SKIP_SINGLE_LINE
@export_flags(
    "Kashida Justification:1",        # TextServer.JUSTIFICATION_KASHIDA
    "Word Justification:2",           # TextServer.JUSTIFICATION_WORD_BOUND
    #"Trim Edge Spaces:4",            # TextServer.JUSTIFICATION_TRIM_EDGE_SPACES (Often default)
    "Justify Only After Last Tab:8", # TextServer.JUSTIFICATION_JUSTIFY_ONLY_AFTER_LAST_TAB
    #"Constrain Ellipsis:16",         # TextServer.JUSTIFICATION_CONSTRAIN_ELLIPSIS
    "Skip Last Line:32",              # TextServer.JUSTIFICATION_SKIP_LAST_LINE
    "Skip Last Line With Visible Chars:64", # TextServer.JUSTIFICATION_SKIP_LAST_LINE_WITH_VISIBLE_CHARS
    "Do Not Skip Single Line:128"     # TextServer.JUSTIFICATION_DO_NOT_SKIP_SINGLE_LINE
)
var justification_flags: int = TextServer.JUSTIFICATION_KASHIDA | TextServer.JUSTIFICATION_WORD_BOUND | TextServer.JUSTIFICATION_SKIP_LAST_LINE | TextServer.JUSTIFICATION_DO_NOT_SKIP_SINGLE_LINE:
    set(value):
        if value != justification_flags:
            justification_flags = value
            _update_texture_properties()

#-----------------------------------------------------------------------------
# Internal State
#-----------------------------------------------------------------------------
var _line: TextLine = TextLine.new() ## TextLine object used for rendering.
var _text_size: Vector2 = Vector2.ZERO ## Cached size of the rendered text itself (without padding).

#-----------------------------------------------------------------------------
# Initialization
#-----------------------------------------------------------------------------
## Initializes the FontTexture resource.
## Sets up fallback fonts/sizes if needed and calculates initial size.
func _init() -> void:
    # Ensure default font and size are valid on initialization
    if font == null:
        font = ThemeDB.fallback_font
    if font_size <= 0:
        font_size = ThemeDB.fallback_font_size

    # Calculate initial size based on defaults or inspector-set values
    _update_calculated_size()


#-----------------------------------------------------------------------------
# Private Methods
#-----------------------------------------------------------------------------
## Recalculates the internal text size based on current properties (font, font_size, text, flags).
func _update_calculated_size() -> void:
    if font != null and font_size > 0 and not text.is_empty():
        # Calculate the size needed for the string with current settings.
        # Using HORIZONTAL_ALIGNMENT_CENTER here primarily affects multi-line text wrapping width,
        # single icons/lines aren't significantly impacted by alignment during size calculation.
        # Actual drawing position is centered via _get_offset_centered().
        _text_size = font.get_string_size(text, HORIZONTAL_ALIGNMENT_CENTER, -1, font_size, justification_flags)
    else:
        # Handle cases where font is invalid or text is empty
        _text_size = Vector2.ZERO

## Updates texture properties (recalculates size) and notifies Godot that the texture has changed,
## triggering redraws and updates in nodes using this texture.
func _update_texture_properties() -> void:
    _update_calculated_size()
    # Emit changed to trigger updates to _get_width, _get_height and signal redraw needed.
    emit_changed()

## Calculates the drawing offset required to center the text block within the texture area,
## accounting for font metrics (descent) and user-defined padding.
## @returns Vector2: The offset from the top-left corner (rect.position) to start drawing the TextLine.
func _get_offset_centered() -> Vector2:
    var offset_y: float = 0.0
    if font != null and font_size > 0:
         # Basic vertical centering attempt using descent.
         # A more precise method might involve (ascent - descent) / 2 relative to the line height.
         # This simpler approach often looks visually acceptable for single lines/icons.
        offset_y = font.get_descent(font_size) * 0.5

    # Add half the padding to center the text within the padded area.
    # This offset is added to rect.position in _draw_rect.
    return Vector2(padding.x * 0.5, offset_y + padding.y * 0.5)


#-----------------------------------------------------------------------------
# Texture2D Overrides
#-----------------------------------------------------------------------------
## Returns the total width of the texture (calculated text width + horizontal padding).
## @override Texture2D._get_width()
## @returns int: The texture width in pixels.
func _get_width() -> int:
    # Use ceil to ensure the texture dimensions are large enough for the float size.
    return int(ceil(_text_size.x + padding.x))

## Returns the total height of the texture (calculated text height + vertical padding).
## @override Texture2D._get_height()
## @returns int: The texture height in pixels.
func _get_height() -> int:
    # Use ceil to ensure the texture dimensions are large enough for the float size.
    return int(ceil(_text_size.y + padding.y))

## Draws the configured text onto a CanvasItem when the engine requests the texture content.
## @override Texture2D._draw_rect()
## @param to_canvas_item RID: The canvas item RID to draw onto.
## @param rect Rect2: The destination rectangle on the canvas item.
## @param tile bool: Whether the texture is being tiled (unused here).
## @param modulate Color: A color to multiply/blend with the font_color.
## @param transpose bool: If true, draw the text vertically (rotated 90 degrees).
func _draw_rect(to_canvas_item: RID, rect: Rect2, tile: bool, modulate: Color, transpose: bool = false) -> void:
    # Pre-draw checks for validity
    if font == null or font_size <= 0 or text.is_empty():
        # Note: Error messages were previously added but commented out to reduce console spam
        # in case of frequent invalid states during editing. Consider re-enabling if needed for debugging.
        # printerr("FontTexture: Cannot draw - Font, Font Size, or Text is invalid/empty.")
        return

    # Prepare the TextLine object for drawing
    _line.clear()
    var add_string_success: bool = _line.add_string(text, font, font_size)

    if not add_string_success:
        # printerr("FontTexture: Failed to add string '%s' with font '%s'. Check font support for characters." % [text, font.resource_path if font else "null"])
        return # Stop drawing if the string couldn't be prepared

    # Set orientation based on transpose flag
    # EXPERIMENTAL: This may produce unfavorable results.
    _line.orientation = TextServer.ORIENTATION_VERTICAL if transpose else TextServer.ORIENTATION_HORIZONTAL

    # Calculate the final drawing position: top-left of rect + centering offset
    var draw_position: Vector2 = rect.position + _get_offset_centered()

    # Perform the draw call using the TextLine
    _line.draw(to_canvas_item, draw_position, font_color)
