class_name OpenTypeTable extends RefCounted

var position: int
var size: int
var data: PackedByteArray


## 8-bit unsigned integer.
static func get_uint8(bytes: PackedByteArray, offset: int):
    pass

## 8-bit signed integer.
static func get_int8(bytes: PackedByteArray, offset: int):
    pass

## 16-bit unsigned integer.
static func get_uint16(bytes: PackedByteArray, offset: int):
    pass

## 16-bit signed integer.
static func get_int16(bytes: PackedByteArray, offset: int):
    pass

## 24-bit unsigned integer.
static func get_uint24(bytes: PackedByteArray, offset: int):
    pass

## 24-bit signed integer.
static func get_int24(bytes: PackedByteArray, offset: int):
    pass

## 32-bit unsigned integer.
static func get_uint32(bytes: PackedByteArray, offset: int):
    pass

## 32-bit signed integer.
static func get_int32(bytes: PackedByteArray, offset: int):
    pass

## 32-bit signed fixed-point number (16.16)
static func get_fixed(bytes: PackedByteArray, offset: int):
    pass

## int16 that describes a quantity in font design units.
static func get_fword(bytes: PackedByteArray, offset: int):
    pass

## int16 that describes a quantity in font design units.
static func get_ufword(bytes: PackedByteArray, offset: int):
    pass

## 16-bit signed fixed number with the low 14 bits of fraction (2.14).
static func get_f2dot14(bytes: PackedByteArray, offset: int):
    pass

##  Date and time represented in number of seconds since 12:00 midnight, January 1, 1904, UTC. The value is represented as a signed 64-bit integer.
static func get_longdatetime(bytes: PackedByteArray, offset: int):
    pass

## Array of four uint8s (length = 32 bits) used to identify a table, design-variation axis, script, language system, feature, or baseline.
static func get_tag(bytes: PackedByteArray, offset: int):
    pass

## Short offset to a table, same as uint16, NULL offset = 0x0000.
static func get_offset16(bytes: PackedByteArray, offset: int):
    pass

## 24-bit offset to a table, same as uint24, NULL offset = 0x000000.
static func get_offset24(bytes: PackedByteArray, offset: int):
    pass

## Long offset to a table, same as uint32, NULL offset = 0x00000000.
static func get_offset32(bytes: PackedByteArray, offset: int):
    pass

## Packed 32-bit value with major and minor version numbers.
static func get_version16dot16(bytes: PackedByteArray, offset: int):
    pass
