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

function DecToHex(number) {
    var hexbase="0123456789ABCDEF";
    return hexbase.charAt((number>> 4)& 0xf)+ hexbase.charAt(number& 0xf);
}

function giveHex(s) {
    s=s.toUpperCase();
    return parseInt(s,16);
}

function inverse(input) {

    if(!input) {
        return false;
    }

    if(input.length < 6 || input.length > 6){
        window.alert('You Must Enter a six digit color code');
        return false;
    }

    hex1 = input.slice(0,2);
    hexb1 = input.slice(2,4);
    hexc1 = input.slice(4,6);
    hex2 = 16 * giveHex(hex1.slice(0,1));
    hex3 = giveHex(hex1.slice(1,2));
    hex1 = hex1 + hex2;
    hexb2 = 16 * giveHex(hexb1.slice(0,1));
    hexb3 = giveHex(hexb1.slice(1,2));
    hexb1 = hexb2 + hexb3;
    hexc2 = 16 * giveHex(hexc1.slice(0,1));
    hexc3 = giveHex(hexc1.slice(1,2));
    hexc1 = hexc2 + hexc3;
    newColor = DecToHex(255-hex1) + "" + DecToHex(255-hexb1) + "" + DecToHex(255-hexc1);

    return newColor;
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
function _a(terms, binding, accessfunction) {
    Ext.Ajax.request({
        url: _url("/access/"),
        params: {
            term: terms,
            binding: binding
        },
        scope: this,
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
