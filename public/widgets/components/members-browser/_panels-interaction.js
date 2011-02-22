Inprint.membersBrowser.Interaction = function(panels) {

    var tree = panels.tree;
    var view = panels.view;

    tree.getSelectionModel().on("selectionchange", function(sm, node) {
        view.cmpLoad({ node: node.id });
    });

};
