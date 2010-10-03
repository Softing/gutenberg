Inprint.exchange.Actions = function(panels) {

    var grid = panels.grid;

    var components = {};

    grid.actions = {};

    grid.actions.createChain = function() {
        var win = components["create-chain-window"];
        if (!win) {
            win = Inprint.exchange.CreateChainPanel();
            components["create-chain-window"] = win;
        }
        win.items.first().getForm().reset();
        win.show();
    };

    grid.actions.changeChain = function() {
        var win = components["change-chain-window"];
        if (!win) {
            win = Inprint.exchange.ChangeChainPanel();
            components["change-chain-window"] = win;
        }
        win.show();
        win.body.mask(_("Loading..."));
        var form = win.items.first().getForm();
        form.reset();
        form.load({
            url: _url("/chains/read/"),
            scope:this,
            params: {
                id: this.getCurrentChain()
            },
            success: function(form, action) {
                win.body.unmask();
                form.findField("path").setValue(action.result.data.catalog_id);
                form.findField("catalog").setValue(action.result.data.catalog_shortcut);
            },
            failure: function(form, action) {
                Ext.Msg.alert("Load failed", action.result.errorMessage);
            }
        });
    };

    grid.actions.removeChain = function() {
        Ext.MessageBox.confirm(_("Edition removal"), _("You really wish to do this?"), function(btn) {
            if (btn == "yes") {
                Ext.Ajax.request({
                    scope:this,
                    url: _url("/chains/delete/"),
                    params: { id: this.getCurrentChain() }
                });
            }
        }, this);
    };

    // Stages
    grid.actions.createStage = function() {
        var win = components["create-stage-window"];
        if (!win) {
            win = Inprint.exchange.CreateStagePanel();
            components["create-stage-window"] = win;
        }
        var form = win.items.first().getForm();
        form.reset();
        form.findField("chain").setValue( this.getCurrentChain() );
        win.show();
    };

    grid.actions.changeStage = function() {
        var win = components["change-stage-window"];
        if (!win) {
            win = Inprint.exchange.ChangeStagePanel();
            components["change-stage-window"] = win;
        }
        win.show();
        win.body.mask(_("Loading..."));
        var form = win.items.first().getForm();
        form.reset();
        form.load({
            url: _url("/stages/read/"),
            scope:this,
            params: {
                id: this.getCurrentStage()
            },
            success: function(form, action) {
                win.body.unmask();
            },
            failure: function(form, action) {
                Ext.Msg.alert("Load failed", action.result.errorMessage);
            }
        });
    };

    grid.actions.removeStage = function() {
        Ext.MessageBox.confirm(_("Edition removal"), _("You really wish to do this?"), function(btn) {
            if (btn == "yes") {
                Ext.Ajax.request({
                    scope:this,
                    url: _url("/stages/delete/"),
                    params: { id: this.getCurrentStage() }
                });
            }
        }, this);
    };

}
