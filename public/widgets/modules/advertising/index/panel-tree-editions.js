Inprint.advert.index.Editions = Ext.extend(Ext.tree.TreePanel, {
    
    initComponent: function() {
        
        this.components = {};
        
        this.urls = {
            "tree":    _url("/advertising/common/places/"),
            "create":  _url("/advertising/places/create/"),
            "read":    _url("/advertising/places/read/"),
            "update":  _url("/advertising/places/update/"),
            "delete":  _url("/advertising/places/delete/")
        };
        
        Ext.apply(this, {
            title:_("Editions"),
            autoScroll:true,
            dataUrl: this.urls.tree,
            border:false,
            rootVisible: false,
            root: {
                id:'00000000-0000-0000-0000-000000000000',
                nodeType: 'async',
                expanded: true,
                draggable: false,
                icon: _ico("book"),
                text: _("Editions")
            }
        });
        
        Inprint.advert.index.Editions.superclass.initComponent.apply(this, arguments);
        
        this.on("beforeappend", function(tree, parent, node) {
            node.attributes.icon = _ico(node.attributes.icon);
        });
        
    },
    
    onRender: function() {
        
        Inprint.advert.index.Editions.superclass.onRender.apply(this, arguments);
        
        this.getRootNode().on("expand", function(node) {
            if (node.firstChild) {
                node.firstChild.select();
            }
        });
        
        this.getLoader().on("beforeload", function() { this.body.mask(_("Loading")); }, this);
        this.getLoader().on("load", function() { this.body.unmask(); }, this);
        
    },
    
    cmpCreate: function(node) {
        
        var wndw = this.components["create-window"];
        
        if (!wndw) {
            
            wndw = new Ext.Window({
                layout: "fit",
                closeAction: "hide",
                width:400, height:260,
                title: _("Catalog item creation"),
                items: {
                    border:false,
                    xtype: "form",
                    labelWidth: 75,
                    url: this.urls["create"],
                    bodyStyle: "padding:10px",
                    defaults: {
                        anchor: "100%",
                        allowBlank:false
                    },
                    listeners: {
                        scope:this,
                        actioncomplete: function() {
                            wndw.hide();
                            node.reload();
                        }
                    },
                    items: [
                        _FLD_HDN_EDITION,
                        _FLD_SHORTCUT,
                        _FLD_TITLE,
                        _FLD_DESCRIPTION
                    ],
                    keys: [ _KEY_ENTER_SUBMIT ]
                },
                buttons: [
                    _BTN_WNDW_ADD, 
                    _BTN_WNDW_CANCEL
                ]
            });
            
            this.components["create-window"] = wndw;
        }
        
        var form = wndw.findByType("form")[0].getForm();
        form.reset();
        wndw.show();
        
        form.findField("edition").setValue(node.id);
        
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
                    _FLD_TITLE,
                    _FLD_SHORTCUT,
                    _FLD_DESCRIPTION
                ],
                keys: [ _KEY_ENTER_SUBMIT ],
                buttons: [ _BTN_SAVE,_BTN_CLOSE ]
            });
            
            win = new Ext.Window({
                title: _("Creating a new module"),
                layout: "fit",
                closeAction: "hide",
                width:400, height:300,
                items: form
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
            },
            failure: function(form, action) {
                Ext.Msg.alert("Load failed", action.result.errorMessage);
            }
        });
    },
    
    cmpDelete: function(node) {
        
        var title = _("Group removal") +" <"+ node.attributes.shortcut +">";
        
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
