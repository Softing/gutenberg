Inprint.plugins.rss.Access = function(parent, panels) {

    var grid = panels.grid;

    grid.btnSave.enable();

    grid.getSelectionModel().on("selectionchange", function(sm) {

        var records = grid.getSelectionModel().getSelections();
        var access = _arrayAccessCheck(records, ['manage']);

        _disable(grid.btnPublish, grid.btnUnpublish);

        if (access.manage == 'enabled') {
            _enable(grid.btnPublish, grid.btnUnpublish);
        }

    });

};
