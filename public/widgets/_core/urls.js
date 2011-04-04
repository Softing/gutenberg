// Inprint Content 5.0
// Copyright(c) 2001-2011, Softing, LLC.
// licensing@softing.ru
// http://softing.ru/license

Inprint.sources = {

    "fascicle.read":            "/calendar/fascicle/read/",
    "fascicle.create":          "/calendar/fascicle/create/",
    "fascicle.update":          "/calendar/fascicle/update/",
    "fascicle.delete":          "/calendar/fascicle/delete/",
    "fascicle.deadline":        "/calendar/fascicle/deadline/",
    "fascicle.archive":         "/calendar/fascicle/archive/",
    "fascicle.unarchive":       "/calendar/fascicle/unarchive/",
    "fascicle.enable":          "/calendar/fascicle/enable/",
    "fascicle.disable":         "/calendar/fascicle/disable/",

    "attachment.read":          "/calendar/attachment/read/",
    "attachment.create":        "/calendar/attachment/create/",
    "attachment.update":        "/calendar/attachment/update/",
    "attachment.delete":        "/calendar/attachment/delete/",

    "":""
};

_source = function (key) {
    if (!Inprint.sources[key]) {
        alert("Can't find "+ key);
        return "404";
    }
    return _url(Inprint.sources[key]);
};
