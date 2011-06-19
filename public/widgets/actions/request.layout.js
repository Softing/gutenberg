Inprint.setAction("request.layout", function(parent) {

    var url = _url("/catalog/rubrics/create/");

    var flash = new Inprint.cmp.request.Flash({
        region: "south",
        disabled:true,
        split: true,
        border:true,
        height:200
        });

    var templatesSM = new Ext.grid.CheckboxSelectionModel({
        singleSelect:true });

    var templates = new Ext.grid.GridPanel({
        region: "center",
        border:true,
        stripeRows: true,
        columnLines: true,
        sm: templatesSM,
        autoExpandColumn: "title",
        store: Inprint.factory.Store.json(
            "/fascicle/composer/templates/", {
                autoLoad: true,
                baseParams: {
                    fascicle: null
                }
            }),
        columns: [
            templatesSM,
            {
                id:"place_title",
                header: _("Place"),
                width: 100,
                sortable: true,
                dataIndex: "place_title"
            },
            {
                id:"title",
                header: _("Title"),
                width: 100,
                sortable: true,
                dataIndex: "title"
            }
        ]
    });

    var pagesSM = new Ext.grid.CheckboxSelectionModel({
        singleSelect:true });

    var pages = new Ext.grid.GridPanel({
        region:"south",
        height:200,
        split: true,
        border:true,
        disabled:true,
        stripeRows: true,
        columnLines: true,
        sm: pagesSM,
        autoExpandColumn: "title",
        store: Inprint.factory.Store.json(
            "/fascicle/composer/pages/", {
                baseParams: {
                    fascicle: null
                }
            }),
        columns: [
            pagesSM,
            {
                id:"place_title",
                header: _("Place"),
                width: 100,
                sortable: true,
                dataIndex: "place_title"
            },
            {
                id:"title",
                header: _("Title"),
                width: 100,
                sortable: true,
                dataIndex: "title"
            }
        ]
    });

    var panel = new Ext.Panel({
        border:false,
        layout: "border",
        margins: "3 0 3 3",
        items: [
            {
                border:false,
                region: "center",
                layout: "border",
                items: [
                    templates,
                    pages
                ]
            },
            flash
        ]
    });

    var win = Inprint.factory.windows.create(
        "Change request layout", 800, 600, panel,
        [ _BTN_WNDW_FORM_OK, _BTN_WNDW_FORM_CLOSE ]
    );
    win.border = false;
    win.show();

});
