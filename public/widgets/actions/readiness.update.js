Inprint.setAction("readiness.update", function(grid) {

    var urlForm = _url("/catalog/readiness/update/");
    var urlRead = _url("/catalog/readiness/read/");

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

    form.load({
        url: urlRead,
        params: {
            id: grid.getValue("id")
        },
        success: function(form, action) {
            win.body.unmask();
        }
    });

    var win = Inprint.factory.windows.create(
        "Update readiness", 400, 280, form
    ).show();

    win.body.mask();
});
