Inprint.catalog.indexes.TreeHeadlines = Ext.extend(Ext.tree.TreePanel, {

    initComponent: function() {

        this.components = {};

        this.urls = {
            "tree":    _url("/catalog/headlines/tree/"),
            "create":  _url("/catalog/headlines/create/"),
            "read":    _url("/catalog/headlines/read/"),
            "update":  _url("/catalog/headlines/update/"),
            "delete":  _url("/catalog/headlines/delete/")
        };

        Ext.apply(this, {
            title:_("Headlines"),
            autoScroll:true,
            dataUrl: this.urls.tree,
            border:false,
            rootVisible: false,
            root: {
                id:'00000000-0000-0000-0000-000000000000',
                nodeType: 'async',
                draggable: false
            }
        });

        Inprint.catalog.indexes.TreeHeadlines.superclass.initComponent.apply(this, arguments);

        this.on("beforeappend", function(tree, parent, node) {
            node.attributes.icon = _ico(node.attributes.icon);
        });

    },

    onRender: function() {

        Inprint.catalog.indexes.TreeHeadlines.superclass.onRender.apply(this, arguments);

        this.getLoader().on("beforeload", function() { this.body.mask(_("Loading")); }, this);
        this.getLoader().on("load", function() { this.body.unmask(); }, this);

    },

    cmpCreate: function(node) {

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
                    _FLD_HDN_EDITION,
                    {
                        xtype: "titlefield",
                        value: _("Basic options")
                    },
                    _FLD_TITLE,
                    _FLD_DESCRIPTION,
                    {
                        xtype: "titlefield",
                        value: _("More options")
                    },
                    {
                        xtype: 'checkbox',
                        fieldLabel: _(""),
                        labelSeparator: '',
                        boxLabel: _("Use by default"),
                        name: 'bydefault',
                        checked: false
                    }
                ],
                keys: [ _KEY_ENTER_SUBMIT ],
                buttons: [ _BTN_ADD,_BTN_CLOSE ]
            });

            win = new Ext.Window({
                title: _("Adding a new headline"),
                layout: "fit",
                closeAction: "hide",
                width:400, height:260,
                items: form
            });

            form.on("actioncomplete", function (form, action) {
                if (action.type == "submit") {
                    win.hide();
                    node.parentNode.reload();
                }
            }, this);

        }

        var form = win.items.first().getForm();
        form.reset();

        form.findField("edition").setValue(this.currentEdition);

        win.show(this);
        this.components["add-window"] = win;
    },

    cmpUpdate: function(node) {

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
                    {
                        xtype: "titlefield",
                        value: _("Basic options")
                    },
                    _FLD_TITLE,
                    _FLD_DESCRIPTION,
                    {
                        xtype: "titlefield",
                        value: _("More options")
                    },
                    {
                        xtype: 'checkbox',
                        fieldLabel: _(""),
                        labelSeparator: '',
                        boxLabel: _("Use by default"),
                        name: 'bydefault',
                        checked: false
                    }
                ],
                keys: [ _KEY_ENTER_SUBMIT ],
                buttons: [ _BTN_SAVE,_BTN_CLOSE ]
            });

            win = new Ext.Window({
                title: _("Edit headline"),
                layout: "fit",
                closeAction: "hide",
                width:400, height:260,
                items: form
            });

            form.on("actioncomplete", function (form, action) {
                if (action.type == "submit") {
                    win.hide();
                    if (node.parentNode) {
                        node.parentNode.reload();
                    } else if (node.reload) {
                        node.reload();
                    }
                }
            }, this);
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
                id: node.id
            },
            success: function(form, action) {
                win.body.unmask();
                form.findField("id").setValue(action.result.data.id);
            }
        });
    },

    cmpDelete: function(node) {

        var title = _("Group removal") +" <"+ node.attributes.title +">";

        Ext.MessageBox.confirm(
            title,
            _("You really wish to do this?"),
            function(btn) {
                if (btn == "yes") {
                    Ext.Ajax.request({
                        url: this.urls["delete"],
                        scope:this,
                        success: function() {
                            node.parentNode.reload();
                        },
                        params: { id: node.attributes.id }
                    });
                }
            }, this).setIcon(Ext.MessageBox.WARNING);
    }


});
