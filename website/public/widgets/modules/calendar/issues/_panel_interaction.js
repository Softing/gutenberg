"use strict";

Inprint.calendar.issues.Interaction = function(parent, panels) {

    var issues = panels.issues;
    var attachments = panels.attachments;

    issues.on("afterrender", function() {
        _a(["editions.fascicle.manage:*"], null, function(access) {
            if (access["editions.fascicle.manage"] === true) {
                _enable(issues.btnCreate);
            }
        });
    });

    attachments.on("afterrender", function() {
        _a(["editions.attachment.manage:*"], null, function(access) {
            if (access["editions.attachment.manage"] === true) {
                _enable(attachments.btnCreate);
            }
        });
    });

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

        _a(["editions.fascicle.manage:*"], edition, function(access) {
            if (access["editions.fascicle.manage"] === true) {
                _enable(issues.btnCreate, issues.btnUpdate, issues.btnDelete,
                        issues.btnOpenPlan, issues.btnOpenComposer,
                        issues.btnDisable, issues.btnEnable,
                        issues.btnCopy, issues.btnProperties, issues.btnArchive, issues.btnFormat);
            }
        });

        attachments.enable();

        attachments.store.load({
            params: { edition: edition, issue: issue }
        });

    });

    attachments.on("rowclick", function(grid, rowIndex, e) {

        var record = grid.store.getAt(rowIndex);

        var issue   = record.get("id");
        var edition = record.get("edition");

        _disable(
                attachments.btnUpdate, attachments.btnDelete,
                attachments.btnOpenPlan, attachments.btnOpenComposer,
                attachments.btnDisable, attachments.btnEnable,
                attachments.btnCopy, attachments.btnProperties, attachments.btnArchive, attachments.btnFormat);

        _a(["editions.attachment.manage:*"], edition, function(access) {
            if (access["editions.attachment.manage"] === true) {
                _enable(attachments.btnUpdate, attachments.btnDelete,
                        attachments.btnOpenPlan, attachments.btnOpenComposer,
                        attachments.btnDisable, attachments.btnEnable,
                        attachments.btnCopy, attachments.btnProperties, attachments.btnArchive, attachments.btnFormat);
            }
        });

    });

};
