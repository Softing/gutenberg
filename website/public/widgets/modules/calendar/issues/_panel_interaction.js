"use strict";

Inprint.calendar.issues.Interaction = function(parent, panels) {

    var issues = panels.issues;
    var attachments = panels.attachments;

    issues.on("afterrender", function() {
            _enable(issues.btnCreate);
        });

    issues.getSelectionModel().on("selectionchange", function(sm, node) {

        var issue = issues.cmpGetValue("id");
        var edition = issues.cmpGetValue("edition");

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
        _enable(attachments.btnCreate);

        attachments.cmpLoad({ edition: edition, issue: issue, fastype: "attachment", archive: false});

        //_a(["editions.template.manage:*"], edition, function(access) {
        //});

    });

    //attachments.on("afterrender", function() {
    //        _enable(attachments.btnCreate);
    //    });

    attachments.getSelectionModel().on("selectionchange", function(sm, node) {

        var issue = issues.cmpGetValue("id");
        var edition = issues.cmpGetValue("edition");

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
