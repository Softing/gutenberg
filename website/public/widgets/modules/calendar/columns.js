"use strict";

Inprint.calendar.ux.columns = {

    icon: {
        dataIndex: 'fastype',
        width: 24,
        renderer: function(value, metaData, record, rowIndex, colIndex, store) {
            if (value == 'issue')       var icon = _ico("blue-folder");
            if (value == 'attachment')  var icon = _ico("folder");
            if (value == 'template')    var icon = _ico("puzzle");
            return String.format('<img src="{0}"/>', icon);
        }
    },

    status: {
        dataIndex: 'enabled',
        width: 24,
        renderer: function(value, metaData, record, rowIndex, colIndex, store) {
            if (value == 1) var icon = _ico("status");
            if (value == 0) var icon = _ico("status-offline");
            return String.format('<img src="{0}"/>', icon);
        }
    },

    edition: {
        header: _("Edition"),
        dataIndex: 'edition_shortcut',
        width: 180
    },

    shortcut: {
        header: _("Shortcut"),
        dataIndex: 'shortcut',
        width: 180
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
        renderer: function(value, metaData, record, rowIndex, colIndex, store) {
            return _fmtDate(value, 'F j, H:i');
        }
    },

    releasedate: {
        header: _("Release date"),
        dataIndex: 'date_release',
        width: 120,
        renderer: function(value, metaData, record, rowIndex, colIndex, store) {
            return _fmtDate(value, 'F j, H:i');
        }
    },

    docdate: {
        header: _("Documents"),
        dataIndex: 'date_doc',
        width: 120,
        renderer: function(value, metaData, record, rowIndex, colIndex, store) {
            return _fmtDate(value, 'F j, H:i');
        }
    },

    advdate: {
        header: _("Advertisement"),
        dataIndex: 'date_adv',
        width: 120,
        renderer: function(value, metaData, record, rowIndex, colIndex, store) {
            return _fmtDate(value, 'F j, H:i');
        }
    },

    created: {
        header: _("Created"),
        dataIndex: 'created',
        width: 120,
        renderer: function(value, metaData, record, rowIndex, colIndex, store) {
            return _fmtDate(value, 'F j, H:i');
        }
    },

    updated: {
        header: _("Updated"),
        dataIndex: 'updated',
        width: 120,
        renderer: function(value, metaData, record, rowIndex, colIndex, store) {
            return _fmtDate(value, 'F j, H:i');
        }
    }

};
