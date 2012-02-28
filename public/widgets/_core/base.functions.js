// Inprint Content 5.0
// Copyright(c) 2001-2011, Softing, LLC.
// licensing@softing.ru
// http://softing.ru/license

function _ico(icon) {
   return "/icons/" + icon + ".png";
}

function _ico24(icon) {
   return "/icons-24/" + icon + ".png";
}

function _ico32(icon) {
   return "/icons-32/" + icon + ".png";
}

function _url(url) {
   return url;
}

_nullId = function(uuid) {
    return "00000000-0000-0000-0000-000000000000";
};

_idIsNull = function(uuid) {
    return uuid == "00000000-0000-0000-0000-000000000000";
};

_get_values = function(myfield, myarray) {
    var data = [];
    Ext.each(myarray, function(record) {
        data.push(record.data[myfield]);
    });
    return data;
};

// Inverse colors

function inprintColorContrast(hexcolor){
    var r = parseInt(hexcolor.substr(0,2),16);
    var g = parseInt(hexcolor.substr(2,2),16);
    var b = parseInt(hexcolor.substr(4,2),16);
    var yiq = ((r*299)+(g*587)+(b*114))/1000;
    return (yiq >= 128) ? 'black' : 'white';
}

function inprintColorLuminance(hex, lum) {
    // validate hex string
    hex = String(hex).replace(/[^0-9a-f]/gi, '');
    if (hex.length < 6) {
        hex = hex[0]+hex[0]+hex[1]+hex[1]+hex[2]+hex[2];
    }
    lum = lum || 0;
    // convert to decimal and change luminosity
    var rgb = "#", c, i;
    for (i = 0; i < 3; i++) {
        c = parseInt(hex.substr(i*2,2), 16);
        c = Math.round(Math.min(Math.max(0, c + (c * lum)), 255)).toString(16);
        rgb += ("00"+c).substr(c.length);
    }
    return rgb;
}

// Ext specifed

function _fmtDate(str, format, inputFormat) {

    var dt = Date.parseDate(str, "Y-m-d h:i:s");
    if (dt) {
        return dt.dateFormat(format || 'M j, Y');
    }
    return '';

}

// Helpers
function _show() {
    Ext.each(arguments, function(c) {
        if (c && c.show) {
            c.show();
        }
    });
}
function _hide() {
    Ext.each(arguments, function(c) {
        if (c && c.hide) {
            c.hide();
        }
    });
}

function _enable() {
    Ext.each(arguments, function(c) {
        if (c && c.enable) {
            c.enable();
        }
    });
}
function _disable() {
    Ext.each(arguments, function(c) {
        if (c && c.disable) {
            c.disable();
        }
    });
}

/* Access functions */
function _a(terms, binding, accessfunction, scope) {
    Ext.Ajax.request({
        url: _url("/access/"),
        params: {
            term: terms,
            binding: binding
        },
        scope: scope,
        success: function(result) {
            var data = Ext.util.JSON.decode(result.responseText);
            accessfunction(data.result);
        }
    });
}

function _accessCheck(terms, binding, accessfunction) {
    _a(terms, binding, accessfunction);
}

function _arrayAccessCheck(records, fields) {
    var result = {};
    for (var r=0; r<records.length;r++) {
        var access = records[r].get("access");
        for (var f=0; f<fields.length;f++) {
            var field = fields[f];
            if (access[field] && result[field] != 'disabled') {
                result[field] = 'enabled';
            } else {
                result[field] = 'disabled';
            }
        }
    }
    return result;
}
