Ext.Ajax.extraParams = {
    'ajax': true
};

Ext.Ajax.on('beforerequest', function(conn, options) {
    options.extraParams = {
        ajax:true
    };
}, this);

Ext.Ajax.on('requestexception', function(conn, response, options) {

    var errorText = _("Error communicating with server");
    var jsonData = Ext.util.JSON.decode(response.responseText);

    if (jsonData && jsonData.error) {
        errorText = jsonData.error;
        errorText = errorText.replace(/%br%/g, "<br/>");
    }

    Ext.Msg.show({
        title:_("Communication error"),
        minWidth:900,
        maxWidth:900,
        msg: errorText,
        buttons: Ext.Msg.OK
    });

}, this);

Array.prototype.contains = function(obj) {
    var i = this.length;
    while (i--) {
        if (this[i] == obj) {
            return true;
        }
    }
    return false;
};
