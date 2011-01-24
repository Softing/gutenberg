Inprint.plugins.rss.Grid = Ext.extend(Ext.grid.GridPanel, {

    initComponent: function() {

        var actions = new Inprint.documents.GridActions();
        var columns = new Inprint.documents.GridColumns();

        this.components = {};

        this.urls = {
            "list":       "/documents/list/"
        }

        this.store = Inprint.factory.Store.json(this.urls.list, {
            remoteSort: true,
            totalProperty: 'total'
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
            columns.pages,
            columns.manager,
            columns.progress,
            columns.holder,
            columns.images,
            columns.size
        ];

        //this.filter = new Inprint.plugins.rss.GridFilter({
        //    stateId: this.stateId,
        //    gridmode: "rss"
        //});
        //this.filter.on("filter", function(filter, params) {
        //    this.cmpLoad(params);
        //}, this);

        //this.tbar = {
        //    xtype    : 'container',
        //    layout   : 'anchor',
        //    height   : 27 * 2,
        //    defaults : { height : 27, anchor : '100%' },
        //    items    : [
        //        {
        //            xtype: "toolbar",
        //            items : [
        //                {
        //                    icon: _ico("plus-button"),
        //                    cls: "x-btn-text-icon",
        //                    text: _("Add"),
        //                    tooltip : _("Adding of the new document"),
        //                    disabled:true,
        //                    ref: "../../btnCreate",
        //                    scope:this,
        //                    handler: actions.Create
        //                },
        //                {
        //                    icon: _ico("pencil"),
        //                    cls: "x-btn-text-icon",
        //                    text: _("Edit"),
        //                    disabled:true,
        //                    ref: "../../btnUpdate",
        //                    scope:this,
        //                    handler: actions.Update
        //                },
        //                '-',
        //                {
        //                    icon: _ico("hand"),
        //                    cls: "x-btn-text-icon",
        //                    text: _("Capture"),
        //                    disabled:true,
        //                    ref: "../../btnCapture",
        //                    scope:this,
        //                    handler: actions.Capture
        //                },
        //                {
        //                    icon: _ico("arrow"),
        //                    cls: "x-btn-text-icon",
        //                    text: _("Transfer"),
        //                    disabled:true,
        //                    ref: "../../btnTransfer",
        //                    scope:this,
        //                    handler: actions.Transfer
        //                },
        //                '-',
        //                {
        //                    icon: _ico("blue-folder-import"),
        //                    cls: "x-btn-text-icon",
        //                    text: _("Move"),
        //                    disabled:true,
        //                    ref: "../../btnMove",
        //                    scope:this,
        //                    handler: actions.Move
        //                },
        //                {
        //                    icon: _ico("briefcase"),
        //                    cls: "x-btn-text-icon",
        //                    text: _("Briefcase"),
        //                    disabled:true,
        //                    ref: "../../btnBriefcase",
        //                    scope:this,
        //                    handler: actions.Briefcase
        //                },
        //                "-",
        //                {
        //                    icon: _ico("document-copy"),
        //                    cls: "x-btn-text-icon",
        //                    text: _("Copy"),
        //                    disabled:true,
        //                    ref: "../../btnCopy",
        //                    scope:this,
        //                    handler: actions.Copy
        //                },
        //                {
        //                    icon: _ico("documents"),
        //                    cls: "x-btn-text-icon",
        //                    text: _("Duplicate"),
        //                    disabled:true,
        //                    ref: "../../btnDuplicate",
        //                    scope:this,
        //                    handler: actions.Duplicate
        //                },
        //                "-",
        //                {
        //                    icon: _ico("bin--plus"),
        //                    cls: "x-btn-text-icon",
        //                    text: _("Recycle Bin"),
        //                    disabled:true,
        //                    ref: "../../btnRecycle",
        //                    scope:this,
        //                    handler: actions.Recycle
        //                },
        //                {
        //                    icon: _ico("bin--arrow"),
        //                    cls: "x-btn-text-icon",
        //                    text: _("Restore"),
        //                    disabled:true,
        //                    ref: "../../btnRestore",
        //                    scope:this,
        //                    handler: actions.Restore
        //                },
        //                {
        //                    icon: _ico("minus-button"),
        //                    cls: "x-btn-text-icon",
        //                    text: _("Delete"),
        //                    disabled:true,
        //                    ref: "../../btnDelete",
        //                    scope:this,
        //                    handler: actions.Delete
        //                }
        //
        //            ]
        //        },
        //        {
        //            xtype: "toolbar",
        //            items : this.filter
        //        }
        //    ]
        //};

        this.bbar = new Ext.PagingToolbar({
            pageSize: 60,
            store: this.store,
            displayInfo: true,
            displayMsg: _("Displaying documents {0} - {1} of {2}"),
            emptyMsg: _("No documents to display")
        });

        Ext.apply(this, {
            border:false,
            stripeRows: true,
            columnLines: true,
            autoExpandColumn: "title",
            stateful: true,
            stateId: 'documents.plugins.rss.list',
            viewConfig: {
                getRowClass: function(record, rowIndex, rp, ds) {

                    var css = '';

                    if (Inprint.session.member && Inprint.session.member.id == record.get("manager") ) {
                        css = 'inprint-document-grid-current-manager-bg';
                    }

                    if (record.get("workgroup") == record.get("holder")) {
                        css = 'inprint-document-grid-current-department-bg';
                    }

                    if (Inprint.session.member && Inprint.session.member.id == record.get("holder") ) {
                        css = 'inprint-document-grid-current-user-bg';
                    }

                    return css;
                }
            }
        });

        Inprint.plugins.rss.Grid.superclass.initComponent.apply(this, arguments);

    },

    onRender: function() {

        Inprint.plugins.rss.Grid.superclass.onRender.apply(this, arguments);

        //this.filter.on("restore", function(filter, params) {
        //    this.store.load({ params: Ext.apply({start:0, limit:60}, params) });
        //}, this);
        //
        //this.on("dblclick", function(e){
        //    Inprint.ObjectResolver.resolve({ aid:'document-profile', oid:this.getValue("id"), text:this.getValue("title") });
        //}, this);

    }
});
