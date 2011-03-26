// Inprint Content 5.0
// Copyright(c) 2001-2011, Softing, LLC.
// licensing@softing.ru
// http://softing.ru/license

Inprint.documents.Grid = Ext.extend(Inprint.grid.GridPanel, {

    initComponent: function() {

        var store = Inprint.factory.Store.array( "/documents/array/" , {
            remoteSort: true,
            totalProperty: 'total',
            baseParams: { gridmode: this.gridmode }
        });

        var sm      = new Ext.grid.CheckboxSelectionModel();
        var actions = new Inprint.documents.GridActions();
        var columns = new Inprint.documents.GridColumns();

        var colModel = new Ext.grid.ColumnModel({
            defaults: {
                sortable: true,
                menuDisabled: true
            },
            columns: [
                sm,
                columns.viewed,
                columns.title,
                columns.edition,
                columns.maingroup,
                columns.manager,
                columns.workgroup,
                columns.fascicle,
                columns.headline,
                columns.rubric,
                columns.pages,
                columns.progress,
                columns.holder,
                columns.images,
                columns.size,
                columns.created,
                columns.updated,
                columns.uploaded,
                columns.moved
            ]
        });

        var filter = new Inprint.documents.GridFilter({
            stateId: this.stateId,
            gridmode: this.gridmode
        });

        var tbar = {
            xtype    : 'container',
            layout   : 'anchor',
            height   : 28 +25,
            defaults : { anchor : '100%' },
            items    : [
                {
                    xtype: "toolbar",
                    height: 28,
                    items : [
                        {
                            icon: _ico("plus-button"),
                            cls: "x-btn-text-icon",
                            text: _("Add"),
                            tooltip : _("Adding of the new document"),
                            disabled:true,
                            ref: "../../btnCreate",
                            scope:this,
                            handler: actions.Create
                        },
                        {
                            icon: _ico("card--pencil"),
                            cls: "x-btn-text-icon",
                            text: _("Properties"),
                            disabled:true,
                            ref: "../../btnUpdate",
                            scope:this,
                            handler: actions.Update
                        },
                        '-',
                        {
                            icon: _ico("hand"),
                            cls: "x-btn-text-icon",
                            text: _("Capture"),
                            disabled:true,
                            ref: "../../btnCapture",
                            scope:this,
                            handler: actions.Capture
                        },
                        {
                            icon: _ico("arrow"),
                            cls: "x-btn-text-icon",
                            text: _("Transfer"),
                            disabled:true,
                            ref: "../../btnTransfer",
                            scope:this,
                            handler: actions.Transfer
                        },
                        '-',
                        {
                            icon: _ico("blue-folder-import"),
                            cls: "x-btn-text-icon",
                            text: _("Move"),
                            disabled:true,
                            ref: "../../btnMove",
                            scope:this,
                            handler: actions.Move
                        },
                        {
                            icon: _ico("briefcase"),
                            cls: "x-btn-text-icon",
                            text: _("Briefcase"),
                            disabled:true,
                            ref: "../../btnBriefcase",
                            scope:this,
                            handler: actions.Briefcase
                        },
                        "-",
                        {
                            icon: _ico("document-copy"),
                            cls: "x-btn-text-icon",
                            text: _("Copy"),
                            disabled:true,
                            ref: "../../btnCopy",
                            scope:this,
                            handler: actions.Copy
                        },
                        {
                            icon: _ico("documents"),
                            cls: "x-btn-text-icon",
                            text: _("Duplicate"),
                            disabled:true,
                            ref: "../../btnDuplicate",
                            scope:this,
                            handler: actions.Duplicate
                        },
                        "-",
                        {
                            icon: _ico("bin--plus"),
                            cls: "x-btn-text-icon",
                            text: _("Recycle Bin"),
                            disabled:true,
                            ref: "../../btnRecycle",
                            scope:this,
                            handler: actions.Recycle
                        },
                        {
                            icon: _ico("bin--arrow"),
                            cls: "x-btn-text-icon",
                            text: _("Restore"),
                            disabled:true,
                            ref: "../../btnRestore",
                            scope:this,
                            handler: actions.Restore
                        },
                        {
                            icon: _ico("minus-button"),
                            cls: "x-btn-text-icon",
                            text: _("Delete"),
                            disabled:true,
                            ref: "../../btnDelete",
                            scope:this,
                            handler: actions.Delete
                        }
                    ]
                },
                {
                    xtype: "toolbar",
                    height : 25,
                    items : filter
                }
            ]
        };

        var bbar = new Ext.PagingToolbar({
            pageSize: 60,
            store: store,
            displayInfo: true,
            displayMsg: _("Displaying documents {0} - {1} of {2}"),
            emptyMsg: _("No documents to display")
        });

        Ext.apply(this, {

            sm: sm,
            store: store,
            colModel: colModel,

            tbar: tbar,
            bbar: bbar,

            autoExpandColumn: "title",

            viewConfig: {

                deferEmptyText  : false,
                emptyText: _("Suitable data is not found"),

                getRowClass: function(record, rowIndex, rp, ds) {

                    var css = "";

                    if (Inprint.session.member && Inprint.session.member.id == record.get("manager") ) {
                        css = "inprint-grid-yellow-bg";
                    }

                    if (record.get("workgroup") == record.get("holder")) {
                        css = "inprint-grid-yellow-bg";
                    }

                    if (Inprint.session.member && Inprint.session.member.id == record.get("holder") ) {
                        css = "inprint-grid-green-bg";
                    }

                    return css;
                }

            }

        });

        this.filter = filter;

        Inprint.documents.Grid.superclass.initComponent.apply(this, arguments);

    },

    onRender: function() {

        Inprint.documents.Grid.superclass.onRender.apply(this, arguments);

        this.filter.on("filter", function(filter, params) {
            this.cmpLoad(params);
        }, this);

        this.filter.on("restore", function(filter, params) {
            this.cmpLoad({ params: Ext.apply({start:0, limit:60}, params) }, true);
        }, this);

        this.on("dblclick", function(e){
            Inprint.ObjectResolver.resolve({ aid:'document-profile', oid:this.getValue("id"), text:this.getValue("title") });
        }, this);

    }
});
