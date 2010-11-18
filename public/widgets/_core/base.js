/*
 * Inprint Content 4.5
 * Copyright(c) 2001-2010, Softing, LLC.
 * licensing@softing.ru
 *
 * http://softing.ru/license
 */

// Global functions

function _fmtDate(str, format, inputFormat) {

    var dt = Date.parseDate(str, "Y-m-d h:i:s");
    if (dt) {
        return dt.dateFormat(format || 'M j, Y');
    }
    return '';

};

function _enable() {
    Ext.each(arguments, function(c) {
        if (c && c.enable)
            c.enable();
    });
}

function _disable() {
    Ext.each(arguments, function(c) {
        if (c && c.disable) c.disable();
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

function _accessCheck(terms, binding, accessfunction){
    _a(terms, binding, accessfunction);
}

function _arrayAccessCheck(records, fields){
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

/* Icons functions */

function _ico24(icon) {
   return "/icons-24/" + icon + ".png";
}

function _ico32(icon) {
   return "/icons-32/" + icon + ".png";
}

function _ico(icon) {
   return "/icons/" + icon + ".png";
}

function _url(url) {
   return url;
}

var NULLID = "00000000-0000-0000-0000-000000000000";

_nullId = function(uuid) {
    return "00000000-0000-0000-0000-000000000000";
}

_idIsNull = function(uuid) {
    return uuid == "00000000-0000-0000-0000-000000000000";
}

_get_values = function(myfield, myarray) {
    var data = [];
    Ext.each(myarray, function(record) {
        data.push(record.data[myfield]);
    });
    return data;
};

// Inverse colors

function inverse(input) {
    if(input.length < 6 || input.length > 6){
    window.alert('You Must Enter a six digit color code')
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

function DecToHex(number) {
    var hexbase="0123456789ABCDEF";
    return hexbase.charAt((number>> 4)& 0xf)+ hexbase.charAt(number& 0xf);
}

function giveHex(s){
    s=s.toUpperCase();
    return parseInt(s,16);
}



// Executor

Ext.BLANK_IMAGE_URL = '/ext-3.3.0/resources/images/default/s.gif';

Ext.ns('Inprint');

Ext.onReady(function() {

    Ext.QuickTips.init();

    // Enable history
    Ext.History.init();
    Ext.History.on('change', function(token) {
        if(token) {}
    }, this);

    // Enable State Manager

    var stateProvider = new Ext.ux.state.HttpProvider({
        url:'/state/',
        readBaseParams: {
            cmd: 'read'
        },
        saveBaseParams: {
            cmd: 'save'
        }
    });

    Ext.state.Manager.setProvider(
        stateProvider
    );

    Inprint.session = {};

    // Start session manager
    Inprint.updateSession = function(async, defer) {
        Ext.Ajax.request({
            async: async,
            url: '/workspace/appsession/',
            scope: this,
            success: function(response) {
                Inprint.session = Ext.util.JSON.decode( response.responseText );
                if (Inprint.session && Inprint.session.member && Inprint.session.member.id ){
                    Inprint.checkSettings();
                    if (defer) Inprint.updateSession.defer( 90000, this, [ true, true ]);
                } else {
                    Ext.MessageBox.alert(
                    _("Your session is closed"),
                    _("Probably someone has entered in Inprint with your login on other computer. <br/> push F5 what to pass to authorization page"),
                    function() {});
                }
            }
        });
    };

    Inprint.checkInProgress = false;
    Inprint.checkSettings = function(){
        if (Inprint.checkInProgress) return;
        if (
            !Inprint.session.member.title ||
            !Inprint.session.member.shortcut ||
            !Inprint.session.member.position ||
            !Inprint.session.options ||
            !Inprint.session.options["default.edition"] ||
            !Inprint.session.options["default.edition.name"] ||
            !Inprint.session.options["default.workgroup"] ||
            !Inprint.session.options["default.workgroup.name"] 
        ) {
            Inprint.checkInProgress = true;
            var setupWindow = new Inprint.cmp.memberSetupWindow();
            setupWindow.on("hide", function() {
                Inprint.checkInProgress = false;
            });
            setupWindow.show();
        }
    };

    Inprint.updateSession(true, true);

    // Enable registry and layout
    //Inprint.registry = new Inprint.Registry();
    Inprint.layout   = new Inprint.Workspace();

    // Resolve url
    var params = Ext.urlDecode( window.location.search.substring( 1 ) );

    if (Inprint.registry[ params.aid ]){
        Inprint.ObjectResolver.resolve({
            aid: params.aid,
            oid: params.oid,
            text: params.text,
            description: params.description
        });
    }

    // Remove loading mask
    //setTimeout(function(){
        Ext.get('loading').remove();
        Ext.get('loading-mask').fadeOut({remove:true});
    //}, 0);

});
