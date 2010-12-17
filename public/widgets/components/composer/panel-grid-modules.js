Inprint.cmp.composer.Modules = Ext.extend(Ext.grid.GridPanel, {

    initComponent: function() {
        
        this.pageId = null;
        this.pageW  = null;
        this.pageH  = null;
        
        this.params = {};
        this.components = {};
        
        this.urls = {
            "list":        "/fascicle/modules/list/",
            "create": _url("/fascicle/modules/create/"),
            "delete": _url("/fascicle/modules/delete/")
        }

        this.store = Inprint.factory.Store.json(this.urls["list"], {
            autoLoad:true,
            baseParams: {
                page: this.parent.selection
            }
        });
        
        this.selectionModel = new Ext.grid.CheckboxSelectionModel();
        
        this.columns = [
            this.selectionModel,
            {
                id:"title",
                header: _("Title"),
                width: 150,
                sortable: true,
                dataIndex: "title"
            },
            {
                id:"shortcut",
                header: _("Shortcut"),
                width: 150,
                sortable: true,
                dataIndex: "shortcut"
            },
            {
                id:"description",
                header: _("Description"),
                sortable: true,
                dataIndex: "description"
            },
            {
                id:"amount",
                header: _("Amount"),
                sortable: true,
                dataIndex: "amount"
            },
            {
                id:"area",
                header: _("Area"),
                sortable: true,
                dataIndex: "area"
            },
            {
                id:"x",
                header: _("X"),
                sortable: true,
                dataIndex: "x"
            },
            {
                id:"y",
                header: _("Y"),
                sortable: true,
                dataIndex: "y"
            },
            {
                id:"w",
                header: _("W"),
                sortable: true,
                dataIndex: "w"
            },
            {
                id:"h",
                header: _("H"),
                sortable: true,
                dataIndex: "h"
            }
        ];
        
        this.tbar = [
            {
                disabled:false,
                icon: _ico("plus-button"),
                cls: "x-btn-text-icon",
                text: _("Add"),
                ref: "../btnCreate",
                scope:this,
                handler: this.cmpCreate
            },
            {
                disabled:false,
                icon: _ico("disk-black"),
                cls: "x-btn-text-icon",
                text: _("Save"),
                ref: "../btnSave",
                scope:this,
                handler: function() {
                    this.parent.panels["flash"].cmpSave();
                }
            },
            '-',
            {
                disabled:true,
                icon: _ico("minus-button"),
                cls: "x-btn-text-icon",
                text: _("Remove"),
                ref: "../btnDelete",
                scope:this,
                handler: this.cmpDelete
            }
        ];
        
        Ext.apply(this, {
            
            region: "center",
            margins: "3 0 3 3",
            layout:"fit",
            
            //border:false,
            stripeRows: true,
            columnLines: true,
            sm: this.selectionModel
            //autoExpandColumn: "description"
        });

        Inprint.cmp.composer.Modules.superclass.initComponent.apply(this, arguments);

    },

    onRender: function() {
        Inprint.cmp.composer.Modules.superclass.onRender.apply(this, arguments);
    },
    
    
    cmpCreate: function() {
        
        var win = this.components["create-window"];
        
        if (!win) {
            
            var grid = new Inprint.cmp.composer.GridTemplates({
                parent: this.parent
            });
            
            win = new Ext.Window({
                width:700,
                height:500,
                modal:true,
                layout: "fit",
                closeAction: "hide",
                title: _("Adding a new category"),
                items: grid,
                buttons: [
                    {
                        text: _("Add"),
                        scope:this,
                        handler: function() {
                            Ext.Ajax.request({
                                url: this.urls["create"],
                                scope:this,
                                success: function() {
                                    this.components["create-window"].hide();
                                    this.cmpReload();
                                },
                                params: {
                                    fascicle: this.parent.fascicle,
                                    page: this.parent.selection,
                                    module: grid.getValues("id")
                                }
                            });
                        }
                    },
                    _BTN_WNDW_CLOSE
                ]
                
            });
            
        }
        
        win.show(this);
        this.components["create-window"] = win;
    },
    
    cmpDelete: function() {
        Ext.MessageBox.confirm(
            _("Warning"),
            _("You really wish to do this?"),
            function(btn) {
                if (btn == "yes") {
                    Ext.Ajax.request({
                        url: this.urls["delete"],
                        scope:this,
                        success: this.cmpReload,
                        params: { id: this.getValues("id") }
                    });
                }
            }, this).setIcon(Ext.MessageBox.WARNING);
    }

});
