Inprint.documents.Grid = Ext.extend(Ext.grid.GridPanel, {

    initComponent: function() {
        
        this.params = {};
        this.components = {};
        
        this.urls = {
            list:    "/documents/list/"
        }
        
        this.store = Inprint.factory.Store.json(this.urls.list, {
            totalProperty: 'total'
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
                id:"maingroup",
                dataIndex: "maingroup_shortcut",
                header: _("Group"),
                width: 100,
                sortable: true,
                filter: {
                    filterName:"flt_group",
                    xtype: "combo",
                    clearable:true,
                    mode: "local",
                    store: [["A","Type1"],["B","Type2"]],
                    triggerAction: "all"
                }
            },
            
            {
                id:"title",
                dataIndex: "title",
                header: _("Title"),
                width: 210,
                sortable: true,
                renderer : this.renderers.title,
                filter: { xtype:"textfield", filterName:"flt_title" }
            },
            {
                id:"fascicle",
                dataIndex: "fascicle_shortcut",
                header: _("Fascicle"),
                width: 90,
                sortable: true,
                renderer : this.renderers.fascicle,
                filter: {
                    filterName:"flt_fascicle",
                    xtype: "combo",
                    mode: "local",
                    store: [["A","Type1"],["B","Type2"]],
                    triggerAction: "all"
                }
            },
            
            {
                id:"pages",
                dataIndex: "pages",
                header: _("Pages"),
                width: 90,
                sortable: true
            },
            {
                id:"headline",
                dataIndex: "headline_shortcut",
                header: _("Headline"),
                width: 100,
                sortable: true,
                filter: {
                    filterName:"flt_hedline",
                    xtype: "combo",
                    mode: "local",
                    store: [["A","Type1"],["B","Type2"]],
                    triggerAction: "all"
                }
            },
            {
                id:"rubric",
                dataIndex: "rubric_shortcut",
                header: _("Rubric"),
                width: 100,
                sortable: true,
                filter: {
                    filterName:"flt_shortcut",
                    xtype: "combo",
                    mode: "local",
                    store: [["A","Type1"],["B","Type2"]],
                    triggerAction: "all"
                }
            },
            
            {
                id:"manager",
                dataIndex: "manager_shortcut",
                header: _("Manager"),
                width: 100,
                sortable: true,
                filter: {
                    filterName:"flt_manager",
                    xtype: "combo",
                    mode: "local",
                    store: [["A","Type1"],["B","Type2"]],
                    triggerAction: "all"
                }
            },
            {
                id:"progress",
                dataIndex: "progress",
                header: _("Progress"),
                sortable: true,
                width: 100,
                renderer : this.renderers.progress,
                filter: {
                    filterName:"flt_progress",
                    xtype: "combo",
                    mode: "local",
                    store: [["A","Type1"],["B","Type2"]],
                    triggerAction: "all"
                }
            },
            {
                id:"owner",
                dataIndex: "owner_shortcut",
                header: _("Owner"),
                width: 100,
                sortable: true,
                filter: {
                    filterName:"flt_owner",
                    xtype: "combo",
                    mode: "local",
                    store: [["A","Type1"],["B","Type2"]],
                    triggerAction: "all"
                }
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
                width:50,
                sortable: true,
                renderer : this.renderers.size
            }
            
        ];
        
        this.tbar = [
            {
                icon: _ico("plus-button"),
                cls: "x-btn-text-icon",
                text: _("Add"),
                disabled:true,
                ref: "../btnCreate",
                scope:this,
                handler: this.cmpCreate
            },
            {
                icon: _ico("pencil"),
                cls: "x-btn-text-icon",
                text: _("Edit"),
                disabled:true,
                ref: "../btnUpdate",
                scope:this,
                handler: this.cmpCreate
            },
            '-',
            {
                icon: _ico("hand"),
                cls: "x-btn-text-icon",
                text: _("Capture"),
                disabled:true,
                ref: "../btnCapture",
                scope:this,
                handler: this.cmpDelete
            },
            {
                icon: _ico("arrow"),
                cls: "x-btn-text-icon",
                text: _("Transfer"),
                disabled:true,
                ref: "../btnTransfer",
                scope:this,
                handler: this.cmpDelete
            },
            {
                icon: _ico("briefcase"),
                cls: "x-btn-text-icon",
                text: _("Briefcase"),
                disabled:true,
                ref: "../btnBriefcase",
                scope:this,
                handler: this.cmpDelete
            },
            "-",
            {
                icon: _ico("document-copy"),
                cls: "x-btn-text-icon",
                text: _("Copy"),
                disabled:true,
                ref: "../btnCopy",
                scope:this,
                handler: this.cmpDelete
            },
            {
                icon: _ico("documents"),
                cls: "x-btn-text-icon",
                text: _("Duplicate"),
                disabled:true,
                ref: "../btnDuplicate",
                scope:this,
                handler: this.cmpDelete
            },
            "-",
            {
                icon: _ico("bin--plus"),
                cls: "x-btn-text-icon",
                text: _("Recycle Bin"),
                disabled:true,
                ref: "../btnRecycle",
                scope:this,
                handler: this.cmpDelete
            },
            {
                icon: _ico("bin--arrow"),
                cls: "x-btn-text-icon",
                text: _("Restore"),
                disabled:true,
                ref: "../btnRestore",
                scope:this,
                handler: this.cmpDelete
            },
            {
                icon: _ico("minus-button"),
                cls: "x-btn-text-icon",
                text: _("Delete"),
                disabled:true,
                ref: "../btnDelete",
                scope:this,
                handler: this.cmpDelete
            }
        ];
        
        this.bbar = new Ext.PagingToolbar({
            pageSize: 60,
            store: this.store,
            displayInfo: true,
            displayMsg: _("Displaying documents {0} - {1} of {2}"),
            emptyMsg: _("No documents to display"),
            items:[
                '-',
                {
                    pressed: true,
                    enableToggle:true,
                    text: '60',
                    //cls: 'x-btn-text-icon details',
                    toggleHandler: function(btn, pressed){}
                },
                {
                    pressed: false,
                    enableToggle:true,
                    text: '90',
                    //cls: 'x-btn-text-icon details',
                    toggleHandler: function(btn, pressed){}
                },
                {
                    pressed: false,
                    enableToggle:true,
                    text: '120',
                    //cls: 'x-btn-text-icon details',
                    toggleHandler: function(btn, pressed){}
                }
            ]
        });
        
        Ext.apply(this, {
            //disabled:false,
            border:false,
            stripeRows: true,
            columnLines: true,
            autoExpandColumn: "title",
            sm: this.sm,
            tbar: this.tbar,
            columns: this.columns,
            bbar: this.bbar,
            plugins: [new Ext.ux.grid.GridHeaderFilters()]
        });
        
        Inprint.documents.Grid.superclass.initComponent.apply(this, arguments);
        
    },
    
    onRender: function() {
        Inprint.documents.Grid.superclass.onRender.apply(this, arguments);
        this.store.load({params:{start:0, limit:60}});
    },

    renderers: {
        viewed: function(value, p, record) {
           if (record.data.islooked)
               return '<img title="Материал был просмотрен текущим владельцем" src="'+ _ico("eye") +'">';
           return '';
        },
        
        title: function(value, p, record){
            value = String.format(
                '<a href="/?part=documents&page=formular&oid={0}&text={1}" '+
                    'onClick="Inprint.objResolver(\'documents\', \'formular\', { oid:\'{0}\', text:\'{1}\' });return false;">'+
                    '{1}'+
                '</a>', 
                record.data.uuid, value
            );
            return String.format('{0}', value);
        },
        
        fascicle: function(value, p, record) {
           return value;
        },
        
        progress: function(v, p, record) {
            
            var string = '';
            
            if (record.data.pdate) {
                string = _fmtDate(record.data.pdate);
            }
            else if (record.data.rdate) {
                string = _fmtDate(record.data.rdate);
            }
            
            var style = '';
            var textClass = (v < 55) ? 'x-progress-text-back' : 'x-progress-text-front' + (Ext.isIE6 ? '-ie6' : '');
          
            // ugly hack to deal with IE6 issue
            var text = String.format('<div><div class="x-progress-text {0}" style="width:100%;" id="{1}">{2}</div></div>', textClass, Ext.id(), string);
            var color = '#' + record.data.color || 'transparent';
            p.css += ' x-grid3-progresscol ';
          
            return String.format(
                '<div class="x-progress-wrap">'+
                    '<div class="x-progress-inner" style="border:1px solid {3};">'+
                        '<div class="x-progress-bar{0}" style="width:{1}%;background:{3} !important;">{2}'+
                    '</div>'+
                '</div>', style, v, text, color);
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
