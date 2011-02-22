Inprint.catalog.editions.ChangeStagePanel = function () {

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
            _FLD_TITLE,
            _FLD_SHORTCUT,
            _FLD_DESCRIPTION
        ],
        keys: [ _KEY_ENTER_SUBMIT ],
        buttons: [ _BTN_SAVE,_BTN_CLOSE ]
    });

    var win = new Ext.Window({
        title: _("Change stage"),
        layout: "fit",
        closeAction: "hide",
        width:400, height:260,
        modal:true,
        items: form
    });

    win.relayEvents(form, ["actioncomplete"]);

    return win;
};
