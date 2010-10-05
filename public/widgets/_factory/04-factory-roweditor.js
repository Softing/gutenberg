Inprint.factory.RowEditor = function(settings) {

    var editor = new Ext.ux.grid.RowEditor({
        clicksToEdit: 2,
        saveText: _("Update"),
        cancelText: _("Cancel")
    });

    editor.cmpRecord = Ext.data.Record.create(settings.record);

    editor.on("beforeedit", function(roweditor, number) {
        if ( roweditor.grid.getSelectionModel().getSelected().get("id")) {
            this.saveText = _("Update");
        } else {
            this.saveText = _("Create");
        }
        if ( roweditor.btns ) {
            roweditor.btns.items.first().setText(this.saveText);
        }
    });

    editor.on("canceledit", function(roweditor, forced) {
        if (!roweditor.record.data.id)
            roweditor.grid.getStore().remove(roweditor.record)
    });

    editor.on("afteredit", function(roweditor, obj, record, number) {
        Ext.Ajax.request({
            method:"post",
            params: record.data,
            url: record.phantom ? settings.create : settings.update,
            scope:editor,
            success: function() {
                this.fireEvent("success");
            }
        });
    });

    return editor;

}
