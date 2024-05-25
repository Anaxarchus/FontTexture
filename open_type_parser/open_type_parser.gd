class_name OpenTypeParser extends RefCounted

const UnitTests := preload("res://open_type_parser/open_type_parser_test.gd")

static func get_sfnt_version_tag(data: PackedByteArray, big_endian:bool = true) -> String:
    return data.slice(0, 4).hex_encode()

static func get_uses_tto(data: PackedByteArray, big_endian:bool = true) -> bool:
    return get_sfnt_version_tag(data, big_endian) == "00010000"

static func get_uses_cff(data: PackedByteArray, big_endian:bool = true) -> bool:
    return get_sfnt_version_tag(data, big_endian) == "4F54544F"

static func get_number_of_tables(data: PackedByteArray, big_endian:bool = true) -> int:
    return to_int(data.slice(4, 6), big_endian)

static func get_search_range(data: PackedByteArray, big_endian:bool = true) -> int:
    return to_int(data.slice(6, 8), big_endian)

static func get_entry_selector(data: PackedByteArray, big_endian:bool = true) -> int:
    return to_int(data.slice(8, 10), big_endian)

static func get_range_shift(data: PackedByteArray, big_endian:bool = true) -> int:
    return to_int(data.slice(10, 12), big_endian)

static func get_table_tag_name_list(data: PackedByteArray, big_endian: bool = true) -> PackedStringArray:
    var res:PackedStringArray
    for i in get_number_of_tables(data, big_endian):
        res.append(table_get_tag_name(data, i, big_endian))
    return res



#region Table Getters
static func table_get_tag(data: PackedByteArray, table_idx:int, big_endian: bool = true) -> int:
    if !_table_idx_in_bounds(data, table_idx, big_endian):
        return -1
    return to_int(data.slice(12 + table_idx*16, 16 + table_idx*16))

static func table_get_tag_name(data: PackedByteArray, table_idx:int, big_endian: bool = true) -> String:
    if !_table_idx_in_bounds(data, table_idx, big_endian):
        return ""
    return TextServerManager.get_primary_interface().tag_to_name(table_get_tag(data, table_idx, big_endian))

static func table_get_checksum(data: PackedByteArray, table_idx:int, big_endian:bool = true) -> int:
    if !_table_idx_in_bounds(data, table_idx, big_endian):
        return -1
    return to_int(data.slice(16 + table_idx*16, 20 + table_idx*16), big_endian)

static func table_get_offset(data: PackedByteArray, table_idx:int, big_endian:bool = true) -> int:
    if !_table_idx_in_bounds(data, table_idx, big_endian):
        return -1
    return to_int(data.slice(20 + table_idx*16, 24 + table_idx*16), big_endian)

static func table_get_length(data: PackedByteArray, table_idx:int, big_endian:bool = true) -> int:
    if !_table_idx_in_bounds(data, table_idx, big_endian):
        return -1
    return to_int(data.slice(24 + table_idx*16, 28 + table_idx*16), big_endian)

static func table_get_major_version(data: PackedByteArray, table_idx:int, big_endian:bool = true) -> int:
    var offset := table_get_offset(data, table_idx, big_endian)
    return to_int(data.slice(offset, offset + 2), big_endian)

static func table_get_minor_version(data: PackedByteArray, table_idx:int, big_endian:bool = true) -> int:
    var offset := table_get_offset(data, table_idx, big_endian)
    return to_int(data.slice(offset + 2, offset + 4), big_endian)

static func table_get_script_list_offset(data: PackedByteArray, table_idx:int, big_endian:bool = true) -> int:
    var offset := table_get_offset(data, table_idx, big_endian)
    return to_int(data.slice(offset + 4, offset + 6), big_endian)

static func table_get_feature_list_offset(data: PackedByteArray, table_idx:int, big_endian:bool = true) -> int:
    var offset := table_get_offset(data, table_idx, big_endian)
    return to_int(data.slice(offset + 6, offset + 8), big_endian)

static func table_get_lookup_list_offset(data: PackedByteArray, table_idx:int, big_endian:bool = true) -> int:
    var offset := table_get_offset(data, table_idx, big_endian)
    return to_int(data.slice(offset + 8, offset + 10), big_endian)

static func table_get_feature_variations_offset(data: PackedByteArray, table_idx:int, big_endian:bool = true) -> int:
    var offset := table_get_offset(data, table_idx, big_endian)
    if table_get_minor_version(data, table_idx, big_endian) == 1:
        return to_int(data.slice(offset + 10, offset + 14), big_endian)
    return -1

static func _table_idx_in_bounds(data: PackedByteArray, table_idx:int, big_endian:bool = true) -> bool:
    if table_idx < 0 || table_idx > get_number_of_tables(data, big_endian):
        push_error("Error: table_idx is out of bounds.")
        return false
    return true
#endregion


static func lookup_get_substr_format():
    pass



#region Feature Getters
static func feature_get_tag_list(data: PackedByteArray, offset:int, big_endian:bool = true) -> PackedStringArray:
    var res:PackedStringArray
    for i in feature_list_get_count(data, offset, big_endian):
        res.append(table_get_tag_name(data, i, big_endian))
    return res

static func feature_list_get_count(data: PackedByteArray, offset:int, big_endian:bool = true) -> int:
    return to_int(data.slice(offset, offset+2), big_endian)

static func feature_get_tag(data: PackedByteArray, offset:int, feature_idx:int, big_endian:bool = true) -> int:
    if !_feature_list_idx_in_bounds(data, offset, feature_idx, big_endian):
        return -1
    return to_int(data.slice(2 + feature_idx*6, 6 + feature_idx*6))

static func feature_get_tag_name(data: PackedByteArray, offset:int, feature_idx:int, big_endian:bool = true) -> String:
    if !_feature_list_idx_in_bounds(data, offset, feature_idx, big_endian):
        return "00000000"
    return data.slice(2 + feature_idx*6, 6 + feature_idx*6).hex_encode()

static func feature_get_offset(data: PackedByteArray, offset:int, feature_idx:int, big_endian:bool = true) -> int:
    if !_feature_list_idx_in_bounds(data, offset, feature_idx, big_endian):
        return -1
    return to_int(data.slice(6 + feature_idx*6, 8 + feature_idx*6))

static func get_feature_list(data: PackedByteArray):
    pass

static func _feature_list_idx_in_bounds(data: PackedByteArray, offset:int, feature_idx:int, big_endian:bool = true) -> bool:
    if feature_idx < 0 || feature_idx > feature_list_get_count(data, offset, big_endian):
        push_error("Error: feature_idx is out of bounds.")
        return false
    return true
#endregion



static func to_int(byte_array: PackedByteArray, big_endian:bool = true) -> int:
    if big_endian:
        return to_big_endian(byte_array)
    else:
        return to_little_endian(byte_array)

static func to_little_endian(byte_array: PackedByteArray) -> int:
    var result: int = 0
    var length: int = byte_array.size()
    for i in range(length):
        result += byte_array[i] << (8 * i)

    return result

static func to_big_endian(byte_array: PackedByteArray) -> int:
    var result: int = 0
    var length: int = byte_array.size()
    for i in range(length):
        result += byte_array[i] << (8 * (length - 1 - i))

    return result


static func get_unit_tests() -> OpenTypeParser:
    return UnitTests.new()
