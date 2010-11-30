Inprint.fascicle.planner.Documents = Ext.extend(Ext.grid.EditorGridPanel, {

    initComponent: function() {
        
        var actions = new Inprint.documents.GridActions();
        var columns = new Inprint.documents.GridColumns();
        
        this.urls = {
            "list":       "/documents/list/",
            "briefcase":  "/documents/briefcase/",
            "capture":    "/documents/capture/",
            "transfer":   "/documents/transfer/",
            "recycle":    "/documents/recycle/",
            "restore":    "/documents/restore/",
            "delete":     "/documents/delete/"
        }

        this.store = Inprint.factory.Store.group(this.urls.list, {
            autoLoad: true,
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
        
        this.tbar = [
            {
                ref: "../btnAdd",
                text: _("Add"),
                disabled:true,
                icon: _ico("plus-button"),
                cls: 'x-btn-text-icon',
                scope:this,
                handler : actions.Create
            },
            {
                ref: "../btnEdit",
                text: _("Edit"),
                disabled:true,
                icon: _ico("pencil"),
                cls: 'x-btn-text-icon',
                scope:this,
                handler : actions.Update
            },
            "-",
            {
                ref: "../btnToBriefcase",
                text: 'В портфель',
                disabled:true,
                icon: _ico("briefcase--arrow"),
                cls: 'x-btn-text-icon',
                scope:this,
                handler : actions.Briefcase
            },
            {
                ref: "../btnToFascicle",
                text: 'В выпуск',
                disabled:true,
                icon: _ico("newspaper--arrow"),
                cls: 'x-btn-text-icon',
                scope:this,
                handler : actions.Move
            },
            {
                ref: "../btnToTrash",
                text: 'В корзину',
                disabled:true,
                icon: _ico("bin--arrow"),
                cls: 'x-btn-text-icon',
                scope:this,
                handler : actions.Recycle
            },
            "->",
            {
                ref: "../btnBriefcase",
                text: 'Портфель',
                disabled:true,
                icon: _ico("briefcase"),
                cls: 'x-btn-text-icon',
                scope:this,
                handler : this.cmpShowBriefcase
            }
        ]
        
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
        
        Inprint.fascicle.planner.Documents.superclass.initComponent.apply(this, arguments);

    },

    onRender: function() {
        Inprint.fascicle.planner.Documents.superclass.onRender.apply(this, arguments);
        //this.on("dblclick", function(e){
        //    Inprint.ObjectResolver.resolve({ aid:'document-profile', oid:this.getValue("id"), text:this.getValue("title") });
        //}, this);
    }
});
