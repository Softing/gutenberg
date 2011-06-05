Inprint.setAction("edition.create", function(node) {

    var url = _url("/catalog/editions/create/");

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
            _FLD_HDN_PATH,
            _FLD_TITLE,
            _FLD_SHORTCUT,
            _FLD_DESCRIPTION
        ],
        keys: [ _KEY_ENTER_SUBMIT ],
        buttons: [ _BTN_ADD,_BTN_CLOSE ]
    });

    form.on("actioncomplete", function (form, action) {
        if (action.type == "submit") {

            win.hide();

            if (node.reload) {
                node.reload();
            }

            else if (node.parentNode.reload) {
                node.parentNode.reload();
            }

        }
    }, this);

    form.getForm().findField("path").setValue(node.id);

    var win = Inprint.factory.windows.create(
        "Create edition", 400, 230, form
    ).show();

});
