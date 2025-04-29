# FontTexture2D Class

There are several addons in the AssetLib at this point offering custom controls which display fonts as icons. They are all fine choices for rendering icon fonts, many of them even come with helpful icon picker widgets, but none of the ones I tested included an actual Texture2D, which is what I needed. So here is my `FontTexture2D`. It's quite simple, all it does is use a `TextLine` or `TextParagraph` to draw `text` to the canvas using the texture.

## Usage

### Properties

- `font: Font`
  - The font to be used for rendering the text. For icons, FontVariation is recommended in order to access the variations.

- `font_color: Color`
  - The color of the rendered text. Changing this property will update the texture.

- `font_size: int`
  - The size of the font. This is more of a minimum font size as it will be largely ignored depending on your `expand_mode` and `stretch_mode`.

- `text: String`
  - The text to be rendered. Changing this property will update the texture with the new text.


### Example

```gdscript
extends Control

@onready var font_texture: FontTexture = FontTexture.new()

func _ready():
    font_texture.font = load("res://path_to_your_font_file.tres")
    font_texture.font_color = Color(1, 1, 1)  # White color
    font_texture.font_size = 24
    font_texture.text = "Hello, World!"

    var texture_rect = TextureRect.new()
    texture_rect.texture = font_texture
    texture_rect.rect_min_size = Vector2(200, 50)
    add_child(texture_rect)
```
