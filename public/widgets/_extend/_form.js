/* Fields */

_FLD_HDN_ID = {
    xtype: "hidden",
    name: "id",
    allowBlank:false
};

_FLD_HDN_PATH = {
    xtype: "hidden",
    name: "path",
    allowBlank:false
};

_FLD_HDN_EDITION = {
    xtype: "hidden",
    name: "edition",
    allowBlank:false
};

_FLD_HDN_FASCICLE = {
    xtype: "hidden",
    name: "fascicle",
    allowBlank:false
};

_FLD_HDN_PLACE = {
    xtype: "hidden",
    name: "place",
    allowBlank:false
};

_FLD_HDN_PAGE = {
    xtype: "hidden",
    name: "page",
    allowBlank:false
};

_FLD_HDN_PARENT = {
    xtype: "hidden",
    name: "parent",
    allowBlank:false
};

_FLD_HDN_HEADLINE = {
    xtype: "hidden",
    name: "headline",
    allowBlank:false
};


_FLD_NAME = {
    xtype: "textfield",
    allowBlank:false,
    name: "name",
    fieldLabel: _("Name"),
    emptyText: _("Name")
};

_FLD_FILENAME = {
    xtype: "textfield",
    allowBlank:false,
    name: "filename",
    fieldLabel: _("File name"),
    emptyText: _("File name")
};

_FLD_TITLE = {
    xtype: "textfield",
    allowBlank:false,
    name: "title",
    fieldLabel: _("Title"),
    emptyText: _("Title")
};

_FLD_SHORTCUT = {
    xtype: "textfield",
    allowBlank:false,
    name: "shortcut",
    fieldLabel: _("Shortcut"),
    emptyText: _("Shortcut")
};

_FLD_DESCRIPTION = {
    xtype: "textarea",
    allowBlank:true,
    name: "description",
    fieldLabel: _("Description"),
    emptyText: _("Description")
};

_FLD_URL = {
    xtype: "textfield",
    allowBlank:false,
    name: "url",
    fieldLabel: _("URL")
};

_FLD_COLOR = {
    xtype: "colorpickerfield",
    fieldLabel: _("Color"),
    editable:false,
    name: "color",
    value: "000000"
};

_FLD_PERCENT = {
    xtype: 'spinnerfield',
    fieldLabel: _("Percent"),
    name: 'percent',
    minValue: 0,
    maxValue: 100,
    incrementValue: 5,
    accelerate: true
};

_FLD_WEIGHT = {
    xtype: 'spinnerfield',
    fieldLabel: _("Weight"),
    name: 'weight',
    minValue: 0,
    maxValue: 100,
    incrementValue: 5,
    accelerate: true
};


/* Buttons for Window */

var _BTN_FINDER = function () {
    var wndw = this.findParentByType("window");
    if (!wndw) {
        alert('Window not found');
        return;
    }

    var panel = wndw.findByType("form")[0];

    if (!panel || !panel.getForm) {
        panel = wndw.items.first();
    }

    if (!panel || !panel.getForm) {
        alert('FormPanel not found');
        return;
    }

    var form = panel.getForm();
    if (!form) {
        alert('Form not found');
        return;
    }

    form.submit({ submitEmptyText: false });
}

var _BTN_WNDW_ADD = {
    text: _("Add"),  handler: _BTN_FINDER
};

var _BTN_WNDW_SAVE = {
    text: _("Save"), handler: _BTN_FINDER
};

var _BTN_WNDW_OK = {
    text: _("Ok"),   handler: _BTN_FINDER
};

var _BTN_WNDW_CLOSE = {
    text: _("Close"), handler: function() { this.findParentByType("window").hide(); }
};

var _BTN_WNDW_CANCEL = {
    text: _("Cancel"), handler: function() { this.findParentByType("window").hide(); }
};

/* Buttons for Forms in Window */

var _BTN_WNDW_FORM_ADD = {
    text: _("Add"), handler: function() {
        this.findParentByType("form").getForm().submit({
            submitEmptyText: false
        });
    }
};

var _BTN_WNDW_FORM_SAVE = {
    text: _("Save"), handler: function() {
        this.findParentByType("form").getForm().submit({
            submitEmptyText: false
        });
    }
};

var _BTN_WNDW_FORM_OK = {
    text: _("Ok"), handler: function() {
        this.findParentByType("form").getForm().submit({
            submitEmptyText: false
        });
    }
};

var _BTN_WNDW_FORM_CLOSE = {
    text: _("Close"), handler: function() { this.findParentByType("window").hide(); }
};

var _BTN_WNDW_FORM_CANCEL = {
    text: _("Cancel"), handler: function() { this.findParentByType("window").hide(); }
};


/* Buttons for Form  */

var _BTN_ADD = {
    text: _("Add"),
    handler: function() {
        this.findParentByType('form').getForm().submit({
            submitEmptyText: false
        });
    }
};

var _BTN_SAVE = {
    text: _("Save"),
    handler: function() {
        this.findParentByType('form').getForm().submit({
            submitEmptyText: false
        });
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
