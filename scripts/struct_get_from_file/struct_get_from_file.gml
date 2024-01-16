function struct_get_from_file(_fileName)
{
	var _buff = buffer_load(_fileName);
	var _json = buffer_read(_buff, buffer_text);
	buffer_delete(_buff);
	var _struct = json_parse(_json);
	
	return _struct
}