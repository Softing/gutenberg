Inprint.cmp.UpdateDocument.Access = function(parent, form) {

    _a(["catalog.documents.assign:*"], null, function(terms) {

        if(terms["catalog.documents.assign"]) {
            form.getForm().findField("maingroup").enable();
            form.getForm().findField("manager").enable();
        }

    });

};
