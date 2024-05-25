extends Control

@export_file("*.woff2", "*.ttf")
var font: String

func _ready():
    var test := OpenTypeParser.get_unit_tests()
    test.test(true)
