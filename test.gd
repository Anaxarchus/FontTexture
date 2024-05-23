extends Control

@export
var font: Font

func _ready():
    var data := FileAccess.get_file_as_bytes(font.resource_path)
    print(OpenTypeParser.get_search_range(data))
    print(OpenTypeParser.get_range_shift(data))
    print(OpenTypeParser.get_entry_selector(data))
