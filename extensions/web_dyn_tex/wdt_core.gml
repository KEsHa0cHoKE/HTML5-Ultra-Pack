#define wdt_preinit
//#init wdt_preinit
global.__wdt_native = os_browser == browser_not_a_browser;
global.__wdt_status = ds_map_create(); /// @is {ds_map<string, int>}
global.__wdt_async = ds_map_create(); /// @is {ds_map<sprite, texture>}
global.__wdt_sprite_number = ds_map_create(); /// @is {ds_map<sprite, int>}
try {
	global.__wdt_base_sprites = asset_get_ids(asset_sprite);
	global.__wdt_base_fonts = asset_get_ids(asset_font);
	global.__wdt_base_tilesets = asset_get_ids(asset_tiles);
} catch (_) {
	var n = 0;
	while (sprite_exists(n)) n += 1;
	global.__wdt_base_sprites = array_create(n);
	for (var i = 0; i < n; i++) global.__wdt_base_sprites[i] = i;
	//
	n = 0;
	while (font_exists(n)) n += 1;
	global.__wdt_base_fonts = array_create(n);
	for (var i = 0; i < n; i++) global.__wdt_base_fonts[i] = i;
	//
	n = 0;
	while (n < 0x8000) {
		var _name = tileset_get_name(n);
		if (_name == "<undefined>") break;
		n += 1;
	}
	global.__wdt_base_tilesets = array_create(n);
	for (var i = 0; i < n; i++) global.__wdt_base_tilesets[i] = i;
}
global.__wdt_texture_group_image_pairs = ds_map_create(); /// @is {ds_map<string, array<[string, texture]>>}
global.__wdt_texture_group_temp = ds_map_create(); /// @is {ds_map<string, bool>}
//#macro wdt_status_ready 1
//#macro wdt_status_loading 0
//#macro wdt_status_fallback -1
//#macro wdt_status_error -2
wdt_preinit_raw();
if (wdt_magic_false()) {
	gmcallback_wdt_preinit();
	gmcallback_wdt_async_image(undefined, undefined, -1);
	gmcallback_wdt_load_texture(undefined);
}

#define gmcallback_wdt_preinit
wdt_magic_false("draw_texture_flush", draw_texture_flush());

#define wdt_get_status_name
/// (status)->
switch (argument0) {
	case wdt_status_ready: return "ready";
	case wdt_status_loading: return "loading";
	case wdt_status_fallback: return "fallback";
	case wdt_status_error: return "error";
	default: return "status " + string(argument0);
}

#define wdt_async_image
/// ()
if (global.__wdt_native) exit;

var _sprite = async_load[?"id"];
var _texture = global.__wdt_async[?_sprite];
if (_texture != undefined) {
	ds_map_delete(global.__wdt_async, _sprite);
	
	var _status = async_load[?"status"];
	var _path = wdt_get_image_path(_texture);
	if (_status < 0) {
		global.__wdt_status[?_path] = -1;
		exit;
	}
	var _new_texture = sprite_get_texture(_sprite, 0);
	var _new_path = wdt_get_image_path(_new_texture);
	global.__wdt_status[?_path] = 1;
	global.__wdt_status[?_new_path] = 1;
	
	wdt_assign_all(_texture, _new_texture);
}

#define gmcallback_wdt_async_image
var _texture = argument0, _new_texture = argument1, _status = argument2;
var _path = wdt_get_image_path(_texture);
if (_status < 0) {
	global.__wdt_status[?_path] = -1;
	exit;
}
var _new_path = wdt_get_image_path(_new_texture);
global.__wdt_status[?_path] = 1;
global.__wdt_status[?_new_path] = 1;

wdt_assign_all(_texture, _new_texture);

#define wdt_load_texture
/// (texture)->
if (global.__wdt_native) return false;
var _texture = argument0;

var _autoload = wdt_autoload_enable(false);
var _path = wdt_get_image_path(_texture);
wdt_autoload_enable(_autoload);

// uh oh?
if (_path == undefined) return false;

// already loading/loaded?
var _status = global.__wdt_status[?_path];
if (_status != undefined) return false;

var _new_path = wdt_change_ext(_path, ".orig.png");
show_debug_message("[wdt] Loading " + _new_path);

if (true) {
	wdt_load_texture_raw(_texture, _new_path);
} else {
	var _sprite = sprite_add(_new_path, 1, false, false, 0, 0);
	global.__wdt_async[?_sprite] = _texture;
}
global.__wdt_status[?_path] = 0;

return true;

#define gmcallback_wdt_load_texture
/// (texture)~
return wdt_load_texture(argument0);

#define wdt_get_texture_status
/// (texture)->
if (global.__wdt_native) return wdt_status_ready;

var _texture = argument0;
if (wdt_is_null(_texture)) return wdt_status_ready;

var _autoload = wdt_autoload_enable(false);
var _status = global.__wdt_status[?wdt_get_image_path(_texture)];
wdt_autoload_enable(_autoload);
return _status != undefined ? _status : wdt_status_fallback;

#define wdt_assign_all
/// (tx, ntx)~
if (global.__wdt_native) return 0;
var _tx = argument0, _ntx = argument1;
var _autoload = wdt_autoload_enable(false);
var _img = wdt_get_image(_tx);
var n, _found = 0;

var _sprites = global.__wdt_base_sprites;
n = array_length(_sprites);
for (var i = 0; i < n; i++) {
	var _sprite = _sprites[i];
	var _number = wdt_get_sprite_texture_number(_sprite);
	for (var k = 0; k < _number; k++) {
		var _itx = sprite_get_texture(_sprite, k);
		if (wdt_get_image(_itx) == _img) {
			_found += wdt_assign(_itx, _ntx);
		}
	}
}

var _fonts = global.__wdt_base_fonts;
n = array_length(_fonts);
for (var i = 0; i < n; i++) {
	var _font = _fonts[i];
	var _ftx = font_get_texture(_font);
	if (wdt_get_image(_ftx) == _img) {
		_found += wdt_assign(_ftx, _ntx);
	}
}

var _tilesets = global.__wdt_base_tilesets;
n = array_length(_tilesets);
for (var i = 0; i < n; i++) {
	var _tileset = _tilesets[i];
	var _ftx = tileset_get_texture(_tileset);
	if (wdt_get_image(_ftx) == _img) {
		_found += wdt_assign(_ftx, _ntx);
	}
}

wdt_assign_raw(_tx, _ntx);
wdt_autoload_enable(_autoload);
return _found;

#define wdt_autoload_textures
/// ()
var n, _found = 0;
var _autoload = wdt_autoload_enable(false);

var _sprites = global.__wdt_base_sprites;
n = array_length(_sprites);
for (var i = 0; i < n; i++) {
	var _sprite = _sprites[i];
	var _number = wdt_get_sprite_texture_number(_sprite);
	for (var k = 0; k < _number; k++) {
		var _itx = sprite_get_texture(_sprite, k);
		_found += wdt_autoload_texture(_itx);
	}
}

var _fonts = global.__wdt_base_fonts;
n = array_length(_fonts);
for (var i = 0; i < n; i++) {
	var _font = _fonts[i];
	var _ftx = font_get_texture(_font);
	_found += wdt_autoload_texture(_ftx);
}

var _tilesets = global.__wdt_base_tilesets;
n = array_length(_tilesets);
for (var i = 0; i < n; i++) {
	var _tileset = _tilesets[i];
	var _ftx = tileset_get_texture(_tileset);
	_found += wdt_autoload_texture(_ftx);
}

wdt_autoload_enable(_autoload);
return _found;