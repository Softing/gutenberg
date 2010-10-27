Inprint.documents.Grid = Ext.extend(Ext.grid.GridPanel, {

    initComponent: function() {

        this.components = {};

        this.urls = {
            "list":       "/documents/list/",
            "briefcase":  "/documents/briefcase/",
            "capture":    "/documents/capture/",
            "transfer":   "/documents/transfer/",
            "recycle":    "/documents/recycle/",
            "restore":    "/documents/restore/",
            "delete":     "/documents/delete/"
        }

        this.store = Inprint.factory.Store.json(this.urls.list, {
            remoteSort: true,
            totalProperty: 'total',
            baseParams: {
                gridmode: this.gridmode
            }
        });

        this.sm = new Ext.grid.CheckboxSelectionModel();

        this.columns = [
            this.sm,
            {
                id : 'viewed',
                fixed : true,
                menuDisabled : true,
                header : '&nbsp;',
                width : 26,
                sortable : true,
                renderer : this.renderers.viewed
            },
            {
                id:"title",
                dataIndex: "title",
                header: _("Title"),
                width: 210,
                sortable: true,
                renderer : this.renderers.title
            },
            {
                id:"edition",
                dataIndex: "edition_shortcut",
                header: _("Edition"),
                width: 50,
                sortable: true
            },
            {
                id:"fascicle",
                dataIndex: "fascicle_shortcut",
                header: _("Fascicle"),
                width: 90,
                sortable: true,
                renderer : this.renderers.fascicle
            },
            {
                id:"headline",
                dataIndex: "headline_shortcut",
                header: _("Headline"),
                width: 100,
                sortable: true
            },
            {
                id:"rubric",
                dataIndex: "rubric_shortcut",
                header: _("Rubric"),
                width: 100,
                sortable: true
            },
            {
                id:"pages",
                dataIndex: "pages",
                header: _("Pages"),
                width: 50,
                sortable: true
            },


            {
                id:"manager",
                dataIndex: "manager_shortcut",
                header: _("Manager"),
                width: 100,
                sortable: true
            },
            {
                id:"progress",
                dataIndex: "progress",
                header: _("Progress"),
                sortable: true,
                width: 80,
                renderer : this.renderers.progress
            },
            {
                id:"workgroup",
                dataIndex: "workgroup_shortcut",
                header: _("Group"),
                width: 90,
                sortable: true
            },
            {
                id:"holder",
                dataIndex: "holder_shortcut",
                header: _("Holder"),
                width: 100,
                sortable: true
            },
            {
                id:"images",
                dataIndex: "images",
                header : '<img src="'+ _ico("camera") +'">',
                width:30,
                sortable: true
            },
            {
                id:"size",
                dataIndex: "rsize",
                header : '<img src="'+ _ico("edit") +'">',
                width:40,
                sortable: true,
                renderer : this.renderers.size
            }

        ];

        this.filter = new Inprint.documents.GridFilter({
            stateId: this.stateId,
            gridmode: this.gridmode
        });

        this.filter.on("filter", function(filter, params) {
            this.cmpLoad(params);
        }, this);

        this.tbar = {
            xtype    : 'container',
            layout   : 'anchor',
            height   : 27 * 2,
            defaults : { height : 27, anchor : '100%' },
            items    : [
                {
                    xtype: "toolbar",
                    items : [
                        {
                            icon: _ico("plus-button"),
                            cls: "x-btn-text-icon",
                            text: _("Add"),
                            tooltip : _("Adding of the new document"),
                            disabled:true,
                            ref: "../../btnCreate",
                            scope:this,
                            handler: this.cmpCreate
                        },
                        {
                            icon: _ico("pencil"),
                            cls: "x-btn-text-icon",
                            text: _("Edit"),
                            disabled:true,
                            ref: "../../btnUpdate",
                            scope:this,
                            handler: this.cmpUpdate
                        },
                        '-',
                        {
                            icon: _ico("hand"),
                            cls: "x-btn-text-icon",
                            text: _("Capture"),
                            disabled:true,
                            ref: "../../btnCapture",
                            scope:this,
                            handler: this.cmpCapture
                        },
                        {
                            icon: _ico("arrow"),
                            cls: "x-btn-text-icon",
                            text: _("Transfer"),
                            disabled:true,
                            ref: "../../btnTransfer",
                            scope:this,
                            handler: this.cmpTransfer
                        },
                        '-',
                        {
                            icon: _ico("blue-folder-import"),
                            cls: "x-btn-text-icon",
                            text: _("Move"),
                            disabled:true,
                            ref: "../../btnMove",
                            scope:this,
                            handler: this.cmpMove
                        },
                        {
                            icon: _ico("briefcase"),
                            cls: "x-btn-text-icon",
                            text: _("Briefcase"),
                            disabled:true,
                            ref: "../../btnBriefcase",
                            scope:this,
                            handler: this.cmpBriefcase
                        },
                        "-",
                        {
                            icon: _ico("document-copy"),
                            cls: "x-btn-text-icon",
                            text: _("Copy"),
                            disabled:true,
                            ref: "../../btnCopy",
                            scope:this,
                            handler: this.cmpCopy
                        },
                        {
                            icon: _ico("documents"),
                            cls: "x-btn-text-icon",
                            text: _("Duplicate"),
                            disabled:true,
                            ref: "../../btnDuplicate",
                            scope:this,
                            handler: this.cmpDuplicate
                        },
                        "-",
                        {
                            icon: _ico("bin--plus"),
                            cls: "x-btn-text-icon",
                            text: _("Recycle Bin"),
                            disabled:true,
                            ref: "../../btnRecycle",
                            scope:this,
                            handler: this.cmpRecycle
                        },
                        {
                            icon: _ico("bin--arrow"),
                            cls: "x-btn-text-icon",
                            text: _("Restore"),
                            disabled:true,
                            ref: "../../btnRestore",
                            scope:this,
                            handler: this.cmpRestore
                        },
                        {
                            icon: _ico("minus-button"),
                            cls: "x-btn-text-icon",
                            text: _("Delete"),
                            disabled:true,
                            ref: "../../btnDelete",
                            scope:this,
                            handler: this.cmpDelete
                        }

                    ]
                },
                {
                    xtype: "toolbar",
                    items : this.filter
                }
            ]
        };

        this.bbar = new Ext.PagingToolbar({
            pageSize: 60,
            store: this.store,
            displayInfo: true,
            displayMsg: _("Displaying documents {0} - {1} of {2}"),
            emptyMsg: _("No documents to display"),
            items:[
                '-',
                {
                    xtype:'slider',
                    stateful: true,
                    stateId: 'documents.grid.slider',
                    width: 214,
                    value:60,
                    increment: 30,
                    minValue: 60,
                    maxValue: 120,
                    listeners: {
                        scope:this,
                        statesave: function (field, state) {
                            alert(state);
                        },
                        changecomplete: function(field, value) {
                            this.store.load({params:{start:0, limit:value}});
                        }
                    }
                }
            ]
        });

        Ext.apply(this, {
            border:false,
            stripeRows: true,
            columnLines: true,
            autoExpandColumn: "title",
            sm: this.sm,
            tbar: this.tbar,
            columns: this.columns,
            bbar: this.bbar
        });

        Inprint.documents.Grid.superclass.initComponent.apply(this, arguments);

    },

    onRender: function() {

        Inprint.documents.Grid.superclass.onRender.apply(this, arguments);

        this.filter.on("restore", function(filter, params) {
            this.store.load({ params: Ext.apply({start:0, limit:60}, params) });
        }, this);

        this.on("dblclick", function(e){
            Inprint.ObjectResolver.resolve({ aid:'document-profile', oid:this.getValue("id"), text:this.getValue("title") });
        }, this);

    },

    // Grid buttons

    cmpCreate: function() {
        var panel = new Inprint.cmp.CreateDocument();
        panel.show();
        panel.on("complete", function() { this.cmpReload(); }, this);
    },

    cmpUpdate: function() {
        var panel = new Inprint.cmp.UpdateDocument({
            document: this.getValue("id")
        });
        panel.show();
        panel.on("complete", function() { this.cmpReload(); }, this);
    },

    cmpCapture: function() {
        Ext.MessageBox.confirm(
            _("Document capture"),
            _("You really want to do this?"),
            function(btn) {
                if (btn == "yes") {
                    Ext.Ajax.request({
                        url: this.urls.capture,
                        scope:this,
                        success: this.cmpReload,
                        params: { id: this.getValues("id") }
                    });
                }
            }, this).setIcon(Ext.MessageBox.WARNING);
    },

    cmpTransfer: function() {
        var panel = new Inprint.cmp.ExcahngeBrowser().show();
        panel.on("complete", function(id){
            Ext.Ajax.request({
                url: this.urls.transfer,
                scope:this,
                success: this.cmpReload,
                params: { id: this.getValues("id"), transfer: id }
            });
        }, this);
    },

    cmpBriefcase: function() {
        Ext.MessageBox.confirm(
            _("Moving to the briefcase"),
            _("You really want to do this?"),
            function(btn) {
                if (btn == "yes") {
                    Ext.Ajax.request({
                        url: this.urls.briefcase,
                        scope:this,
                        success: this.cmpReload,
                        params: {
                            id: this.getValues("id")
                        }
                    });
                }
            }, this).setIcon(Ext.MessageBox.WARNING);
    },

    cmpMove: function() {
        var record = this.getRecord();
        var cmp = new Inprint.cmp.MoveDocument({
            initialValues: {
                edition:  record.get("edition"),
                fascicle: record.get("fascicle"),
                headline: record.get("headline"),
                rubric: record.get("rubric")
            }
        });
        cmp.show();
    },

    cmpCopy: function() {
        new Inprint.cmp.CopyDocument().show();
    },

    cmpDuplicate: function() {
        new Inprint.cmp.DuplicateDocument().show();
    },

    cmpRecycle: function() {
        Ext.MessageBox.confirm(
            _("Moving to the recycle bin"),
            _("You really want to do this?"),
            function(btn) {
                if (btn == "yes") {
                    Ext.Ajax.request({
                        url: this.urls.recycle,
                        scope:this,
                        success: this.cmpReload,
                        params: { id: this.getValues("id") }
                    });
                }
            }, this).setIcon(Ext.MessageBox.WARNING);
    },

    cmpRestore: function() {
        Ext.MessageBox.confirm(
            _("Document restoration"),
            _("You really want to do this?"),
            function(btn) {
                if (btn == "yes") {
                    Ext.Ajax.request({
                        url: this.urls.restore,
                        scope:this,
                        success: this.cmpReload,
                        params: { id: this.getValues("id") }
                    });
                }
            }, this).setIcon(Ext.MessageBox.WARNING);
    },

    cmpDelete: function() {
        Ext.MessageBox.confirm(
            _("Irreversible removal"),
            _("You can't cancel this action!"),
            function(btn) {
                if (btn == "yes") {
                    Ext.Ajax.request({
                        url: this.urls.delete,
                        scope:this,
                        success: this.cmpReload,
                        params: { id: this.getValues("id") }
                    });
                }
            }, this).setIcon(Ext.MessageBox.WARNING);
    },

    // Grid renderers

    renderers: {

        viewed: function(value, p, record) {
            if (record.data.islooked)
                return '<img title="Материал был просмотрен текущим владельцем" src="'+ _ico("eye") +'">';
            return '';
        },

        title: function(value, p, record){

            var color = 'blue';

            if (!record.data.isopen)
                color = 'gray';

            value = String.format(
                '<a style="color:{2}" href="/?aid=document-profile&oid={0}&text={1}" '+
                    'onClick="'+
                        "Inprint.ObjectResolver.resolve({aid:'document-profile',oid:'{0}',text:'{1}'});"+
                    'return false;">{1}'+
                '</a>',
                record.data.id, value, color
            );
            return value;
        },

        fascicle: function(value, p, record) {
           return value;
        },

        progress: function(v, p, record) {

            p.css += ' x-grid3-progresscol ';
            var string = '';

            if (record.data.pdate) {
                string = _fmtDate(record.data.pdate, 'M j');
            }
            else if (record.data.rdate) {
                string = _fmtDate(record.data.rdate, 'M j');
            }

            var style = '';
            var textClass = (v < 55) ? 'x-progress-text-back' : 'x-progress-text-front' + (Ext.isIE6 ? '-ie6' : '');

            // ugly hack to deal with IE6 issue
            var text = String.format('<div><div class="x-progress-text {0}" style="width:100%;" id="{1}">{2}</div></div>', textClass, Ext.id(), string);

            var bgcolor  = Color('#' + record.data.color).setSaturation(30);
            var fgcolor  = Color('#' + record.data.color);
            var txtcolor = Color('#' + inverse(record.data.color));

            return String.format(
                '<div class="x-progress-wrap">'+
                    '<div class="x-progress-inner" style="border:1px solid {4};background:{3}!important;">'+
                        '<div class="x-progress-bar{0}" style="width:{1}%;background:{4}!important;color:{5} !important;">{2}</div>'+
                '</div>',
                style, v, text, bgcolor.rgb(), fgcolor.rgb(), txtcolor);
        },

        size: function(value, p, record) {
            if (record.data.rsize)
                return record.data.rsize;
            if (record.data.psize)
                return String.format('<span style="color:silver">{0}</span>', record.data.psize);
            return '';
        }
    }

});
