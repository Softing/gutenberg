// Inprint Content 5.0
// Copyright(c) 2001-2011, Softing, LLC.
// licensing@softing.ru
// http://softing.ru/license

Ext.Ajax.extraParams = {
    'ajax': true
};

Ext.Ajax.on('beforerequest', function(conn, options) {
    options.extraParams = {
        ajax:true
    };
});

Ext.Ajax.on('requestexception', function(conn, response, options) {

    var errorText = _("Error communicating with server");
    var jsonData = Ext.util.JSON.decode(response.responseText);

    if (jsonData && jsonData.error) {
        errorText = jsonData.error;
        errorText = errorText.replace(/%br%/g, "<br/>");
    }

    Inprint.log(errorText);

});

Array.prototype.contains = function(obj) {
    var i = this.length;
    while (i--) {
        if (this[i] == obj) {
            return true;
        }
    }
    return false;
};

Ext.apply(Ext.EventObject, {
    within_el:function(el) {
        el = Ext.get(el);
        if(!el)
            return false;
        var evt_xy = this.getXY();
        var evt_x = evt_xy[0];
        var evt_y = evt_xy[1];
        return (evt_x > el.getLeft() && evt_x < el.getRight() && evt_y > el.getTop() && evt_y < el.getBottom());
    }
});
