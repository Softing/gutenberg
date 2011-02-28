Inprint.documents.Profile.View = Ext.extend(Ext.Panel, {

    initComponent: function() {

        var actions = new Inprint.documents.GridActions();

        this.tbar = [
            {
                icon: _ico("card--pencil"),
                cls: "x-btn-text-icon",
                text: _("Properties"),
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
            '<th width="70">'+ _("Edition") +'</th>',
            '<th width="70">'+ _("Issue") +'</td>',
            '<th width="90">'+ _("Category") +'</th>',
            '<th width="90">'+ _("Rubric") +'</th>',
            '<th width="50">'+ _("Length") +'</th>',
            '<th width="80">'+ _("Group") +'</td>',
            '<th width="100">'+ _("Editor") +'</th>',
            '<th width="130">'+ _("Author") +'</th>',
            '<th width="90">'+ _("Date") +'</th>',
        '</tr>',
        '<tr>',
            '<td>{[ this.fmtString( values.title ) ]}</td>',
            '<td>{[ this.fmtString( values.edition_shortcut ) ]}</td>',
            '<td>{[ this.fmtString( values.fascicle_shortcut ) ]}</td>',
            '<td>{[ this.fmtString( values.headline_shortcut ) ]}</td>',
            '<td>{[ this.fmtString( values.rubric_shortcut ) ]}</td>',
            '<td><nobr>',
                '<tpl if="rsize">{rsize}</tpl>',
                '<tpl if="!rsize">{psize}</tpl>',
            '</nobr></td>',
            '<td><nobr>{[ this.fmtString( values.workgroup_shortcut ) ]}</nobr></td>',
            '<td><nobr>{[ this.fmtString( values.manager_shortcut ) ]}</nobr></td>',
            '<td><nobr>{[ this.fmtString( values.author ) ]}</nobr></td>',
            '<td><nobr>',
                '<tpl if="fdate">{[ this.fmtDate( values.fdate ) ]}</tpl>',
                '<tpl if="!fdate">{[ this.fmtDate( values.pdate ) ]}</tpl>',
            '</nobr></td>',
        '</tr>',
        '</table>',
        {
            fmtDate : function(date) { return _fmtDate(date, 'M j, H:i'); },
            fmtString : function(string) { if (!string) { string = ''; } return string; }
        }
    ),

    tmpl2: new Ext.XTemplate(
        '<tpl if="fascicles">',
            '<table width="99%" align="center">',
            '<tr style="background:#f5f5f5;">',
                '<th width="70">'+ _("Edition") +'</th>',
                '<th width="70">'+ _("Issue") +'</td>',
                '<th width="90">'+ _("Category") +'</th>',
                '<th>Рубрика</th>',
            '</tr>',
            '<tpl for="fascicles">',
                '<tr>',
                    '<td>{[ this.fmtString( values.edition_shortcut ) ]}</td>',
                    '<td>{[ this.fmtString( values.fascicle_shortcut ) ]}</td>',
                    '<td>{[ this.fmtString( values.headline_shortcut ) ]}</td>',
                    '<td>{[ this.fmtString( values.rubric_shortcut ) ]}</td>',
                '</tr>',
            '</tpl>',
            '</table>',
        '</tpl>',
        {
            fmtDate : function(date) { return _fmtDate(date, 'M j, H:i'); },
            fmtString : function(string) { if (!string) { string = ''; } return string; }
        }
    ),

    tmpl3: new Ext.XTemplate(
        '<tpl if="history">',
            '<table width="99%" align="center" style="border:0px;">',
            '<td style="border:0px;">',
                '<tpl for="history">',
                    '<div style="display: inline;padding:3px;padding-left:12px;margin-right:10px;float:left;background:url(/icons/arrow-000-small.png) -3px 2px  no-repeat;">',
                        '<div style="font-weight:bold;border-bottom:2px solid #{color};">{destination_shortcut}</div>',
                        '<div style="font-size:90%;">{stage_shortcut}</div>',
                        '<div style="font-size:90%;">{[ this.fmtDate( values.created ) ]}</div>',
                    '</div>',
                '</tpl>',
                '<div style="clear:both;"></div>',
            '</td>',
            '</table>',
        '</tpl>',
        {
            fmtDate : function(date) { return _fmtDate(date, 'M j, H:i'); },
            fmtString : function(string) { if (!string) { string = ''; } return string; }
        }
    ),

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

        if (access["documents.update"]    === true) {
            this.btnUpdate.enable();
        }
        if (access["documents.capture"]   === true) {
            this.btnCapture.enable();
        }
        if (access["documents.transfer"]  === true) {
            this.btnTransfer.enable();
        }
        if (access["documents.briefcase"] === true) {
            this.btnBriefcase.enable();
        }
        if (access["documents.move"]      === true) {
            this.btnMove.enable();
        }
        if (access["documents.move"]      === true) {
            this.btnCopy.enable();
        }
        if (access["documents.move"]      === true) {
            this.btnDuplicate.enable();
        }
        if (access["documents.recover"]   === true) {
            this.btnRestore.enable();
        }
        if (access["documents.delete"]    === true) {
            this.btnRecycle.enable();
        }
        if (access["documents.delete"]    === true) {
            this.btnDelete.enable();
        }
    }

});
