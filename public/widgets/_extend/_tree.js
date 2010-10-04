// Ext Tree

Ext.tree.TreePanel.prototype.cmpCurrentNode = function () {
    return this.getSelectionModel().getSelectedNode();
};

Ext.tree.TreePanel.prototype.cmpReloadParent = function() {
    if (this.selection.parentNode) {
        this.selection.parentNode.reload();
    }
}

Ext.tree.TreePanel.prototype.cmpReload = function() {
    this.selection.reload();
}
