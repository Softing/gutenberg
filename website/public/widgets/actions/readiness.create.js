Inprint.setAction("readiness.create", function(grid) {

    var url = _url("/catalog/readiness/create/");

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
            _FLD_SHORTCUT,
            _FLD_DESCRIPTION,
            _FLD_COLOR,
            _FLD_PERCENT
        ],
        keys: [ _KEY_ENTER_SUBMIT ],
        buttons: [ _BTN_SAVE,_BTN_CLOSE ]
    });

    form.on("actioncomplete", function (form, action) {
        if (action.type == "submit") {
            win.hide();
            grid.cmpReload();
        }
    });

    var win = Inprint.factory.windows.create(
        "Create readiness", 400, 280, form
    ).show();

});
