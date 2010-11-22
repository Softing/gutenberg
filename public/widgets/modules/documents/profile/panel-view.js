Inprint.documents.Profile.View = Ext.extend(Ext.Panel, {

    initComponent: function() {
        
        var actions = new Inprint.documents.Actions();
        
        this.tbar = [
            {
                icon: _ico("pencil"),
                cls: "x-btn-text-icon",
                text: _("Edit"),
                disabled:true,
                ref: "../btnUpdate",
                scope:this.parent,
                handler: actions.Update
            },
            '-',
            {
                icon: _ico("hand"),
                cls: "x-btn-text-icon",
                text: _("Capture"),
                disabled:true,
                ref: "../btnCapture",
                scope:this.parent,
                handler: actions.Capture
            },
            {
                icon: _ico("arrow"),
                cls: "x-btn-text-icon",
                text: _("Transfer"),
                disabled:true,
                ref: "../btnTransfer",
                scope:this.parent,
                handler: actions.Transfer
            },
            '-',
            {
                icon: _ico("blue-folder-import"),
                cls: "x-btn-text-icon",
                text: _("Move"),
                disabled:true,
                ref: "../btnMove",
                scope:this.parent,
                handler: actions.Move
            },
            {
                icon: _ico("briefcase"),
                cls: "x-btn-text-icon",
                text: _("Briefcase"),
                disabled:true,
                ref: "../btnBriefcase",
                scope:this.parent,
                handler: actions.Briefcase
            },
            "-",
            {
                icon: _ico("document-copy"),
                cls: "x-btn-text-icon",
                text: _("Copy"),
                disabled:true,
                ref: "../btnCopy",
                scope:this.parent,
                handler: actions.Copy
            },
            {
                icon: _ico("documents"),
                cls: "x-btn-text-icon",
                text: _("Duplicate"),
                disabled:true,
                ref: "../btnDuplicate",
                scope:this.parent,
                handler: actions.Duplicate
            },
            "-",
            {
                icon: _ico("bin--plus"),
                cls: "x-btn-text-icon",
                text: _("Recycle Bin"),
                disabled:true,
                ref: "../btnRecycle",
                scope:this.parent,
                handler: actions.Recycle
            },
            {
                icon: _ico("bin--arrow"),
                cls: "x-btn-text-icon",
                text: _("Restore"),
                disabled:true,
                ref: "../btnRestore",
                scope:this.parent,
                handler: actions.Restore
            },
            {
                icon: _ico("minus-button"),
                cls: "x-btn-text-icon",
                text: _("Delete"),
                disabled:true,
                ref: "../btnDelete",
                scope:this.parent,
                handler: actions.Delete
            }
        ];
        
        Ext.apply(this, {
            border: false,
            autoScroll:true,
            bodyCssClass: "inprint-document-profile",
            items: [
                {
                    border:false,
                    tpl: this.tmpl1
                },
                {
                    border:false,
                    tpl: this.tmpl3
                },
                {
                    border:false,
                    tpl: this.tmpl2
                }
            ]
        });
        // Call parent (required)
        Inprint.documents.Profile.View.superclass.initComponent.apply(this, arguments);
    },

    // Override other inherited methods
    onRender: function() {
        // Call parent (required)
        Inprint.documents.Profile.View.superclass.onRender.apply(this, arguments);
    },
    
    tmpl1: new Ext.XTemplate(
        '<table width="99%" align="center">',
        '<tr style="background:#f5f5f5;">',
            '<th>Название</th>',
            '<th width="70">Издание</th>',
            '<th width="70">Выпуск</td>',
            '<th width="90">Раздел</th>',
            '<th width="90">Рубрика</th>',
            '<th width="50">Объем</th>',
            '<th width="80">Отдел</td>',
            '<th width="100">Редактор</th>',
            '<th width="130">Автор</th>',
            '<th width="100">Дата&nbsp;сдачи</th>',
        '</tr>',
        '<tr>',
            '<td>{title}</td>',
            '<td>{edition_shortcut}</td>',
            '<td>{fascicle_shortcut}</td>',
            '<td>{headline_shortcut}</td>',
            '<td>{rubric_shortcut}</td>',
            '<td><nobr>',
                '<tpl if="rsize">{rsize}</tpl>',
                '<tpl if="!rsize">{psize}</tpl>',
            '</nobr></td>',
            '<td><nobr>{workgroup_shortcut}</nobr></td>',
            '<td><nobr>{manager_shortcut}</nobr></td>',
            '<td><nobr>{author}</nobr></td>',
            '<td><nobr>',
                '<tpl if="rdate">{[ this.fmtDate( values.rdate ) ]}</tpl>',
                '<tpl if="!rdate">{[ this.fmtDate( values.pdate ) ]}</tpl>',
            '</nobr></td>',
        '</tr>',
        '</table>',
        {
            fmtDate : function(date) { return _fmtDate(date, 'M j, H:i'); }
        }
    ),
    
    tmpl2: [
        '<tpl if="fascicles">', 
            '<table width="99%" align="center">',
            '<tr style="background:#f5f5f5;">',
                '<th width="70">Издание</th>',
                '<th width="70">Выпуск</td>',
                '<th width="90">Раздел</th>',
                '<th>Рубрика</th>',
            '</tr>',
            '<tpl for="fascicles">', 
                '<tr>',
                    '<td>{edition_shortcut}</td>',
                    '<td>{fascicle_shortcut}</td>',
                    '<td>{headline_shortcut}</td>',
                    '<td>{rubric_shortcut}</td>',
                '</tr>',
            '</tpl>', 
            '</table>',
        '</tpl>',
    ],
    
    tmpl3: [
        '<table width="99%" align="center">',
        '<tr>',
            '<td style="padding:4px;">',
                '<tpl for="history">',
                    '<table style="font-size:10px;margin-right:10px;float:left;" >',
                    '<tr>',
                        '<td style="font-size:12px;padding:4px;border-bottom:2px solid {color};">',
                            '<div>{member_title}</div>',
                            '<div style="font-size:10px;">{title}</div>',
                        '</td>',
                    '</tr>',
                    '</table> ', 
                '</tpl>',
            '</td>', 
        '</tr>',
        '</table>'
    ],
    
    cmpFill: function(record) {
        if (record) {
            if (record.access) {
                this.cmpAccess(record.fascicle, record.access);
            }
            this.items.get(0).update(record);
            this.items.get(1).update(record);
            this.items.get(2).hide();
            if (record.fascicles.length > 0) {
                this.items.get(2).show();
                this.items.get(2).update(record);
            }
        }
    },
    
    cmpAccess: function(fascicle, access) {
        
        _hide(this.btnRecycle, this.btnRestore, this.btnDelete);
        
        if (fascicle == '99999999-9999-9999-9999-999999999999') {
            _show(this.btnRestore, this.btnDelete);
        } else {
            _show(this.btnRecycle);
        }
        
        _disable(this.btnUpdate, this.btnCapture, this.btnTransfer, this.btnMove, this.btnBriefcase, this.btnCopy,
                    this.btnDuplicate, this.btnRecycle, this.btnRestore, this.btnDelete);
        
        if (access["documents.update"]    == true) this.btnUpdate.enable();
        if (access["documents.capture"]   == true) this.btnCapture.enable();
        if (access["documents.transfer"]  == true) this.btnTransfer.enable();
        if (access["documents.briefcase"] == true) this.btnBriefcase.enable();
        if (access["documents.move"]      == true) this.btnMove.enable();
        if (access["documents.move"]      == true) this.btnCopy.enable();
        if (access["documents.move"]      == true) this.btnDuplicate.enable();
        if (access["documents.recover"]   == true) this.btnRestore.enable();
        if (access["documents.delete"]    == true) this.btnRecycle.enable();
        if (access["documents.delete"]    == true) this.btnDelete.enable();
    }

});
