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

    "requests.files.list":              "/advertising/requests/files/list/",
    "requests.files.upload":            "/advertising/requests/files/upload/",
    "requests.files.delete":            "/advertising/requests/files/delete/",

    "requests.create":                  "/advertising/requests/create/",
    "requests.read":                    "/advertising/requests/read/",
    "requests.update":                  "/advertising/requests/update/",
    "requests.delete":                  "/advertising/requests/delete/",
    "requests.status":                  "/advertising/requests/status/",

    "fascicle.list":                    "/calendar/list/",
    "fascicle.read":                    "/calendar/fascicle/read/",
    "fascicle.create":                  "/calendar/fascicle/create/",
    "fascicle.update":                  "/calendar/fascicle/update/",
    "fascicle.remove":                  "/calendar/fascicle/remove/",
    "fascicle.deadline":                "/calendar/fascicle/deadline/",
    "fascicle.archive":                 "/calendar/fascicle/archive/",
    "fascicle.unarchive":               "/calendar/fascicle/unarchive/",
    "fascicle.enable":                  "/calendar/fascicle/enable/",
    "fascicle.disable":                 "/calendar/fascicle/disable/",
    "fascicle.template":                "/calendar/fascicle/template/",

    "attachment.read":                  "/calendar/attachment/read/",
    "attachment.create":                "/calendar/attachment/create/",
    "attachment.update":                "/calendar/attachment/update/",
    "attachment.delete":                "/calendar/attachment/delete/",

    "":""
};

_source = function (key) {
    if (!Inprint.sources[key]) {
        alert("Can't find source "+ key);
        return "404";
    }
    return _url(Inprint.sources[key]);
};
