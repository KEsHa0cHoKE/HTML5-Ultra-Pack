#define wdt_load_texture_group
/// (texturegroup_name)->
if (global.__wdt_native) return wdt_status_ready;
var _name = argument0;
var _pairs = wdt_get_texture_group_image_pairs(_name);
var _found = 0;
var n = array_length(_pairs);
for (var i = 0; i < n; i++) {
	var _pair = _pairs[i];
	if (wdt_load_texture(_pair[1])) _found += 1;
}
return _found;

#define wdt_get_texture_group_status
/// (texturegroup_name)->
if (global.__wdt_native) return wdt_status_ready;
var _name = argument0;
var _pairs = wdt_get_texture_group_image_pairs(_name);
var _found = 0;
var n = array_length(_pairs);
var _min = wdt_status_ready;
for (var i = 0; i < n; i++) {
	var _pair = _pairs[i];
	var _status = global.__wdt_status[?_pair[0]];
	if (_status == undefined) {
		_status = wdt_status_fallback;
	} else if (_status == wdt_status_error) return _status;
	_min = min(_min, _status);
}
return _min;

#define wdt_get_texture_group_image_pairs
/// (name)->array<[string,texture]>
var _name = argument0;
var _pairs = global.__wdt_texture_group_image_pairs[?_name];
if (_pairs != undefined) return _pairs;
_pairs = [];
var _autoload = wdt_autoload_enable(false);

var _found = global.__wdt_texture_group_temp;
var _pair/*:[string,texture]*/;
ds_map_clear(_found);

var _sprites = texturegroup_get_sprites(_name);
for (var i = 0, n = array_length(_sprites); i < n; i++) {
	var _sprite = _sprites[i];
	var _number = wdt_get_sprite_texture_number(_sprite);
	for (var k = 0; k < _number; k++) {
		var _tex = sprite_get_texture(_sprite, k);
		var _path = wdt_get_image_path(_tex);
		if (_path != undefined && !ds_map_exists(_found, _path)) {
			_found[?_path] = true;
			_pair = [_path, _tex];
			array_push(_pairs, _pair);
		}
	}
}

var _fonts = texturegroup_get_fonts(_name);
for (var i = 0, n = array_length(_fonts); i < n; i++) {
	var _font = _fonts[i];
	var _tex = font_get_texture(_font);
	var _path = wdt_get_image_path(_tex);
	if (_path != undefined && !ds_map_exists(_found, _path)) {
		_found[?_path] = true;
		_pair = [_path, _tex];
		array_push(_pairs, _pair);
	}
}

var _tilesets = texturegroup_get_tilesets(_name);
for (var i = 0, n = array_length(_tilesets); i < n; i++) {
	var _tileset = _tilesets[i];
	var _tex = tileset_get_texture(_tileset);
	var _path = wdt_get_image_path(_tex);
	if (_path != undefined && !ds_map_exists(_found, _path)) {
		_found[?_path] = true;
		_pair = [_path, _tex];
		array_push(_pairs, _pair);
	}
}

ds_map_clear(_found);
global.__wdt_texture_group_image_pairs[?_name] = _pairs;
wdt_autoload_enable(_autoload);
return _pairs;