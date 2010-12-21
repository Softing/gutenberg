Inprint.fascicle.adverta.Documents = Ext.extend(Ext.grid.EditorGridPanel, {

    initComponent: function() {
        
        var actions = new Inprint.documents.GridActions();
        var columns = new Inprint.documents.GridColumns();
        
        this.urls = {
            "list":       "/fascicle/documents/list/",
            "briefcase":  "/documents/briefcase/",
            "capture":    "/documents/capture/",
            "transfer":   "/documents/transfer/",
            "recycle":    "/documents/recycle/",
            "restore":    "/documents/restore/",
            "delete":     "/documents/delete/"
        }

        this.store = Inprint.factory.Store.group(this.urls.list, {
            remoteSort: true,
            groupField:'headline_shortcut',
            remoteGroup:false,
            remoteSort:false,
            baseParams: {
                gridmode: "all",
                flt_fascicle: this.oid
            }
        });

        this.sm = new Ext.grid.CheckboxSelectionModel();
        
        this.columns = [
            this.sm,
            columns.viewed,
            columns.title,
            columns.edition,
            columns.workgroup,
            columns.fascicle,
            columns.headline,
            columns.rubric,
            Ext.apply(columns.pages, {
                editor: new Ext.form.TextField({
                    allowBlank: true
                })
            }),
            columns.manager,
            columns.progress,
            columns.holder,
            columns.images,
            columns.size
        ];
        //
        //this.tbar = [
        //    {
        //        ref: "../btnCreate",
        //        text: _("Add"),
        //        disabled:true,
        //        icon: _ico("plus-button"),
        //        cls: 'x-btn-text-icon',
        //        scope:this,
        //        handler : actions.Create
        //    },
        //    {
        //        ref: "../btnUpdate",
        //        text: _("Edit"),
        //        disabled:true,
        //        icon: _ico("pencil"),
        //        cls: 'x-btn-text-icon',
        //        scope:this,
        //        handler : actions.Update
        //    },
        //    '-',
        //    {
        //        icon: _ico("hand"),
        //        cls: "x-btn-text-icon",
        //        text: _("Capture"),
        //        disabled:true,
        //        ref: "../btnCapture",
        //        scope:this,
        //        handler: actions.Capture
        //    },
        //    {
        //        icon: _ico("arrow"),
        //        cls: "x-btn-text-icon",
        //        text: _("Transfer"),
        //        disabled:true,
        //        ref: "../btnTransfer",
        //        scope:this,
        //        handler: actions.Transfer
        //    },
        //    "-",
        //    {
        //        ref: "../btnBriefcase",
        //        text: 'В портфель',
        //        disabled:true,
        //        icon: _ico("briefcase--arrow"),
        //        cls: 'x-btn-text-icon',
        //        scope:this,
        //        handler : actions.Briefcase
        //    },
        //    {
        //        ref: "../btnMove",
        //        text: 'В выпуск',
        //        disabled:true,
        //        icon: _ico("newspaper--arrow"),
        //        cls: 'x-btn-text-icon',
        //        scope:this,
        //        handler : actions.Move
        //    },
        //    {
        //        ref: "../btnRecycle",
        //        text: 'В корзину',
        //        disabled:true,
        //        icon: _ico("bin--arrow"),
        //        cls: 'x-btn-text-icon',
        //        scope:this,
        //        handler : actions.Recycle
        //    },
        //    "->",
        //    {
        //        ref: "../btnFromBriefcase",
        //        text: 'Портфель',
        //        disabled:true,
        //        icon: _ico("briefcase"),
        //        cls: 'x-btn-text-icon',
        //        scope:this,
        //        handler : this.cmpShowBriefcase
        //    }
        //]
        //
        this.view = new Ext.grid.GroupingView({
            forceFit:true,
            groupTextTpl: '{text} ({[values.rs.length]} {[values.rs.length > 1 ? "Items" : "Item"]})'
        });
        
        Ext.apply(this, {
            border:false,
            stripeRows: true,
            columnLines: true,
            autoExpandColumn: "title",
            sm: this.sm,
            tbar: this.tbar,
            columns: this.columns
        });
        
        Inprint.fascicle.adverta.Documents.superclass.initComponent.apply(this, arguments);

    },

    onRender: function() {
        Inprint.fascicle.adverta.Documents.superclass.onRender.apply(this, arguments);
    },
    
    cmpShowBriefcase: function() {
        
        //if (!this.dlgShowBriefcase) {
            
            this.dlgShowBriefcase = new Ext.Window({
                title: 'Просмотр портфеля материалов',
                width: 900, height: 600,
                draggable:true,
                layout: "fit",
                items: new Inprint.fascicle.adverta.Briefcase(),
                buttons:[
                {
                    text: _("Add"),
                    scope:this,
                    handler: function() {
                        var grid = this.dlgShowBriefcase.items.first();
                        Ext.Ajax.request({
                            url: _url("/documents/move/"),
                            scope: this,
                            params: {
                                fascicle: this.oid,
                                id: grid.getValues("id")
                            },
                            success: function(response, options) {
                                this.parent.cmpReload();
                                this.dlgShowBriefcase.hide();
                            }
                        });
                    }
                },
                _BTN_WNDW_CANCEL
            ]
            });
        //}
        
        this.dlgShowBriefcase.show();
        
    }
});
