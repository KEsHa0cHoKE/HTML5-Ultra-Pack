function struct_get_from_file(_fileName)
{
	var _buff = buffer_load(_fileName);
	var _json = buffer_read(_buff, buffer_text);
	buffer_delete(_buff);
	var _struct = json_parse(_json);
	
	return _struct
}

function struct_save_to_file(_struct, _fileName)
{
	var _json = json_stringify(_struct);

	var _buff = buffer_create(string_byte_length(_json), buffer_fixed, 1);
	buffer_write(_buff, buffer_text, _json);
	buffer_save(_buff, _fileName);
	buffer_delete(_buff);
}