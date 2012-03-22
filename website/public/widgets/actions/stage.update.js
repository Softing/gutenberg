Inprint.setAction("stage.update", function(grid) {

    var url = _url("/catalog/stages/update/");

    var form = new Ext.FormPanel({
        xtype:"form",
        url: url,
        frame:false,
        border:false,
        labelWidth: 75,
        defaults: {
            anchor: "100%",
            allowBlank:false
        },
        bodyStyle: "padding:10px",
        items: [
            _FLD_HDN_ID,
            Inprint.factory.Combo.getConfig("/catalog/combos/readiness/"),
            {   xtype: 'spinnerfield',
                fieldLabel: _("Weight"),
                name: 'weight',
                minValue: 0,
                maxValue: 100,
                incrementValue: 5,
                accelerate: true
            },
            _FLD_SHORTCUT,
            _FLD_DESCRIPTION
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
        url: _url("/catalog/stages/read/"),
        params: { id: grid.getValue("id") },
        success: function(form, action) {
            win.body.unmask();
        }
    });

    var win = Inprint.factory.windows.create(
        "Update stage", 400, 260, form
    ).show();

    win.body.mask();

});
