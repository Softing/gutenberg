Inprint.fx.btn.Button = function(ref, icon, title, tooltip, callback) {
    return {
        text: _(title),
        tooltip: _(tooltip),
        icon: _ico(icon),
        ref: ref,
        handler: callback,
        disabled: true,
        cls: 'x-btn-text-icon'
    };
}

Inprint.fx.btn.Create = function(ref, callback) {
    return Inprint.fx.btn.Button(ref, "plus-button", "Create", "", callback);
}
Inprint.fx.btn.Delete = function(ref, callback) {
    return Inprint.fx.btn.Button(ref, "minus-button", "Delete", "", callback);
}
Inprint.fx.btn.Update = function(ref, callback) {
    return Inprint.fx.btn.Button(ref, "pencil", "Edit", "", callback);
}
Inprint.fx.btn.Copy = function(ref, callback) {
    return Inprint.fx.btn.Button(ref, "document-copy", "Copy", "", callback);
}

