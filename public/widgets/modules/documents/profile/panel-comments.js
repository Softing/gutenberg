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
            '<table width="99%" align="center" style="border:0px;">',
            '<td style="border:0px;">',
                '<tpl for=".">',
                    '<div style="font-size:12px;padding-left:20px;margin-right:10px;margin-bottom:10px;',
                        'background:url(/icons/{[ values.icon ? values.icon : "balloon-left" ]}.png) 0px 4px  no-repeat;">',
                            '<div style="padding:3px 0px;',
                            '<tpl if="values.stage_color">border-bottom:2px solid #{stage_color};</tpl>">',
                            '<span style="font-weight:bold;">{member_shortcut}</span>',
                            '&nbsp;&mdash; {[ this.fmtDate( values.created ) ]}',
                            '{[values.stage_shortcut ? values.stage_shortcut : ""]}</div>',
                            '<div style="font-size:90%;padding:5px 0px;">{fulltext}</div>',
                    '</div>',
                '</tpl>',
                '<div style="clear:both;"></div>',
            '</td>',
            '</table>',
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

        Inprint.documents.Profile.Comments.superclass.initComponent.apply(this, arguments);
    },

    onRender: function() {
        Inprint.documents.Profile.Comments.superclass.onRender.apply(this, arguments);
    },

    cmpAccess: function(access) {
        _disable(this.btnSay);
        if (access["discuss"] === true) {
            this.btnSay.enable();
        }
    },

    cmpLoad: function (id) {
        if (id) {

            this.cacheId = id;

            var success = function(resp) {
                var result = Ext.decode(resp.responseText);
                this.cmpFill(result.data);
            }

            Ext.Ajax.request({
                url: _url("/documents/comments/list/"),
                scope: this,
                success: success,
                params: {
                    id: this.cacheId
                }
            });

        }
    },

    cmpReload: function() {
        this.cmpLoad(this.cacheId);
    },

    cmpFill: function(records) {
        if (records) {
            this.items.get(0).update(records);
        }
    },

    cmpSay: function() {

        Ext.MessageBox.show({
            title: _("Comments"),
            msg: _("Please enter your text"),
            width:400,
            buttons: Ext.MessageBox.OKCANCEL,
            multiline: true,
            scope:this,
            fn: function(btn, text) {
                if (btn == "ok") {
                    Ext.Ajax.request({
                        url: _url("/documents/comments/save/"),
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
