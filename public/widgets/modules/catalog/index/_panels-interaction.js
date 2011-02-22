Inprint.catalog.indexes.Interaction = function(parent, panels) {

    var editions  = panels.editions;
    var headlines = panels.headlines;
    var rubrics   = panels.rubrics;

    // Tree
    editions.getSelectionModel().on("selectionchange", function(sm, node) {
        if (node) {
            headlines.currentEdition = node.id;
            headlines.getRootNode().id = node.id;
            headlines.getRootNode().reload();
        }
    });

    headlines.getSelectionModel().on("selectionchange", function(sm, node) {
        if (node) {
            rubrics.enable();
            rubrics.btnCreate.enable();
            rubrics.currentHeadline = node.id;
            rubrics.cmpLoad({ headline: node.id });
        }
    });

    rubrics.getSelectionModel().on("selectionchange", function(sm) {
        _disable(rubrics.btnDelete, rubrics.btnUpdate);
        if (parent.access.manage) {
            if (sm.getCount() == 1) {
               _enable(rubrics.btnUpdate);
            }
            if (sm.getCount() > 0) {
                _enable(rubrics.btnDelete);
            }
        }
    });

};
