"use strict";

Inprint.calendar.archive.Interaction = function(parent, panels) {

    var issues = panels.issues;
    var attachments = panels.attachments;

    issues.store.on("beforeload", function(store, records, options) {
        attachments.disable();
        attachments.store.removeAll();
    });

    issues.on("rowclick", function(grid, rowIndex, e) {

        var record = grid.store.getAt(rowIndex);

        var issue   = record.get("id");
        var edition = record.get("edition");

        _disable(issues.btnOpenPlan, issues.btnCopy, issues.btnUnarchive);
        _enable(issues.btnOpenPlan, issues.btnCopy, issues.btnUnarchive);

        attachments.enable();
        attachments.cmpLoad({ edition: edition, issue: issue });

        //_a(["editions.template.manage:*"], edition, function(access) {});

    });

    attachments.on("rowclick", function(grid, rowIndex, e) {

        var record = grid.store.getAt(rowIndex);

        var issue   = record.get("id");
        var edition = record.get("edition");

        _disable(attachments.btnOpenPlan, attachments.btnCopy, attachments.btnUnArchive);
        _enable(attachments.btnOpenPlan, attachments.btnCopy, attachments.btnUnArchive);

    });

};
