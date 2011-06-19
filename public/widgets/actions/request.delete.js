Inprint.setAction("request.delete", function(grid) {

    var url = _url("/fascicle/requests/delete/");

    var params = {
        id: grid.getValues("id")
    };

    var form = new Ext.FormPanel({
        url: url,
        border: false,
        defaultType: 'checkbox',
        defaults: {
            anchor: "100%",
            allowBlank:false,
            hideLabel:true
        },
        bodyStyle: 'padding:5px 10px;',
        items: [
            {
                xtype: "checkbox",
                name: "delete-request",
                checked: true,
                inputValue: "true",
                fieldLabel: "",
                labelSeparator: "",
                boxLabel: _("Delete request")
            },
            {
                xtype: "checkbox",
                name: "delete-module",
                checked: true,
                inputValue: "true",
                fieldLabel: "",
                labelSeparator: "",
                boxLabel: _("Delete module")
            }
        ],
        keys: [ _KEY_ENTER_SUBMIT ],
        buttons: [ _BTN_OK, _BTN_CLOSE ]
    });

    form.on("actioncomplete", function (form, action) {
        if (action.type == "submit") {
            win.hide();
            grid.cmpReload();
        }
    });

    var win = Inprint.factory.windows.create(
        "Delete request", 195, 130, form
    ).show();

});
