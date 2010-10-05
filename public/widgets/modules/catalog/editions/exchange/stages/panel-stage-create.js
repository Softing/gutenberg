Inprint.catalog.exchange.CreateStagePanel = function () {

    var url = _url("/stages/create/");

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
            {
                xtype: "hidden",
                name: "chain"
            },
            {   xtype: "colorpickerfield",
                fieldLabel: _("Color"),
                editable:false,
                name: "color",
                value: "000000"
            },
            {   xtype: 'spinnerfield',
                fieldLabel: _("Weight"),
                name: 'weight',
                minValue: 0,
                maxValue: 100,
                incrementValue: 5,
                accelerate: true
            },
            _FLD_NAME,
            _FLD_SHORTCUT,
            _FLD_DESCRIPTION
        ],
        keys: [ _KEY_ENTER_SUBMIT ],
        buttons: [ _BTN_SAVE,_BTN_CLOSE ]
    });

    var win = new Ext.Window({
        title: _("Create stage"),
        layout: "fit",
        closeAction: "hide",
        width:400, height:260,
        items: form
    });

    win.relayEvents(form, ["actioncomplete"]);

    return win;
}
