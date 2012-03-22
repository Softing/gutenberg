// Inprint Content 5.0
// Copyright(c) 2001-2011, Softing, LLC.
// licensing@softing.ru
// http://softing.ru/license

Ext.namespace("Inprint.grid");

/* Grid */

Inprint.grid.GridPanel = Ext.extend(Ext.grid.GridPanel, {

    /* Custom settings */
    cacheParams: { },

    border:false,
    stripeRows: true,
    columnLines: true,

    trackMouseOver: false,
    loadMask: { msg: _("Loading data...") },

    viewConfig: {
        emptyText: _("Suitable data is not found"),
        deferEmptyText  : false
    },

    /* Custom functions */
    cmpGetRecord: function() {
        return this.getSelectionModel().getSelected();
    },

    cmpGetValue: function(value) {
        var result;
        if (this.getSelectionModel().getSelected()) {
            result = this.getSelectionModel().getSelected().get(value);
        }
        return result;
    },

    cmpGetValues: function(field) {
        var data = [];
        Ext.each(this.getSelectionModel().getSelections(), function(record) {
            data.push(record.data[field]);
        });
        return data;
    },

    cmpClear: function() {
        this.getStore().removeAll();
    },

    cmpLoad: function(params, clear) {
        if (clear) {
            this.cacheParams = params;
        } else {
            Ext.apply(this.cacheParams, params);
        }
        this.getStore().removeAll();
        this.getStore().reload({ params: this.cacheParams });
    },

    cmpReload: function() {
        this.getStore().removeAll();
        this.getStore().reload();
    }
});

// OLD

Ext.grid.GridPanel.prototype.cacheParams = { };
Ext.grid.GridPanel.prototype.loadMask = { msg: _("Loading data...") };

Ext.grid.GridPanel.prototype.viewConfig = {
    emptyText: _("Suitable data is not found"),
    deferEmptyText  : false
};

Ext.grid.GridPanel.prototype.getRecord = function() {
    return this.getSelectionModel().getSelected();
};

Ext.grid.GridPanel.prototype.getValue = function(value) {
    var result;
    if (this.getSelectionModel().getSelected()) {
        result = this.getSelectionModel().getSelected().get(value);
    }
    return result;
};

Ext.grid.GridPanel.prototype.getValues = function(field) {
    var data = [];
    Ext.each(this.getSelectionModel().getSelections(), function(record) {
        data.push(record.data[field]);
    });
    return data;
};

Ext.grid.GridPanel.prototype.cmpClear = function() {
    this.getStore().removeAll();
};

Ext.grid.GridPanel.prototype.cmpLoad = function(params, clear) {
    if (clear) {
        this.cacheParams = params;
    } else {
        Ext.apply(this.cacheParams, params);
    }
    this.getStore().removeAll();
    this.getStore().reload({ params: this.cacheParams });
};

Ext.grid.GridPanel.prototype.cmpReload = function() {
    this.getStore().removeAll();
    this.getStore().reload();
};
