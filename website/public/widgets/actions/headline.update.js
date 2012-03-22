Inprint.setAction("headline.update", function(tree, node) {

    var urlForm = _url("/catalog/headlines/update/");
    var urlRead = _url("/catalog/headlines/read/");

    var form = new Ext.FormPanel({
        url: urlForm,
        frame:false,
        border:false,
        labelWidth: 75,
        defaults: {
            anchor: "100%",
            allowBlank:false
        },
        bodyStyle: "padding:5px 5px",
        items: [
            _FLD_HDN_ID,
            {
                xtype: "titlefield",
                value: _("Basic options")
            },
            _FLD_TITLE,
            _FLD_DESCRIPTION,
            {
                xtype: "titlefield",
                value: _("More options")
            },
            {
                xtype: 'checkbox',
                fieldLabel: _(""),
                labelSeparator: '',
                boxLabel: _("Use by default"),
                name: 'bydefault',
                checked: false
            }
        ],
        keys: [ _KEY_ENTER_SUBMIT ],
        buttons: [ _BTN_SAVE,_BTN_CLOSE ]
    });

    form.on("actioncomplete", function (form, action) {
        if (action.type == "submit") {
            win.hide();
            tree.cmpReload();
        }
    }, this);

    form.load({
        url: urlRead,
        scope:this,
        params: {
            id: node.id
        },
        success: function(form, action) {
            win.body.unmask();
        }
    });

    var win = Inprint.factory.windows.create(
        "Update headline", 400, 260, form
    ).show();

    win.body.mask();

});
