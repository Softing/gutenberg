Inprint.documents.Profile.Comments = Ext.extend(Ext.Panel, {

    initComponent: function() {

        this.tbar = [
            {
                icon: _ico("balloon--plus"),
                cls: "x-btn-text-icon",
                text: _("Add a comment"),
                disabled:true,
                ref: "../btnSay",
                scope:this,
                handler: this.cmpSay
            }
        ];

        this.tmpl = new Ext.XTemplate(
            '<tpl if="history">',
                '<table width="99%" align="center" style="border:0px;">',
                '<td style="border:0px;">',
                    '<tpl for="comments">',
                        '<div style="font-size:12px;padding-left:20px;margin-right:10px;margin-bottom:10px;background:url(/icons/balloon-left.png) 0px 4px  no-repeat;">',
                            '<div style="padding:3px 0px;border-bottom:2px solid #{stage_color};"><span style="font-weight:bold;">{member_shortcut}</span> &mdash; {[ this.fmtDate( values.created ) ]} - {stage_shortcut}</div>',
                            '<div style="font-size:90%;padding:5px 0px;">{fulltext}</div>',
                        '</div>',
                    '</tpl>',
                    '<div style="clear:both;"></div>',
                '</td>',
                '</table>',
            '</tpl>',
            {
                fmtDate : function(date) { return _fmtDate(date, 'M j, H:i'); }
            }
        );

        Ext.apply(this, {
            border: false,
            items: [
                {
                    border:false,
                    tpl: this.tmpl
                }
            ]
        });
        // Call parent (required)
        Inprint.documents.Profile.Comments.superclass.initComponent.apply(this, arguments);
    },

    // Override other inherited methods
    onRender: function() {
        // Call parent (required)
        Inprint.documents.Profile.Comments.superclass.onRender.apply(this, arguments);
    },

    cmpFill: function(record) {
        if (record) {
            if (record && record.access) {
                this.cmpAccess(record.access);
            }

            this.items.get(0).update(record);
        }
    },

    cmpAccess: function(access) {
        _disable(this.btnSay);
        if (access["documents.discuss"] === true) {
            this.btnSay.enable();
        }
    },

    cmpReload: function() {
        this.parent.cmpReload();
    },

    cmpSay: function() {

        Ext.MessageBox.show({
            title: _("Comments"),
            msg: _("Please enter your text"),
            width:300,
            buttons: Ext.MessageBox.OKCANCEL,
            multiline: true,
            scope:this,
            fn: function(btn, text) {
                if (btn == "ok") {
                    Ext.Ajax.request({
                        url: _url("/documents/say/"),
                        scope:this,
                        success: this.cmpReload,
                        params: {
                            id: this.oid,
                            text: text
                        }
                    });
                }
            }
        });

    }

});
