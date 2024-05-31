class_name OpenTypeData extends RefCounted

const uInt8             : int = TYPE_MAX + 1
const Int8              : int = TYPE_MAX + 2
const uInt16            : int = TYPE_MAX + 3
const Int16             : int = TYPE_MAX + 4
const uInt24            : int = TYPE_MAX + 5
const Int24             : int = TYPE_MAX + 6
const uInt32            : int = TYPE_MAX + 7
const Int32             : int = TYPE_MAX + 8
const Fixed             : int = TYPE_MAX + 9
const Fword             : int = TYPE_MAX + 10
const uFword            : int = TYPE_MAX + 11
const F2Dot14           : int = TYPE_MAX + 12
const LongDateTime      : int = TYPE_MAX + 13
const Tag               : int = TYPE_MAX + 14
const Offset16          : int = TYPE_MAX + 15
const Offset24          : int = TYPE_MAX + 16
const Offset32          : int = TYPE_MAX + 17
const Version16Dot16    : int = TYPE_MAX + 18

## Helper method to route get requests based on data type
static func get_value(data_type: int, bytes: PackedByteArray, offset: int) -> Variant:
    match data_type:
        uInt8:
            return get_uint8(bytes, offset)
        Int8:
            return get_int8(bytes, offset)
        uInt16:
            return get_uint16(bytes, offset)
        Int16:
            return get_int16(bytes, offset)
        uInt24:
            return get_uint24(bytes, offset)
        Int24:
            return get_int24(bytes, offset)
        uInt32:
            return get_uint32(bytes, offset)
        Int32:
            return get_int32(bytes, offset)
        Fixed:
            return get_fixed(bytes, offset)
        Fword:
            return get_fword(bytes, offset)
        uFword:
            return get_ufword(bytes, offset)
        F2Dot14:
            return get_f2dot14(bytes, offset)
        LongDateTime:
            return get_longdatetime(bytes, offset)
        Tag:
            return get_tag(bytes, offset)
        Offset16:
            return get_offset16(bytes, offset)
        Offset24:
            return get_offset24(bytes, offset)
        Offset32:
            return get_offset32(bytes, offset)
        Version16Dot16:
            return get_version16dot16(bytes, offset)
    return null

## Helper method to increment the offset counter based on a given data type
static func increment(data_type: int, offset: int) -> int:
    match data_type:
        uInt8, Int8:
            return offset + 1
        uInt16, Int16, Fword, uFword, F2Dot14, Offset16:
            return offset + 2
        uInt24, Int24, Offset24:
            return offset + 3
        uInt32, Int32, Fixed, Tag, Offset32, Version16Dot16:
            return offset + 4
        LongDateTime:
            return offset + 8
    return offset

## Returns the nearest four-byte boundary for the given offset.
static func get_boundary_position(offset: int) -> int:
    if offset % 4 == 0:
        return offset
    return offset + (4 - (offset % 4))

## 8-bit unsigned integer.
static func get_uint8(bytes: PackedByteArray, offset: int) -> int:
    return _big_endian(bytes.slice(offset, offset + 1))

## 8-bit signed integer.
static func get_int8(bytes: PackedByteArray, offset: int) -> int:
    return _big_endian(bytes.slice(offset, offset + 1), true)

## 16-bit unsigned integer.
static func get_uint16(bytes: PackedByteArray, offset: int) -> int:
    return _big_endian(bytes.slice(offset, offset + 2))

## 16-bit signed integer.
static func get_int16(bytes: PackedByteArray, offset: int) -> int:
    return _big_endian(bytes.slice(offset, offset + 2), true)

## 24-bit unsigned integer.
static func get_uint24(bytes: PackedByteArray, offset: int) -> int:
    return _big_endian(bytes.slice(offset, offset + 3))

## 24-bit signed integer.
static func get_int24(bytes: PackedByteArray, offset: int) -> int:
    return _big_endian(bytes.slice(offset, offset + 3), true)

## 32-bit unsigned integer.
static func get_uint32(bytes: PackedByteArray, offset: int) -> int:
    return _big_endian(bytes.slice(offset, offset + 4))

## 32-bit signed integer.
static func get_int32(bytes: PackedByteArray, offset: int) -> int:
    return _big_endian(bytes.slice(offset, offset + 4), true)

## 32-bit signed fixed-point number (16.16)
static func get_fixed(bytes: PackedByteArray, offset: int) -> float:
    var fixed_point_value: int = _big_endian(bytes.slice(offset, offset + 4), true)
    var integer_part: int = fixed_point_value >> 16
    var fractional_part: float = (fixed_point_value & 0xFFFF) / float(1 << 16)

    # Combine integer and fractional parts
    return integer_part + fractional_part

## int16 that describes a quantity in font design units.
static func get_fword(bytes: PackedByteArray, offset: int) -> int:
    return get_int16(bytes, offset + 2)

## int16 that describes a quantity in font design units.
static func get_ufword(bytes: PackedByteArray, offset: int) -> int:
    return get_int16(bytes, offset + 2)

## 16-bit signed fixed number with the low 14 bits of fraction (2.14).
static func get_f2dot14(bytes: PackedByteArray, offset: int) -> float:
    var fixed_point_value: int = _big_endian(bytes.slice(offset, offset + 2), true)

    # Extract integer part (first 2 bits)
    var integer_part: int = fixed_point_value >> 14

    # Extract fractional part (last 14 bits)
    var fractional_part: float = (fixed_point_value & 0x3FFF) / float(1 << 14)

    # Combine integer and fractional parts
    var result: float = integer_part + fractional_part

    # Adjust for signedness
    if integer_part & 0x02 != 0:
        result -= 4.0

    return result

##  Date and time represented in number of seconds since 12:00 midnight, January 1, 1904, UTC. The value is represented as a signed 64-bit integer.
static func get_longdatetime(bytes: PackedByteArray, offset: int) -> Dictionary:
    var seconds_since_1904: int = _big_endian(bytes.slice(offset, offset + 8), true)

    # Base date: January 1, 1904
    var base_date_unix: int = -2082844800  # Unix timestamp for January 1, 1904

    # Calculate the Unix timestamp for the target date
    var target_unix_timestamp: int = base_date_unix + seconds_since_1904

    # Use Time singleton to convert Unix timestamp to a human-readable format
    var datetime_dict: Dictionary = Time.get_datetime_dict_from_unix_time(target_unix_timestamp)

    return datetime_dict

## Array of four uint8s (length = 32 bits) used to identify a table, design-variation axis, script, language system, feature, or baseline.
static func get_tag(bytes: PackedByteArray, offset: int) -> String:
    var tag_bytes: PackedByteArray = bytes.slice(offset, offset + 4)
    var tag_string: String = ""
    for i in range(4):
        tag_string += String.chr(tag_bytes[i])
    return tag_string

## Short offset to a table, same as uint16, NULL offset = 0x0000.
static func get_offset16(bytes: PackedByteArray, offset: int) -> int:
    return get_uint16(bytes, offset)

## 24-bit offset to a table, same as uint24, NULL offset = 0x000000.
static func get_offset24(bytes: PackedByteArray, offset: int) -> int:
    return get_uint24(bytes, offset)

## Long offset to a table, same as uint32, NULL offset = 0x00000000.
static func get_offset32(bytes: PackedByteArray, offset: int) -> int:
    return get_uint32(bytes, offset)

## Packed 32-bit value with major and minor version numbers.
static func get_version16dot16(bytes: PackedByteArray, offset: int) -> String:
    var version_value: int = _big_endian(bytes.slice(offset, offset + 4), false)

    var major_version: int = version_value >> 16
    var minor_version: int = version_value & 0xFFFF

    var version_string: String = "%d.%d" %major_version %minor_version
    return version_string

static func _big_endian(byte_array: PackedByteArray, is_signed: bool = false) -> int:
    var result: int = 0
    var length: int = byte_array.size()
    for i in range(length):
        result += byte_array[i] << (8 * (length - 1 - i))

    # Check for signed integer and adjust the result if necessary
    if is_signed and length > 0 and (byte_array[0] & 0x80) != 0:
        result -= 1 << (length * 8)

    return result
