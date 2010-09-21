Ext.BLANK_IMAGE_URL = '/ext-3.2.1/resources/images/default/s.gif';

Ext.data.Connection.prototype._handleFailure = Ext.data.Connection.prototype.handleFailure;
Ext.data.Connection.prototype.handleFailure = function(response, e) {
    var jsonData = Ext.util.JSON.decode(response.responseText);
    if (jsonData) {
        var errorText = jsonData.error;
        errorText = errorText.replace(/%br%/g, "<br/>");
        Ext.Msg.show({
            title:_("Communication error"),
            minWidth:900,
            maxWidth:900,
            msg: errorText,
            buttons: Ext.Msg.OK
        });
    }
    Ext.data.Connection.prototype._handleFailure.call(this, response, e);
};

//Ajax

Ext.Ajax.extraParams = {
    'ajax': true
};

Ext.Ajax.on('beforerequest', function(conn, options) {
    options.extraParams = {
        ajax:true
    }
}, this);

/* Fields */

_FLD_HDN_ID = {
    xtype: "hidden",
    name: "id"
};

_FLD_HDN_PATH = {
    xtype: "hidden",
    name: "path"
};

_FLD_NAME = {
    xtype: "textfield",
    allowBlank:false,
    name: "name",
    fieldLabel: _("Name")
};

_FLD_SHORTCUT = {
    xtype: "textfield",
    allowBlank:false,
    name: "shortcut",
    fieldLabel: _("Shortcut")
};

_FLD_DESCRIPTION = {
    xtype: "textarea",
    allowBlank:true,
    name: "description",
    fieldLabel: _("Description")
};

/* Buttons */

var _BTN_ADD = {
    text: _("Add"),
    handler: function() {
        this.findParentByType('form').getForm().submit();
    }
};

var _BTN_SAVE = {
    text: _("Save"),
    handler: function() {
        this.findParentByType('form').getForm().submit();
    }
};

var _BTN_CLOSE = {
    text: _("Close"),
    handler: function() {
        this.findParentByType('window').hide();
    }
};

var _BTN_CANCEL = {
    text: _("Cancel"),
    handler: function() {
        this.findParentByType('window').hide();
    }
};

/* Keys */

_KEY_ENTER_SUBMIT = {
    key: [Ext.EventObject.ENTER], fn: function() {
        //this.findParentByType('form').getForm().submit();
    }
};
