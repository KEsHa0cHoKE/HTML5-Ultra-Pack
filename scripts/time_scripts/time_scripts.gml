/// @func   time_convert_datetime_to_iso8601(double datetime)
/// @desc   Returns ISO 8601 datetime string.
function time_convert_datetime_to_iso8601(_dt){
	var _tz = date_get_timezone();
	date_set_timezone(timezone_utc);
	//
	var _s = string(date_get_year(_dt)) + "-";
	//
	if (date_get_month(_dt) < 10) _s += "0";
	_s += string(date_get_month(_dt)) + "-";
	//
	if (date_get_day(_dt) < 10) _s += "0";
	_s += string(date_get_day(_dt)) + "T";
	//
	if (date_get_hour(_dt) < 10) _s += "0";
	_s += string(date_get_hour(_dt)) + ":";
	//
	if (date_get_minute(_dt) < 10) _s += "0";
	_s += string(date_get_minute(_dt)) + ":";
	//
	if (date_get_second(_dt) < 10) _s += "0";
	_s += string(date_get_second(_dt)) + ".";
	// Milliseconds are not supported
	_s += "000Z";
	//
	date_set_timezone(_tz);
	return _s;
}

/// @func   time_convert_iso8601_to_datetime(string _datetime)
/// @desc   Returns GameMaker datetime from ISO 8601 datetime string.
function time_convert_iso8601_to_datetime(_datetime){
	try {
		var _p = string_pos("T", string_upper(_datetime));
		if (_p == 0) {
			throw ("Date and time separator not found.");
		}
		// Date
		var _date = string_copy(_datetime, 1, _p);
		_date = string_digits(_date);
		if (string_length(_date) < 8) {
			throw ("The date format is incorrect.");
		}
		var _year = real(string_copy(_date, 1, 4));
		var _month = real(string_copy(_date, 5, 2));
		var _day = real(string_copy(_date, 7, 2));
		// Time
		_datetime = string_delete(_datetime, 1, _p);
		var _l = string_length(_datetime);
		var _timezone = "";
		_p = string_last_pos("-", _datetime);
		if (_p > 0) {
			_timezone = string_copy(_datetime, _p, _l - _p + 1);
			_datetime = string_copy(_datetime, 1, _p - 1);
		}
		else {
			_p = string_last_pos("+", _datetime);
			if (_p > 0) {
				_timezone = string_copy(_datetime, _p, _l - _p + 1);
				_datetime = string_copy(_datetime, 1, _p - 1);
			}
		}
		var _time = string_digits(_datetime);
		if (string_length(_time) < 4) {
			throw ("The time format is incorrect.");
		}
		var _hour = real(string_copy(_time, 1, 2));
		var _minute = real(string_copy(_time, 3, 2));
		var _second = string_length(_time) >= 6 ? real(string_copy(_time, 5, 2)) : 0;
		var _tz = date_get_timezone();
		date_set_timezone(timezone_utc);
		var _d = date_create_datetime(_year, _month, _day, _hour, _minute, _second);
		// Milliseconds are not supported
		if (string_length(_timezone) >= 3) {
			var _s = string_copy(_timezone, 1, 3);
			var _h = real(_s);
			var _t = _h > 0;
			_h = abs(_h);
			_d = date_inc_hour(_d, _t ? 0 - _h : _h);
			if (string_length(_timezone) >= 5) {
				_s = string_copy(_timezone, 5, 2);
				var _m = real(string_digits(_s));
				_d = date_inc_minute(_d, _t ? 0 - _m : _m);
			}
		}
		date_set_timezone(_tz);
		//
		return _d;
	}
	catch(_e) {
		if (debug_mode) {
			show_message(_e);
		}
	}
	return 0;
}

/// @func   time_get_unixtime()
/// @desc   Returns Unix timestamp.
function time_get_unixtime(){
    var _timezone = date_get_timezone();
 
    date_set_timezone(timezone_utc);
    var _epoch = floor(date_create_datetime(1970, 1, 1, 0, 0, 0));
    
    date_set_timezone(_timezone);
    var _datetime = date_current_datetime();
    
    var _timestamp = floor(date_second_span(_epoch, _datetime));
 
    return _timestamp;
}

/// @func   time_convert_unixtime(unix_timestamp)
/// @desc   Returns GameMaker datetime from Unix timestamp.
function time_convert_unixtime(_timestamp){
	var _t = date_inc_second(25569+1, _timestamp);
	return date_inc_day(_t, -1);
}