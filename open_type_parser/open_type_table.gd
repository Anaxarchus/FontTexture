class_name OpenTypeTable extends RefCounted

var data: PackedByteArray
var offset: int

func _init(table_data: PackedByteArray, absolute_offset: int):
    data = table_data
    offset = absolute_offset

func get_major_version(big_endian: bool = true) -> int:
    return OpenTypeParser.to_int(data.slice(0, 2), big_endian)

func get_minor_version(big_endian: bool = true) -> int:
    return OpenTypeParser.to_int(data.slice(2, 4), big_endian)


static func from_tag_name(tag_name:String, table_data:PackedByteArray, absolute_offset:int) -> OpenTypeTable:
    match tag_name:
        "GSUB", "GPOS":
            return G.new(table_data, absolute_offset)
        _:
            return OpenTypeTable.new(table_data, absolute_offset)


class G:
    extends OpenTypeTable

    func get_script_list_offset(big_endian:bool = true) -> int:
        return OpenTypeParser.to_int(data.slice(4, 6), big_endian)

    func get_feature_list_offset(big_endian:bool = true) -> int:
        return OpenTypeParser.to_int(data.slice(6, 8), big_endian)

    func get_lookup_list_offset(big_endian:bool = true) -> int:
        return OpenTypeParser.to_int(data.slice(8, 10), big_endian)

    func get_feature_variations_offset(big_endian:bool = true) -> int:
        if get_minor_version(big_endian) == 1:
            return OpenTypeParser.to_int(data.slice(10, 14), big_endian)
        else:
            return -1
