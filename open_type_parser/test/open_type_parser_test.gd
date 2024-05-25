extends OpenTypeParser

const TestFont: String = "res://open_type_parser/noto_sans/NotoSans.woff2"

enum Verbosity {None, FinalResult, CaseResult, CaseStep, Debug}

static var _st: float

static func test(verbosity_level: Verbosity = Verbosity.Debug) -> void:
    # Load data
    var data:PackedByteArray = FileAccess.get_file_as_bytes(TestFont)
    assert(!data.is_empty(), "font data is empty. file access error: %d" % FileAccess.get_open_error())
    
    # Test Font Headers
    assert(get_sfnt_version_tag(data) == 2001684018, "incorrect sfnt version tag")
    assert(get_sfnt_version_tag_name(data) == "custom_wOF2", "incorrect sfnt version tag name")
    assert(get_number_of_tables(data) == 1, "incorrect number of tables")
    assert(get_search_range(data) == 0, "incorrect search range")
    assert(get_entry_selector(data) == 15, "incorrect entry selector")
    assert(get_range_shift(data) == 65304, "incorrect range shift")
    
    var value = get_table_tag_name_list(data)
    print(value)
