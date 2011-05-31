Inprint.setAction("edition.create", function(tree) {

    var node = tree.selection;

    var win = new Ext.Window({
        title: _("Adding a new edition"),
        layout: "fit",
        width:400,
        height:230,
        items: form
    });

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

    form.getForm().findField("path").setValue(node.id);

    win.add(form);
    win.show();

});

Inprint.setAction("edition.update", function(tree) {

    var node = tree.selection;

    var win = new Ext.Window({
        title: _("Catalog item creation"),
        layout: "fit",
        width:400,
        height:300,
        items: form
    });

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
            {
                allowBlank:false,
                xtype: "treecombo",
                name: "edition-shortcut",
                hiddenName: "edition",
                fieldLabel: _("Edition"),
                emptyText: _("Edition") + "...",
                minListWidth: 300,
                url: _url('/common/tree/editions/'),
                root: {
                    id:'00000000-0000-0000-0000-000000000000',
                    nodeType: 'async',
                    expanded: true,
                    draggable: false,
                    icon: _ico("book"),
                    text: _("All editions")
                },
                listeners: {
                    scope: form,
                    select: function(field) {
                        field.ownerCt.getForm().findField("path").setValue(field.getValue());
                    }
                }
            }
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

    win.add(form);
    win.show();
    win.body.mask(_("Loading..."));

});

Inprint.setAction("edition.delete", function(tree) {

    var node  = tree.selection;

    Ext.MessageBox.confirm(
        _("Delete ") +" ["+ node.attributes.shortcut +"]",
        _("You really wish to do this?"),
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

});
