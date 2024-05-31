class_name OpenTypeSchemas extends RefCounted


const TableDirectory: Array[Dictionary] = [
    {"property":"sfntVersion", "type":OpenTypeData.uInt32},
    {"property":"numTables", "type":OpenTypeData.uInt16},
    {"property":"searchRange", "type":OpenTypeData.uInt16},
    {"property":"entrySelector", "type":OpenTypeData.uInt16},
    {"property":"rangeShift", "type":OpenTypeData.uInt16},
    {"property":"tableRecord", "type":TYPE_ARRAY, "usage":[&"_get_table_array", TableRecord]}
    ]

const TableRecord: Array[Dictionary] = [
    {"property":"tableTag", "type":OpenTypeData.Tag},
    {"property":"checksum", "type":OpenTypeData.uInt32},
    {"property":"offset", "type":OpenTypeData.Offset32},
    {"property":"length", "type":OpenTypeData.uInt32},
]

const TableCMAP: Array[Dictionary] = [
    {"property":"version", "type":OpenTypeData.uInt16},
    {"property":"numTables", "type":OpenTypeData.uInt16},
    {"property":"encodingRecords", "type":TYPE_ARRAY, "usage":[&"_get_table_array", EncodingRecord]},
]

const EncodingRecord: Array[Dictionary] = [
    {"property": "platformID", "type": OpenTypeData.uInt16},
    {"property": "encodingID", "type": OpenTypeData.uInt16},
    {"property": "subtableOffset", "type": OpenTypeData.Offset32},
]

const TableHEAD: Array[Dictionary] = [
    {}
]

const TableHHEA: Array[Dictionary] = [
    {}
]

const TableHMTX: Array[Dictionary] = [
    {}
]

const TableMAXP: Array[Dictionary] = [
    {}
]

const TableNAME: Array[Dictionary] = [
    {}
]

const TableOS2: Array[Dictionary] = [
    {}
]

const TablePOST: Array[Dictionary] = [
    {}
]

const TableGSUB: Array[Dictionary] = [
    {}
]
