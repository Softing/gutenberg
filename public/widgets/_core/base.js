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

function _a(icon) {
    return true;
}

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


// Executor

Ext.BLANK_IMAGE_URL = '/ext-3.2.1/resources/images/default/s.gif';

Ext.ns('Inprint');

Ext.onReady(function() {

    Ext.QuickTips.init();

    // Enable history
    Ext.History.init();
    Ext.History.on('change', function(token) {
        if(token) {}
    }, this);

    Inprint.registry = new Inprint.Registry();
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

    // Start session manager
    Inprint.updateSession = function(async) {
        Ext.Ajax.request({
            async: async,
            url: '/workspace/appsession/',
            scope: this,
            success: function(response) {
                var data = Ext.util.JSON.decode( response.responseText );
                if (data.session && data.session.uuid){
                    Inprint.session = data.session;
                    Inprint.session.access = data.access;
                    Inprint.session.card = data.card;
                    Inprint.session.settings = data.settings;
                    Inprint.updateSession.defer( 60000, this, [ true ]);
                } else {
                    //Ext.MessageBox.alert(
                    //'Сессия закрыта',
                    //'Возможно кто-то вошел в Инпринт с вашим логином на другом компьютере.<br />Окно будет перезагружено.',
                    //function() { /*window.location = '/login/';*/ });
                }
            }
        });
    }(false);

    // Remove loading mask
    setTimeout(function(){
        Ext.get('loading').remove();
        Ext.get('loading-mask').fadeOut({remove:true});
    }, 100);
});
