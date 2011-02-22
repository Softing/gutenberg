Ext.DataView.prototype.cmpLoad = function(params) {
    if (params) {
        this.params = params;
        this.getStore().reload({ params: params });
    } else {
        this.getStore().reload({ params: this.params});
    }
};

Ext.DataView.prototype.cmpReload = function() {
    this.getStore().reload();
};
