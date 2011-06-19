Inprint.setAction("rubric.create", function(grid) {

    var headline = grid.getHeadline();
    var url = _url("/catalog/rubrics/create/");

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
            _FLD_HDN_HEADLINE,
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
            grid.cmpReload();
        }
    });

    form.getForm().findField("headline").setValue(headline);

    var win = Inprint.factory.windows.create(
        "Create rubric", 400, 260, form
    ).show();

});
