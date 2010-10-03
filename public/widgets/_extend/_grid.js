// Ext Grid

Ext.grid.GridPanel.prototype.cacheParams = { };
Ext.grid.GridPanel.prototype.loadMask = { msg: _("Please wait...") };

Ext.grid.GridPanel.prototype.viewConfig = {
    emptyText: _("Suitable data is not found"),
    deferEmptyText  : false
};

Ext.grid.GridPanel.prototype.getValue = function(value) {
    return this.getSelectionModel().getSelected().get(value);
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
}

Ext.grid.GridPanel.prototype.cmpLoad = function(params, clear) {
    
    if (clear) {
        this.cacheParams = params;
        this.getStore().reload({ params: this.cacheParams });
    } else {
        Ext.apply (this.cacheParams, params);
        this.getStore().reload({ params: this.cacheParams });
    }
    
    //if (params) {
    //    this.params = params;
    //    this.getStore().reload({ params: params });
    //} else {
    //    this.getStore().reload({ params: this.params});
    //}
}

Ext.grid.GridPanel.prototype.cmpReload = function() {
    this.getStore().reload();
}
