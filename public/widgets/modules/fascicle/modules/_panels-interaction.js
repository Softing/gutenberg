Inprint.fascicle.modules.Interaction = function(parent, panels) {

    var pages   = panels.pages;
    var modules = panels.modules;

    //Grids

    pages.btnCreate.enable();

    pages.getSelectionModel().on("selectionchange", function(sm) {

        _disable(modules.btnCreate, pages.btnUpdate, pages.btnDelete);

        if (sm.getCount() === 0) {
            modules.disable();
        }

        if (sm.getCount() == 1) {

            modules.enable();

            modules.pageId = pages.getValue("id");
            modules.pageW  = pages.getValue("w");
            modules.pageH  = pages.getValue("h");

            if (modules.pageId && modules.pageW.length > 0 && modules.pageH.length > 0) {
                modules.btnCreate.enable();
            }

            modules.cmpLoad({ page: modules.pageId });
        }

        if (sm.getCount() == 1) {
            _enable(pages.btnUpdate, pages.btnDelete);
        } else if (sm.getCount() > 1) {
            _enable(pages.btnDelete);
        }

    }, parent);

    modules.getSelectionModel().on("selectionchange", function(sm) {

        _disable(modules.btnUpdate, modules.btnDelete);

        if (sm.getCount() == 1) {
            _enable(modules.btnUpdate, modules.btnDelete);
        } else if (sm.getCount() > 1) {
            _enable(modules.btnDelete);
        }
    }, parent);

};
