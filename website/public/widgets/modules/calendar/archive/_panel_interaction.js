"use strict";

Inprint.calendar.archive.Interaction = function(parent, panels) {

    var issues = panels.issues;
    var attachments = panels.attachments;

    issues.getSelectionModel().on("selectionchange", function(sm, node) {

        var issue = issues.cmpGetValue("id");
        var edition = issues.cmpGetValue("edition");

        _disable(issues.btnOpenPlan, issues.btnCopy, issues.btnUnarchive);
        _enable(issues.btnOpenPlan, issues.btnCopy, issues.btnUnarchive);

        attachments.enable();
        attachments.cmpLoad({ edition: edition, issue: issue, fastype: "attachment", archive: true });

        //_a(["editions.template.manage:*"], edition, function(access) {});

    });

    attachments.getSelectionModel().on("selectionchange", function(sm, node) {

        var issue = issues.cmpGetValue("id");
        var edition = issues.cmpGetValue("edition");

        _disable(attachments.btnOpenPlan, attachments.btnCopy, attachments.btnUnArchive);
        _enable(attachments.btnOpenPlan, attachments.btnCopy, attachments.btnUnArchive);

    });

};
