// Inprint Content 5.0
// Copyright(c) 2001-2011, Softing, LLC.
// licensing@softing.ru
// http://softing.ru/license

Ext.tree.TreePanel.prototype.cmpGetNodeId = function () {
    if (this.getSelectionModel().getSelectedNode()) {
        return this.getSelectionModel().getSelectedNode().id;
    }
    return false;
};

Ext.tree.TreePanel.prototype.cmpCurrentNode = function () {
    return this.getSelectionModel().getSelectedNode();
};

Ext.tree.TreePanel.prototype.cmpReloadParent = function() {
    if (this.selection.parentNode) {
        this.selection.parentNode.reload();
    }
};

Ext.tree.TreePanel.prototype.cmpReload = function() {

    if (this.selection && this.selection.reload) {
        this.selection.reload();
    }

    else if (this.selection && this.selection.parentNode && this.selection.parentNode.reload) {
        this.selection.parentNode.reload();
    }

    else if (this.getRootNode().reload) {
        this.getRootNode().reload();
    }

};
