// Ext Tree

Ext.tree.TreePanel.prototype.cmpCurrentNode = function () {
    return this.getSelectionModel().getSelectedNode();
};

Ext.tree.TreePanel.prototype.cmpReload = function() {
    if (! this.seletion.leaf ) {
        this.seletion.reload();
    }
}
