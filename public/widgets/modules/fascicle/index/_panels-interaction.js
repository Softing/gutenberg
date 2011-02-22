Inprint.fascicle.indexes.Interaction = function(parent, panels) {


    var headlines = panels.headlines;
    var rubrics   = panels.rubrics;

    // Tree

    headlines.getSelectionModel().on("selectionchange", function(sm, node) {
        if (node) {
            parent.headline = node.id;
            rubrics.enable();
            rubrics.cmpLoad({ headline: parent.headline });
            rubrics.btnCreate.enable();
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
