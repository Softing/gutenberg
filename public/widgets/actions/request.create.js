Inprint.setAction("request.create", function(parent) {

    var url = _url("/catalog/rubrics/create/");

    var form = new Ext.FormPanel({
        url: url,
        region: "north",
        border:true,
        labelWidth: 75,
        height: 150,
        bodyStyle: "padding:5px 5px",
        items: [
            _FLD_HDN_FASCICLE,
            {
                border: false,
                layout:'column',
                items:[
                    {
                        columnWidth:.5,
                        border: false,
                        layout: 'form',
                        defaults: {
                            anchor: "98%",
                            allowBlank:false
                        },
                        items: [
                            {
                                xtype: "titlefield",
                                value: _("Request")
                            },
                            _FLD_SHORTCUT,
                            _FLD_DESCRIPTION
                        ]
                    },
                    {
                        columnWidth:.5,
                        border: false,
                        layout: 'form',
                        defaults: {
                            anchor: "100%",
                            allowBlank:false
                        },
                        items: [

                            {
                                xtype: "titlefield",
                                value: _("Parameters")
                            },

                            {
                                xtype: 'radiogroup',
                                columns: [80, 80, 80],
                                fieldLabel: _("Request"),
                                style: "margin-bottom:10px",
                                name: "status",
                                items: [
                                    { name: "status", inputValue: "possible",    boxLabel: _("Possible") },
                                    { name: "status", inputValue: "active",      boxLabel: _("Active") },
                                    { name: "status", inputValue: "reservation", boxLabel: _("Reservation"), checked: true }
                                ]
                            },

                            {
                                xtype: 'radiogroup',
                                columns: [40, 40],
                                fieldLabel: _("Squib"),
                                style: "margin-bottom:10px",
                                name: "squib",
                                items: [
                                    { name: "squib", inputValue: "yes",    boxLabel: _("Yes") },
                                    { name: "squib", inputValue: "no", boxLabel: _("No"), checked: true }
                                ]
                            },

                            {
                                allowBlank:true,
                                columns: [90, 90],
                                xtype: 'checkboxgroup',
                                fieldLabel: _("Properties"),
                                style: "margin-bottom:10px",
                                name: "squib",
                                items: [
                                    { name: "properties", inputValue: "payment", boxLabel: _("Paid") },
                                    { name: "properties", inputValue: "approved",  boxLabel: _("Approved") }
                                ]
                            }

                        ]
                    }
                ]
            }

        ],
        keys: [ _KEY_ENTER_SUBMIT ]
    });

    form.on("actioncomplete", function (form, action) {
        if (action.type == "submit") {
            win.hide();
            grid.cmpReload();
        }
    });

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

    var panel = new Ext.Panel({
        border:false,
        layout: "border",
        margins: "3 0 3 3",
        defaults: {
            split: true
        },
        items: [
            form,
            grid
        ]
    });

    var win = Inprint.factory.windows.create(
        "Create request", 800, 600, panel,
        [ _BTN_WNDW_FORM_ADD, _BTN_WNDW_FORM_CLOSE ]
    );
    win.border = false;
    win.show();

});
