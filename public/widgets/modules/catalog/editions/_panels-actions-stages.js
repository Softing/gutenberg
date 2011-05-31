Inprint.setAction("stages.create", function (tree, grid) {

    var url = _url("/catalog/stages/create/");
    var edition = tree.cmpCurrentNode().id;

    var win = new Ext.Window({
        title: _("Create stage"),
        layout: "fit",
        closeAction: "hide",
        width:400, height:260,
        modal:true
    });

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
                name: "branch",
                xtype: "hidden",
                allowBlank:false,
                value: edition
            },
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
        buttons: [ _BTN_SAVE, _BTN_CLOSE ]
    });

    win.add(form);

    form.on("actioncomplete", function (form, action) {
        if (action.type == "submit") {
            win.hide();
            grid.cmpReload();
        }
    });

    win.show();
});

Inprint.setAction("stages.update", function(tree, grid) {

    var url = _url("/catalog/stages/update/");

    var win = new Ext.Window({
        title: _("Change stage"),
        layout: "fit",
        closeAction: "hide",
        width:400, height:260,
        modal:true
    });

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

    win.add(form);

    win.show();

    win.body.mask(_("Loading..."));

    form.load({
        url: _url("/catalog/stages/read/"),
        params: { id: grid.getValue("id") },
        success: function(form, action) {
            win.body.unmask();
        },
        failure: function(form, action) {
            Ext.Msg.alert("Load failed", action.result.errorMessage);
        }
    });

});

Inprint.setAction("stages.delete", function(tree, grid) {
    Ext.MessageBox.confirm(
        _("Edition removal"),
        _("You really wish to do this?"),
        function(btn) {
            if (btn == "yes") {
                Ext.Ajax.request({
                    url: _url("/catalog/stages/delete/"),
                    params: { id: grid.getValues("id") },
                    success: function(form, action) {
                        grid.cmpReload();
                    }
                });
            }
        });
});

Inprint.setAction("stages.principals", function(tree, grid) {

    win = new Inprint.cmp.PrincipalsSelector({
        urlLoad: "/catalog/stages/principals-mapping/",
        urlDelete: "/catalog/stages/unmap-principals/"
    });

    win.on("show", function(win) {
        win.panels.selection.cmpLoad({
            stage: grid.getValue("id")
        });
    });

    win.on("close", function(win) {
        grid.cmpReload();
    });

    win.on("save", function(srcgrid, catalog, ids) {
        Ext.Ajax.request({
            url: "/catalog/stages/map-principals/",
            params: {
                stage: grid.getValue("id"),
                catalog: catalog,
                principals: ids
            },
            success: function() {
                srcgrid.cmpReload();
            }
        });
    });

    win.on("delete", function(srcgrid, ids) {
        Ext.Ajax.request({
            url: "/catalog/stages/unmap-principals/",
            params: {
                principals: ids
            },
            success: function() {
                srcgrid.cmpReload();
            }
        });
    });

    win.show();

});
