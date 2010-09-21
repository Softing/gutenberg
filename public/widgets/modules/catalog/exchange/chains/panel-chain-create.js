Inprint.exchange.CreateChainPanel = function () {

    var url = _url("/chains/create/");

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
                name: "path"
            },
            Inprint.factory.Combo.create("catalog", {
                scope:this,
                listeners: {
                    select: function(combo, record, indx) {
                        combo.ownerCt.getForm().findField("path").setValue(record.get("id"));
                    }
                }
            }),
            _FLD_NAME,
            _FLD_SHORTCUT,
            _FLD_DESCRIPTION
        ],
        keys: [ _KEY_ENTER_SUBMIT ],
        buttons: [ _BTN_SAVE,_BTN_CLOSE ]
    });

    var win = new Ext.Window({
        title: _("Create chain"),
        layout: "fit",
        closeAction: "hide",
        width:400, height:260,
        items: form
    });

    win.relayEvents(form, ["actioncomplete"]);

    return win;
}
