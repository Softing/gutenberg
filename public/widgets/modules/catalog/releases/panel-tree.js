Inprint.catalog.releases.Tree = Ext.extend(Ext.tree.TreePanel, {

    initComponent: function() {

        this.components = {};

        this.urls = {
            tree:    _url("/catalog/tree/"),
            create:  _url("/catalog/create/"),
            read:    _url("/catalog/read/"),
            update:  _url("/catalog/update/"),
            delete:  _url("/catalog/delete/")
        };

        Ext.apply(this, {
            autoScroll:true,
            dataUrl: this.urls.tree,
            border:false,

            // DD
            enableDD:true,
            ddGroup:'member2catalog',

            root: {
                id:'00000000-0000-0000-0000-000000000000',
                nodeType: 'async',
                expanded: true,
                draggable: false,
                icon: _ico("newspapers"),
                text: _("Publishing House")
            }
        });

        Inprint.catalog.releases.Tree.superclass.initComponent.apply(this, arguments);

        this.on("beforeappend", function(tree, parent, node) {

            if (node.attributes.icon == undefined) {
                node.attributes.icon = 'folder-open';
            }

            node.attributes.icon = _ico(node.attributes.icon);

            if (node.attributes.color) {
                node.text = "<span style=\"color:#"+ node.attributes.color +"\">" + node.attributes.text + "</span>";
            }

        });

    },

    onRender: function() {

        Inprint.catalog.releases.Tree.superclass.onRender.apply(this, arguments);

        this.on("beforeload", function() {
            this.body.mask(_("Please wait..."));
        });

        this.on("load", function() {
            this.body.unmask();
        });

        this.getRootNode().on("expand", function(node) {
            node.select();
        });

    },

    cmpCreate: function() {

        var win = this.components["add-window"];
        if (!win) {

            var form = new Ext.FormPanel({

                url: this.urls.create,

                frame:false,
                border:false,

                labelWidth: 75,
                defaults: {
                    anchor: "100%",
                    allowBlank:false
                },
                bodyStyle: "padding:5px 5px",
                items: [
                    _FLD_HDN_PATH,
                    _FLD_TITLE,
                    _FLD_SHORTCUT,
                    _FLD_DESCRIPTION,
                    Inprint.factory.Combo.create("/catalog/combos/groups/", {
                        scope:this,
                        listeners: {
                            select: function(combo, record, indx) {
                                combo.ownerCt.getForm().findField("path").setValue(record.get("id"));
                            }
                        }
                    }),
                    {
                        xtype: 'checkboxgroup',
                        fieldLabel: 'Capables',
                        itemCls: 'x-check-group-alt',
                        allowBlank: true,
                        columns: 1,
                        items: [
                            {boxLabel: _("Можно хранить выпуски"), name: 'capable-store'},
                            {boxLabel: _("Можно хранить материалы"), name: 'capable-exchange'}
                        ]
                    }
                ],
                keys: [ _KEY_ENTER_SUBMIT ],
                buttons: [ _BTN_SAVE,_BTN_CLOSE ]
            });

            win = new Ext.Window({
                title: _("Catalog item creation"),
                layout: "fit",
                closeAction: "hide",
                width:400, height:300,
                items: form
            });

            form.on("actioncomplete", function (form, action) {
                if (action.type == "submit")
                    win.hide();
            });
        }

        var form = win.items.first().getForm();
        form.reset();

        win.show(this);
        this.components["add-window"] = win;
    },

    cmpUpdate: function() {

        var win = this.components["edit-window"];

        if (!win) {

            var form = new Ext.FormPanel({
                url: this.urls.update,
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
                    _FLD_TITLE,
                    _FLD_SHORTCUT,
                    _FLD_DESCRIPTION,
                    Inprint.factory.Combo.create("/catalog/combos/groups/", {
                        scope:this,
                        listeners: {
                            select: function(combo, record, indx) {
                                combo.ownerCt.getForm().findField("path").setValue(record.get("id"));
                            }
                        }
                    }),
                    {
                        xtype: 'checkboxgroup',
                        fieldLabel: 'Capables',
                        itemCls: 'x-check-group-alt',
                        allowBlank: true,
                        columns: 1,
                        items: [
                            {boxLabel: _("Можно хранить выпуски"), name: 'capable-store'},
                            {boxLabel: _("Можно хранить материалы"), name: 'capable-exchange'}
                        ]
                    }
                ],
                keys: [ _KEY_ENTER_SUBMIT ],
                buttons: [ _BTN_SAVE,_BTN_CLOSE ]
            });

            win = new Ext.Window({
                title: _("Catalog item creation"),
                layout: "fit",
                closeAction: "hide",
                width:400, height:300,
                items: form
            });

            form.on("actioncomplete", function (form, action) {
                if (action.type == "submit")
                    win.hide();
            });
        }

        win.show(this);
        win.body.mask(_("Loading..."));
        this.components["edit-window"] = win;

        var form = win.items.first().getForm();
        form.reset();

        form.load({
            url: this.urls.read,
            scope:this,
            params: {
                id: this.getSelectionModel().getSelectedNode().attributes.id
            },
            success: function(form, action) {

                win.body.unmask();

                form.findField("id").setValue(action.result.data.id);
                form.findField("path").setValue(action.result.data.parent);
                form.findField("catalog").setValue(action.result.data.parent_shortcut);

                if (action.result.data.id == '00000000-0000-0000-0000-000000000000') {
                    form.findField("catalog").disable();
                } else {
                    form.findField("catalog").enable();
                }

            },
            failure: function(form, action) {
                Ext.Msg.alert("Load failed", action.result.errorMessage);
            }
        });
    },

    cmpDelete: function() {

        var title = _("Group removal")+
            " <"+ this.getSelectionModel().getSelectedNode().attributes.shortcut +">"

        Ext.MessageBox.confirm(
            title,
            _("You really wish to do this?"),
            function(btn) {
                if (btn == "yes") {
                    Ext.Ajax.request({
                        url: this.urls.delete,
                        scope:this,
                        success: this.cmpReload,
                        params: { id: this.getSelectionModel().getSelectedNode().attributes.id }
                    });
                }
            }, this).setIcon(Ext.MessageBox.WARNING);
    }

});
