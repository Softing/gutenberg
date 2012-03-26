// Inprint Content 5.0
// Copyright(c) 2001-2011, Softing, LLC.
// licensing@softing.ru
// http://softing.ru/license

Inprint.sources = {

    "common.tree.editions":             "/common/tree/editions/",
    "common.tree.fascicles":            "/common/tree/fascicles/",
    "common.tree.departments":          "/common/tree/departments/",

    "advertisers.list":                 "/advertisers/list/",
    "advertisers.create":               "/advertisers/create/",
    "advertisers.read":                 "/advertisers/read/",
    "advertisers.update":               "/advertisers/update/",
    "advertisers.delete":               "/advertisers/delete/",

    "requests.list":                    "/advertising/requests/list/",
    "requests.summary":                 "/advertising/requests/summary/",
    "requests.comments.list":           "/advertising/requests/comments/list/",
    "requests.comments.save":           "/advertising/requests/comments/save/",
    "requests.download":                "/advertising/requests/download/",
    "requests.create":                  "/advertising/requests/create/",
    "requests.read":                    "/advertising/requests/read/",
    "requests.update":                  "/advertising/requests/update/",
    "requests.delete":                  "/advertising/requests/delete/",
    "requests.status":                  "/advertising/requests/status/",

    "requests.files.list":              "/advertising/requests/files/list/",
    "requests.files.upload":            "/advertising/requests/files/upload/",
    "requests.files.download":          "/advertising/requests/files/download/",
    "requests.files.delete":            "/advertising/requests/files/delete/",

    "calendar.archive":                 "/calendar/archive/",
    "calendar.unarchive":               "/calendar/unarchive/",
    "calendar.enable":                  "/calendar/enable/",
    "calendar.disable":                 "/calendar/disable/",
    "calendar.copy":                    "/calendar/copy/",
    "calendar.format":                  "/calendar/format/",

    "issue.create":                     "/calendar/fascicle/create/",
    "issue.read":                       "/calendar/fascicle/read/",
    "issue.update":                     "/calendar/fascicle/update/",
    "issue.delete":                     "/calendar/fascicle/remove/",
    "issue.list":                       "/calendar/fascicle/list/",
    "issue.copy":                       "/calendar/fascicle/copy/",

    "attachment.create":                "/calendar/attachment/create/",
    "attachment.read":                  "/calendar/attachment/read/",
    "attachment.update":                "/calendar/attachment/update/",
    "attachment.delete":                "/calendar/attachment/remove/",
    "attachment.list":                  "/calendar/attachment/list/",
    "attachment.copy":                  "/calendar/attachment/copy/",

    "template.list":                    "/calendar/template/list/",
    "template.read":                    "/calendar/template/read/",
    "template.create":                  "/calendar/template/create/",
    "template.update":                  "/calendar/template/update/",
    "template.delete":                  "/calendar/template/remove/",

    "documents.downloads.list":         "/documents/downloads/list/",
    "documents.downloads.download":     "/documents/downloads/download/",

    "":""
};

_source = function (key) {
    if (!Inprint.sources[key]) {
        alert("Can't find source "+ key);
        return "404";
    }
    return _url(Inprint.sources[key]);
};
