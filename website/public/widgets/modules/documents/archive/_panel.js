// Inprint Content 5.0
// Copyright(c) 2001-2011, Softing, LLC.
// licensing@softing.ru
// http://softing.ru/license

Inprint.documents.archive.Panel = Ext.extend(Inprint.documents.Grid, {

    initComponent: function() {

        Ext.apply(this, {
            border: true,
            gridmode: "archive",
            stateful: true,
            stateId: "documents.grid.archive"
        });

        Inprint.documents.archive.Panel.superclass.initComponent.apply(this, arguments);

    },

    onRender: function() {

        Inprint.documents.archive.Panel.superclass.onRender.apply(this, arguments);

        this.btnRestore.hide();
        this.btnDelete.hide();

        this.getSelectionModel().on("selectionchange", function(sm) {

            var records = this.getSelectionModel().getSelections();
            var access = _arrayAccessCheck(records, ['delete', 'recover',
                'update', 'capture', 'move', 'transfer', 'briefcase']);

            _disable(this.btnUpdate, this.btnCapture, this.btnTransfer,
                this.btnMove, this.btnBriefcase, this.btnCopy,
                this.btnDuplicate, this.btnRecycle, this.btnRestore, this.btnDelete);

            if (sm.getCount() == 1) {
                if (access.move      == 'enabled') this.btnCopy.enable();
                if (access.move      == 'enabled') this.btnDuplicate.enable();
            }

            if (sm.getCount() > 0 ) {
                if (access.move      == 'enabled') this.btnCopy.enable();
                if (access.move      == 'enabled') this.btnDuplicate.enable();
            }

        }, this);

    }

});

Inprint.registry.register("documents-archive", {
    icon: "folders-stack",
    menutext:  _("Archive"),
    text:  _("Archival documents"),
    xobject: Inprint.documents.archive.Panel
});
