Inprint.calendar.templates.Interaction = function(parent, panels) {

    var templates = panels.templates;

    templates.on("afterrender", function() {
        _a(["editions.template.manage:*"], null, function(access) {
            if (access["editions.template.manage"] === true) {
                _enable(templates.btnCreate);
            }
        });
    });

    templates.on("rowclick", function(grid, rowIndex, e) {

        var record = grid.store.getAt(rowIndex);

        var issue   = record.get("id");
        var edition = record.get("edition");

        _disable(templates.btnCreate, templates.btnUpdate, templates.btnDelete,
                 templates.btnOpenPlan, templates.btnOpenComposer);

        _a(["editions.template.manage:*"], edition, function(access) {
            if (access["editions.template.manage"] === true) {
                _enable(templates.btnCreate, templates.btnUpdate, templates.btnDelete,
                        templates.btnOpenPlan, templates.btnOpenComposer);
            }
        });

    });

};
