class_name OpenTypeResources extends RefCounted


static func get_table(table_schema: Array[Dictionary], bytes: PackedByteArray, offset: int, functions: Object = Functions.new()) -> Dictionary:
    var res: Dictionary
    for row in table_schema:
        if row.has("usage"):
            assert(row.usage is Array, "error, usage is not array")
            res[row.property] = functions.callv(row.usage[0], row.usage.slice(1) + [res, bytes, offset])
        elif row.type > TYPE_MAX:
            res[row.property] = OpenTypeData.get_value(row.type, bytes, offset)
            offset = OpenTypeData.increment(row.type, offset)
    return res

# This work around feels weird, but I don't currently have a better idea. Possibly a more appropriate solution
# is to implement some form of reflection, and allow references to be made on the result object which will be created
# in order to describe the number of iterations. I imagine this will become clearer as I get deeper into the specific tables
# and can see how dynamic these list parameters get.
class Functions extends RefCounted:
    func _get_table_array(schema: Array[Dictionary], table_directory: Dictionary, bytes:PackedByteArray, offset:int) -> Variant:
        var res: Array[Dictionary]
        for x in table_directory.get("numTables", 0):
            res.append(OpenTypeResources.get_table(schema, bytes, offset))
            offset += 16
        if schema.any(func(prop): return prop.property == "tableTag"):
            var dict: Dictionary
            for table in res:
                dict[table.tableTag] = table
            return dict
        return res
