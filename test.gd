extends Control

@export_file("*.woff2", "*.ttf")
var font: String

func _ready():
    var data := FileAccess.get_file_as_bytes(font)
    if !data.is_empty():
        var table := OpenTypeResources.get_table(OpenTypeSchemas.TableDirectory, data, 0)
        print("table: ", table.tableRecord.keys())
        if "cmap" in table.tableRecord:
            var cmap := OpenTypeResources.get_table(OpenTypeSchemas.TableCMAP, data, table.tableRecord.cmap.offset)
            print("cmap: ", cmap)
