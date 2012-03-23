Inprint.fx.Button = function(disabled, title, tooltip, icon, callback) {

    var hash = {
        text: _(title),
        tooltip: _(tooltip),
        icon: _ico(icon),
        handler: callback,
        disabled: disabled,
        cls: 'x-btn-text-icon'
    };

    return {
        id: function(val) {
            hash["id"] = val;
            return this;
        },
        ref: function(val) {
            hash["ref"] = val;
            return this;
        },
        render: function() {
            return hash;
        }
    }
}

Inprint.fx.ButtonRef = function(title, description, ref, icon, callback) {
    return {
        text: _(title),
        icon: _ico(icon),
        cls: 'x-btn-text-icon',
        ref: ref,
        handler: callback
    };
}

Inprint.fx.btn.Create = function(callback) {
    return {
        text: _("Create"),
        icon: _ico("plus-button"),
        cls: 'x-btn-text-icon',
        handler: callback
    };
}

Inprint.fx.btn.Delete = function(callback) {
    return {
        text: _("Delete"),
        icon: _ico("minus-button"),
        cls: 'x-btn-text-icon',
        handler: callback
    };
}

Inprint.fx.btn.Edit = function(callback) {
    return {
        text: _("Edit"),
        icon: _ico("pencil"),
        cls: 'x-btn-text-icon',
        handler: callback
    };
}

Inprint.fx.btn.Copy = function(callback) {
    return {
        text: _("Copy"),
        icon: _ico("document-copy"),
        cls: 'x-btn-text-icon',
        handler: callback
    };
}
