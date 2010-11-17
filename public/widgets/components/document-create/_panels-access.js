Inprint.cmp.CreateDocument.Access = function(parent, form) {
    _a(["catalog.documents.create:*", "catalog.documents.assign-manager:*", "catalog.documents.assign-fascicle:*"], null, function(terms) {
        if(terms["catalog.documents.create"]) {
            parent.buttons[0].enable();
        }
        if(terms["catalog.documents.assign-manager"]) {
            form.getForm().findField("workgroup").enable();
            form.getForm().findField("manager").enable();
        }
        if(terms["catalog.documents.assign-fascicle"]) {
            form.getForm().findField("fascicle").enable();
        }
    });
};
