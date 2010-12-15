Inprint.fascicle.templates.Interaction = function(parent, panels) {
    
    var pages = panels.pages;
    
    pages.getSelectionModel().on("selectionchange", function(sm) {
        //_disable(rubrics.btnDelete, rubrics.btnUpdate);
        //if (parent.access["manage"]) {
        //    if (sm.getCount() == 1) {
        //       _enable(rubrics.btnUpdate);
        //    }
        //    if (sm.getCount() > 0) {
        //        _enable(rubrics.btnDelete);
        //    }
        //}
    });
    
}
