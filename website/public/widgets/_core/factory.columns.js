// Inprint Content 5.0
// Copyright(c) 2001-2011, Softing, LLC.
// licensing@softing.ru
// http://softing.ru/license

Ext.namespace("Inprint.factory.columns");

Inprint.factory.columns.manager = new function () {

    var items = {};

    return {

        set: function(name, item) {
            items[name] = item;
        },

        get: function(name) {

            var item = items[name];

            if (!item) {
                alert("Column "+name+" not found!");
                return false;
            }

            /* *** */

            item.setHeader = function(header) {
                this.header = header;
                return this;
            };

            item.setIndex = function(dataIndex) {
                this.dataIndex = dataIndex;
                return this;
            };

            item.setWidth = function(width) {
                this.width = width;
                return this;
            };

            item.setTemplate = function(template) {
                this.template = new Ext.XTemplate(template);
                return this;
            };

            item.setRenderer = function(renderer) {
                this.renderer = renderer;
                return this;
            };

            return item;
        }

    }
};

Inprint.setColumn = function (name, fnct) {
    return Inprint.factory.columns.manager.set(name, fnct);
}

Inprint.getColumn = function (name) {
    return Inprint.factory.columns.manager.get(name);
}

/* *** */

Inprint.setColumn("shortcut", {
    header: _("Shortcut"),
    dataIndex: 'shortcut',
    width: 180
});

Inprint.setColumn("description", {
    header: _("Description"),
    dataIndex: 'description',
    width: 180
});

Inprint.setColumn("created", {
    header: _("Created"),
    dataIndex: 'created',
    width: 120,
    tpl: new Ext.XTemplate('{created:this.formatDate}', {
        formatDate: function(date) {
            return _fmtDate(date, 'F j, H:i');
        }
    })
});

Inprint.setColumn("updated", {
    header: _("Updated"),
    dataIndex: 'updated',
    width: 120,
    tpl: new Ext.XTemplate('{created:this.formatDate}', {
        formatDate: function(date) {
            return _fmtDate(date, 'F j, H:i');
        }
    })
});

/* *** */

Inprint.setColumn("edition", {
    header: _("Edition"),
    dataIndex: 'edition_shortcut',
    width: 180
});
