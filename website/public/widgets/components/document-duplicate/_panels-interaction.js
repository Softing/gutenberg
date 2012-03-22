Inprint.cmp.DuplicateDocument.Interaction = function(parent, panels) {

    var grid = panels.grid;

    grid.getSelectionModel().on("selectionchange", function(sm) {
        if (sm.getCount() > 0) {
            this.buttons[0].enable();
        }
        if (sm.getCount() === 0) {
            this.buttons[0].disable();
        }
    }, parent);

    parent.buttons[0].on("click", function(){

        var data = [];
        Ext.each(grid.getSelectionModel().getSelections(), function(record) {
            data.push(record.get("id") +'::'+ record.get("headline") +'::'+ record.get("rubric"));
        });

        Ext.Ajax.request({
            scope:this,
            url: _url("/documents/duplicate/"),
            params: {
                id: this.oid,
                copyto: data
            },
            success: function(form, action) {
                this.hide();
                this.fireEvent("actioncomplete", this);
            }
        });
    }, parent);

};
