Inprint.setAction("request.placing", function(parent) {

var url = _url("/catalog/rubrics/create/");

    var selectionModel = new Ext.grid.CheckboxSelectionModel({
        singleSelect:true });
    var xcolumns = Inprint.advertising.advertisers.Columns;

    var grid = new Ext.grid.GridPanel({
        region:"center",
        border: true,
        stripeRows: true,
        columnLines: true,
        sm: selectionModel,
        autoExpandColumn: "shortcut",
        store: Inprint.factory.Store.json(
            _source("advertisers.list"),
            {
                autoLoad: true,
                totalProperty: 'total',
                baseParams: {
                    showDefaults: true
                }
            }),
        columns: [
            selectionModel,
            xcolumns.serial,
            xcolumns.edition,
            xcolumns.shortcut
        ]
    });

    var win = Inprint.factory.windows.create(
        "Placing request", 800, 600, grid,
        [ _BTN_WNDW_FORM_ADD, _BTN_WNDW_FORM_CLOSE ]
    );
    win.border = false;
    win.show();

});
