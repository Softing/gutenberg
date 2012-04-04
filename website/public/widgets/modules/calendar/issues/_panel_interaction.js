"use strict";

Inprint.calendar.issues.Interaction = function(parent, panels) {

    var issues = panels.issues;
    var attachments = panels.attachments;

    issues.on("afterrender", function() { _enable(issues.btnCreate); });

    issues.store.on("beforeload", function(store, records, options) {
        attachments.disable();
        attachments.store.removeAll();
    });

    issues.on("rowclick", function(grid, rowIndex, e) {

        var record = grid.store.getAt(rowIndex);

        var issue   = record.get("id");
        var edition = record.get("edition");

        _disable(
                issues.btnCreate, issues.btnUpdate, issues.btnDelete,
                issues.btnOpenPlan, issues.btnOpenComposer,
                issues.btnDisable, issues.btnEnable,
                issues.btnCopy, issues.btnProperties, issues.btnArchive, issues.btnFormat);

        _enable(
                issues.btnCreate, issues.btnUpdate, issues.btnDelete,
                issues.btnOpenPlan, issues.btnOpenComposer,
                issues.btnDisable, issues.btnEnable,
                issues.btnCopy, issues.btnProperties, issues.btnArchive, issues.btnFormat);

        attachments.enable();
        _enable(attachments, attachments.btnCreate);

        attachments.store.load({
            params: { edition: edition, issue: issue }
        });

        //_a(["editions.template.manage:*"], edition, function(access) {
        //});

    });

    attachments.on("rowclick", function(grid, rowIndex, e) {

        var record = grid.store.getAt(rowIndex);

        var issue   = record.get("id");
        var edition = record.get("edition");

        _disable(
                attachments.btnCreate, attachments.btnUpdate, attachments.btnDelete,
                attachments.btnOpenPlan, attachments.btnOpenComposer,
                attachments.btnDisable, attachments.btnEnable,
                attachments.btnCopy, attachments.btnProperties, attachments.btnArchive, attachments.btnFormat);
        _enable(
                attachments.btnCreate, attachments.btnUpdate, attachments.btnDelete,
                attachments.btnOpenPlan, attachments.btnOpenComposer,
                attachments.btnDisable, attachments.btnEnable,
                attachments.btnCopy, attachments.btnProperties, attachments.btnArchive, attachments.btnFormat);

    });

};
