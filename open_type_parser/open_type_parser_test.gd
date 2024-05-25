extends OpenTypeParser

const TestFont: String = "res://open_type_parser/noto_sans/NotoSans-VariableFont_wdth,wght.ttf"

static var _st: float

static func test(verbose: bool = false) -> void:
    # Load data
    var data:PackedByteArray = FileAccess.get_file_as_bytes(TestFont)
    assert(!data.is_empty(), "font data is empty. file access error: %d" % FileAccess.get_open_error())
    
    # Test Font Headers
    if verbose:
        print("version tag: ", get_sfnt_version_tag(data))
    assert(get_sfnt_version_tag(data) == "00010000", "incorrect sfnt version tag")
    
    if verbose:
        print("uses tto: ", get_uses_tto(data))
    assert(get_uses_tto(data) == true, "failed to detect true type outlines")
    
    if verbose:
        print("uses cff: ", get_uses_cff(data))
    assert(get_uses_cff(data) == false, "failed to detect cubic Bézier curves")
    
    if verbose:
        print("number of tables: ", get_number_of_tables(data))
    assert(get_number_of_tables(data) == 21, "incorrect number of tables")
    
    if verbose:
        print("search range: ", get_search_range(data))
    assert(get_search_range(data) == 256, "incorrect search range")
    
    if verbose:
        print("entry selector: ", get_entry_selector(data))
    assert(get_entry_selector(data) == 4, "incorrect entry selector")
    
    if verbose:
        print("range shift: ", get_range_shift(data))
    assert(get_range_shift(data) == 80, "incorrect range shift")
    
    var name_list: PackedStringArray = ["custom_GDEF", "custom_GPOS", "custom_GSUB", "custom_HVAR", "custom_MVAR", "custom_OS/2", "custom_STAT", "custom_avar", "custom_cmap", "custom_fvar", "custom_gasp", "custom_glyf", "custom_gvar", "custom_head", "custom_hhea", "custom_hmtx", "custom_loca", "custom_maxp", "custom_name", "custom_post", "custom_prep"]
    assert(get_table_tag_name_list(data) == name_list, "incorrect tag name list")
    
    if verbose:
        print("\ntable tag: ", table_get_tag(data, 2))
    assert(table_get_tag(data, 2) == 1196643650)
    
    if verbose:
        print("table tag name: ", table_get_tag_name(data, 2))
    assert(table_get_tag_name(data, 2) == "custom_GSUB")
    
    if verbose:
        print("table checksum: ", table_get_checksum(data, 2))
    assert(table_get_checksum(data, 2) == 2041505776)
    
    if verbose:
        print("table offset: ", table_get_offset(data, 2))
    assert(table_get_offset(data, 2) == 109700)
    
    if verbose:
        print("table length: ", table_get_length(data, 2))
    assert(table_get_length(data, 2) == 42950)
    
    if verbose:
        print("table major version: ", table_get_major_version(data, 2))
    assert(table_get_major_version(data, 2) == 1)
    
    if verbose:
        print("table minor version: ", table_get_minor_version(data, 2))
    assert(table_get_minor_version(data, 2) == 0)
    
    if verbose:
        print("table script list offset: ", table_get_script_list_offset(data, 2))
    assert(table_get_script_list_offset(data, 2) == 10)
    
    if verbose:
        print("table feature list offset: ", table_get_feature_list_offset(data, 2))
    assert(table_get_feature_list_offset(data, 2) == 1472)
    
    if verbose:
        print("table lookup list offset: ", table_get_lookup_list_offset(data, 2))
    assert(table_get_lookup_list_offset(data, 2) == 2240)
    
    if verbose:
        print("table get feature variations offset: ", table_get_feature_variations_offset(data, 2))
    assert(table_get_feature_variations_offset(data, 2) == -1)
    
    if verbose:
        print("\nfeature tag list: ", feature_get_tag_list(data, 1472))
    assert(feature_get_tag_list(data, 1472) == PackedStringArray(["custom_GDEF"]))
    
    if verbose:
        print("feature list count: ", feature_list_get_count(data, 1472))
    assert(feature_list_get_count(data, 1472) == 1)
    
    if verbose:
        print("feature tag: ", feature_get_tag(data, 1472, 0))
    assert(feature_get_tag(data, 1472, 0) == 21)
    
    if verbose:
        print("feature tag name: ", feature_get_tag_name(data, 1472, 0))
    assert(feature_get_tag_name(data, 1472, 0) == "00000015")
    
    if verbose:
        print("feature offset: ", feature_get_offset(data, 1472, 0))
    assert(feature_get_offset(data, 1472, 0) == 256)
