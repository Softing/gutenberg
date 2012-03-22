Inprint.setAction("headline.create", function(headlines) {

    var edition = headlines.getEdition();
    var url = _url("/catalog/headlines/create/");

    var form = new Ext.FormPanel({

        url: url,

        frame:false,
        border:false,

        labelWidth: 75,
        defaults: {
            anchor: "100%",
            allowBlank:false
        },
        bodyStyle: "padding:5px 5px",
        items: [
            _FLD_HDN_EDITION,
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
        buttons: [ _BTN_ADD,_BTN_CLOSE ]
    });

    form.on("actioncomplete", function (form, action) {
        if (action.type == "submit") {
            win.hide();
            headlines.cmpReload();
        }
    }, this);

    form.getForm().findField("edition").setValue(edition);

    var win = Inprint.factory.windows.create(
        "Create headline", 400, 260, form
    ).show();

});
