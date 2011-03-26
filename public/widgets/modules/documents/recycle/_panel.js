// Inprint Content 5.0
// Copyright(c) 2001-2011, Softing, LLC.
// licensing@softing.ru
// http://softing.ru/license

Inprint.documents.recycle.Panel = Ext.extend(Inprint.documents.Grid, {

    initComponent: function() {

        Ext.apply(this, {
            border: true,
            gridmode: "recycle",
            stateful: true,
            stateId: "documents.grid.recycle"
        });

        Inprint.documents.recycle.Panel.superclass.initComponent.apply(this, arguments);

    },

    onRender: function() {

        Inprint.documents.recycle.Panel.superclass.onRender.apply(this, arguments);

        this.filter.getForm().findField("fascicle").on("afterrender", function(combo) {
            combo.setValue("99999999-9999-9999-9999-999999999999", _("Recycle bin"));
            combo.disable();
        });

        this.btnRecycle.hide();

        this.getSelectionModel().on("selectionchange", function(sm) {

            var records = this.getSelectionModel().getSelections();
            var access = _arrayAccessCheck(records, ['delete', 'recover',
                'update', 'capture', 'move', 'transfer', 'briefcase']);

            _disable(this.btnUpdate, this.btnCapture, this.btnTransfer,
                this.btnMove, this.btnBriefcase, this.btnCopy,
                this.btnDuplicate, this.btnRecycle, this.btnRestore, this.btnDelete);

            if (sm.getCount() == 1) {
                if (access.update    == 'enabled') this.btnUpdate.enable();
                if (access.capture   == 'enabled') this.btnCapture.enable();
                if (access.transfer  == 'enabled') this.btnTransfer.enable();
                if (access.briefcase == 'enabled') this.btnBriefcase.enable();
                if (access.move      == 'enabled') this.btnCopy.enable();
                if (access.move      == 'enabled') this.btnDuplicate.enable();
                if (access.recover   == 'enabled') this.btnRestore.enable();
                if (access["delete"] == 'enabled') this.btnRecycle.enable();
                if (access["delete"] == 'enabled') this.btnDelete.enable();
            }

            if (sm.getCount() > 0 ) {
                if (access.update    == 'enabled') this.btnCapture.enable();
                if (access.transfer  == 'enabled') this.btnTransfer.enable();
                if (access.briefcase == 'enabled') this.btnBriefcase.enable();
                if (access.move      == 'enabled') this.btnMove.enable();
                if (access.move      == 'enabled') this.btnCopy.enable();
                if (access.move      == 'enabled') this.btnDuplicate.enable();
                if (access.recover   == 'enabled') this.btnRestore.enable();
                if (access["delete"] == 'enabled') this.btnRecycle.enable();
                if (access["delete"] == 'enabled') this.btnDelete.enable();
            }

        }, this);

    }

});

Inprint.registry.register("documents-recycle", {
    icon: "bin",
    text:  _("Recycle"),
    xobject: Inprint.documents.recycle.Panel
});
