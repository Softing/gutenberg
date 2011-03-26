// Inprint Content 5.0
// Copyright(c) 2001-2011, Softing, LLC.
// licensing@softing.ru
// http://softing.ru/license

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
