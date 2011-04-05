Inprint.calendar.GridColumns = {

    shortcut: {
        header: _("Shortcut"),
        dataIndex: 'shortcut',
        width: 140,
        tpl: new Ext.XTemplate('<tpl if="!enabled"><s></tpl>{shortcut}<tpl if="!enabled"></s></tpl>')
    },

    template: {
        header: _("Template"),
        dataIndex: 'tmpl_shortcut',
        width: 100
    },

    num: {
        header: _("Number"),
        dataIndex: 'num',
        width: 80,
        tpl: new Ext.XTemplate('{num}/{anum}')
    },

    circulation: {
        header: _("Circulation"),
        dataIndex: 'circulation',
        width: 80
    },

        printdate: {
        header: _("Print date"),
        dataIndex: 'date_print',
        width: 120,
        tpl: new Ext.XTemplate('{print_date:this.formatDate}', {
            formatDate: function(date) {
                return _fmtDate(date, 'F j');
            }
        })
    },

    releasedate: {
        header: _("Release date"),
        dataIndex: 'date_release',
        width: 120,
        tpl: new Ext.XTemplate('{release_date:this.formatDate}', {
            formatDate: function(date) {
                return _fmtDate(date, 'F j');
            }
        })
    },

    docdate: {
        header: _("Documents"),
        dataIndex: 'date_doc',
        width: 120,
        tpl: new Ext.XTemplate('<tpl if="!doc_enabled"><s></tpl>{doc_date:this.formatDate}<tpl if="!doc_enabled"></s></tpl>', {
            formatDate: function(date) {
                return _fmtDate(date, 'F j, H:i');
            }
        })
    },

    advdate: {
        header: _("Advertisement"),
        dataIndex: 'date_adv',
        width: 120,
        tpl: new Ext.XTemplate('<tpl if="!adv_enabled"><s></tpl>{adv_date:this.formatDate}<tpl if="!adv_enabled"></s></tpl>', {
            formatDate: function(date) {
                return _fmtDate(date, 'F j, H:i');
            }
        })
    }

};
