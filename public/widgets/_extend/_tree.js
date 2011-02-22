// Ext Tree

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
    if (this.selection) {
        if (this.selection.reload) {
            this.selection.reload();
        }
        else if (this.selection.parentNode.reload) {
            this.selection.parentNode.reload();
        }
    }
};
