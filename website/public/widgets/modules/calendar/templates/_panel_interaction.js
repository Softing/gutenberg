Inprint.calendar.templates.Interaction = function(parent, panels) {

    var templates = panels.templates;

    templates.on("afterrender", function() {
        _enable(templates.btnCreate);
    });

    templates.getSelectionModel().on("selectionchange", function(sm, node) {

        var issue = templates.cmpGetValue("id");
        var edition = templates.cmpGetValue("edition");

        _disable(
                templates.btnCreate, templates.btnUpdate, templates.btnDelete,
                templates.btnOpenPlan, templates.btnOpenComposer);

        _enable(
                templates.btnCreate, templates.btnUpdate, templates.btnDelete,
                templates.btnOpenPlan, templates.btnOpenComposer);

    });

};
