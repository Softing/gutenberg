Inprint.cmp.CreateDocument.Access = function(parent, form) {

    _a(["catalog.documents.create:*", "catalog.documents.assign:*", "editions.documents.assign"], null, function(terms) {
        if(terms["catalog.documents.create"]) {
            parent.buttons[0].enable();
        }
        if(terms["catalog.documents.assign"]) {
            form.getForm().findField("workgroup").enable();
            form.getForm().findField("manager").enable();
        }
        if(terms["editions.documents.assign"]) {
            form.getForm().findField("fascicle").enable();
            form.getForm().findField("headline").enable();
        }
    });

};
