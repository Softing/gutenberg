Inprint.setAction("edition.create", {

    text: _("Create"),
    ref: "../btnCreate",
    cls: "x-btn-text-icon",
    icon: _ico("blue-folder--plus"),

    handler: function() {

        var node = this.selection;

        var form = new Ext.FormPanel({

            url: _url("/catalog/editions/create/"),

            frame:false,
            border:false,

            labelWidth: 75,
            defaults: {
                anchor: "100%",
                allowBlank:false
            },
            bodyStyle: "padding:5px 5px",
            items: [
                {
                    xtype: "titlefield",
                    value: _("Basic parameters")
                },
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
                node.reload();
            }
        }, this);

        form.getForm().reset();
        form.getForm().findField("path").setValue(node.id);

        var win = new Ext.Window({
            title: _("Adding a new edition"),
            layout: "fit",
            closeAction: "hide",
            width:400, height:350,
            items: form
        });

        win.show();
    }
});

Inprint.setAction("edition.update", {
    text: _("Edit"),
    ref: "../btnEdit",
    cls: "x-btn-text-icon",
    icon: _ico("blue-folder--pencil"),

    handler: function() {

        var node = this.selection;

        var form = new Ext.FormPanel({
            url: _url("/catalog/editions/update/"),
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
                _FLD_HDN_PATH,
                {
                    xtype: "titlefield",
                    value: _("Basic parameters")
                },
                _FLD_TITLE,
                _FLD_SHORTCUT,
                _FLD_DESCRIPTION,
                {
                    xtype: "titlefield",
                    value: _("Parent")
                },
                Inprint.factory.Combo.create("/catalog/combos/editions/", {
                    scope:this,
                    listeners: {
                        select: function(combo, record, indx) {
                            combo.ownerCt.getForm().findField("path").setValue(record.get("id"));
                        }
                    }
                }),
            ],
            keys: [ _KEY_ENTER_SUBMIT ],
            buttons: [ _BTN_SAVE,_BTN_CLOSE ]
        });

        form.on("actioncomplete", function (form, action) {
            if (action.type == "submit") {
                win.hide();
                if (node.parentNode) {
                    node.parentNode.reload();
                } else {
                    node.reload();
                }
            }
        }, this);

        form.getForm().reset();
        form.getForm().load({
            url: _url("/catalog/editions/read/"),
            scope:this,
            params: {
                id: node.id
            },
            success: function(form, action) {

                win.body.unmask();

                form.findField("id").setValue(action.result.data.id);
                form.findField("path").setValue(action.result.data.parent);
                form.findField("edition").setValue(action.result.data.parent_shortcut);

                if (action.result.data.id == '00000000-0000-0000-0000-000000000000') {
                    form.findField("edition").disable();
                } else {
                    form.findField("edition").enable();
                }

            },
            failure: function(form, action) {
                Ext.Msg.alert("Load failed", action.result.errorMessage);
            }
        });

        var win = new Ext.Window({
            title: _("Catalog item creation"),
            layout: "fit",
            closeAction: "hide",
            width:400, height:400,
            items: form
        });
        win.show();
        win.body.mask(_("Loading..."));
    }
});

Inprint.setAction("edition.delete", {
    text: _("Remove"),
    ref: "../btnRemove",
    cls: "x-btn-text-icon",
    icon: _ico("blue-folder--minus"),
    handler: function() {

        var node  = this.selection;
        var title = _("Delete ") +" ["+ node.attributes.shortcut +"]";
        var descr = _("You really wish to do this?");

        Ext.MessageBox.confirm(
            title,
            descr,
            function(btn) {
                if (btn == "yes") {
                    Ext.Ajax.request({
                        url: _url("/catalog/editions/delete/"),
                        scope:this,
                        success: function() {
                            node.parentNode.reload();
                        },
                        params: { id: node.id }
                    });
                }
            }, this).setIcon(Ext.MessageBox.WARNING);
    }
});

Inprint.setAction("stages.principals", {

    icon: _ico("users"),
    cls: "x-btn-text-icon",
    text: _("Select employees"),
    ref: "../btnManagePrincipals",

    handler: function() {

        var grid = this;

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

    }
});

Inprint.setAction("stages.create", {

    text: _("Add"),
    icon: _ico("plus-button"),
    cls: "x-btn-text-icon",
    ref: "../btnCreateStage",

    handler: function() {
//            win = Inprint.catalog.editions.CreateStagePanel();
//            win.on("actioncomplete", function (form, action) {
//                if (action.type == "submit") {
//                    win.hide();
//                    grid.cmpReload();
//                }
//            });
//            components["create-stage-window"] = win;
//
//        var form = win.items.first().getForm();
//        form.reset();
//
//        form.findField("branch").setValue(tree.cmpCurrentNode().id);
//
//        win.show();
    }
});

Inprint.setAction("stages.update", {

    text: _("Change"),
    icon: _ico("pencil"),
    cls: "x-btn-text-icon",
    ref: "../btnChangeStage",

    handler: function() {
//        var win = components["change-stage-window"];
//        if (!win) {
//            win = Inprint.catalog.editions.ChangeStagePanel();
//            win.on("actioncomplete", function (form, action) {
//                if (action.type == "submit") {
//                    win.hide();
//                    grid.cmpReload();
//                }
//            });
//            components["change-stage-window"] = win;
//        }
//        win.show();
//        win.body.mask(_("Loading..."));
//        var form = win.items.first().getForm();
//        form.reset();
//
//        form.load({
//            scope:this,
//            url: _url("/catalog/stages/read/"),
//            params: { id: grid.getValue("id") },
//            success: function(form, action) {
//                win.body.unmask();
//            },
//            failure: function(form, action) {
//                Ext.Msg.alert("Load failed", action.result.errorMessage);
//            }
//        });
    }
});

Inprint.setAction("stages.delete", {

    text: _("Remove"),
    cls: "x-btn-text-icon",
    icon: _ico("minus-button"),
    ref: "../btnRemoveStage",

    handler: function() {
//        Ext.MessageBox.confirm(_("Edition removal"), _("You really wish to do this?"), function(btn) {
//            if (btn == "yes") {
//                Ext.Ajax.request({
//                    scope:this,
//                    url: _url("/catalog/stages/delete/"),
//                    params: { id: grid.getValues("id") },
//                    success: function(form, action) {
//                        grid.cmpReload();
//                    }
//                });
//            }
//        }, this);
    }
});

//Inprint.catalog.editions.Actions = function(parent, panels) {
//
//    var tree = panels.tree;
//    var grid = panels.grid;
//
//    var components = {};
//    grid.actions = {};
//
//    // Stages
//    grid.actions.createStage = function() {
//        var win = components["create-stage-window"];
//        if (!win) {
//            win = Inprint.catalog.editions.CreateStagePanel();
//            win.on("actioncomplete", function (form, action) {
//                if (action.type == "submit") {
//                    win.hide();
//                    grid.cmpReload();
//                }
//            });
//            components["create-stage-window"] = win;
//        }
//        var form = win.items.first().getForm();
//        form.reset();
//
//        form.findField("branch").setValue(tree.cmpCurrentNode().id);
//
//        win.show();
//    };
//
//    grid.actions.changeStage = function() {
//
//        var win = components["change-stage-window"];
//        if (!win) {
//            win = Inprint.catalog.editions.ChangeStagePanel();
//            win.on("actioncomplete", function (form, action) {
//                if (action.type == "submit") {
//                    win.hide();
//                    grid.cmpReload();
//                }
//            });
//            components["change-stage-window"] = win;
//        }
//        win.show();
//        win.body.mask(_("Loading..."));
//        var form = win.items.first().getForm();
//        form.reset();
//
//        form.load({
//            scope:this,
//            url: _url("/catalog/stages/read/"),
//            params: { id: grid.getValue("id") },
//            success: function(form, action) {
//                win.body.unmask();
//            },
//            failure: function(form, action) {
//                Ext.Msg.alert("Load failed", action.result.errorMessage);
//            }
//        });
//
//
//    };
//
//    grid.actions.removeStage = function() {
//        Ext.MessageBox.confirm(_("Edition removal"), _("You really wish to do this?"), function(btn) {
//            if (btn == "yes") {
//                Ext.Ajax.request({
//                    scope:this,
//                    url: _url("/catalog/stages/delete/"),
//                    params: { id: grid.getValues("id") },
//                    success: function(form, action) {
//                        grid.cmpReload();
//                    }
//                });
//            }
//        }, this);
//    };
//
//    grid.actions.managePrincipals = function() {
//
//        win = new Inprint.cmp.PrincipalsSelector({
//            urlLoad: "/catalog/stages/principals-mapping/",
//            urlDelete: "/catalog/stages/unmap-principals/"
//        });
//
//        win.on("show", function(win) {
//            win.panels.selection.cmpLoad({
//                stage: grid.getValue("id")
//            });
//        });
//
//        win.on("close", function(win) {
//            grid.cmpReload();
//        });
//
//        win.on("save", function(srcgrid, catalog, ids) {
//            Ext.Ajax.request({
//                url: "/catalog/stages/map-principals/",
//                params: {
//                    stage: grid.getValue("id"),
//                    catalog: catalog,
//                    principals: ids
//                },
//                success: function() {
//                    srcgrid.cmpReload();
//                }
//            });
//        });
//
//        win.on("delete", function(srcgrid, ids) {
//            Ext.Ajax.request({
//                url: "/catalog/stages/unmap-principals/",
//                params: {
//                    principals: ids
//                },
//                success: function() {
//                    srcgrid.cmpReload();
//                }
//            });
//        });
//
//        win.show();
//    };
//
//};
