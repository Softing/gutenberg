// Inprint Content 5.0
// Copyright(c) 2001-2011, Softing, LLC.
// licensing@softing.ru
// http://softing.ru/license

Inprint.advertising.downloads.Summary = Ext.extend(Ext.grid.GridPanel, {

    initComponent: function() {

        this.store = new Ext.data.JsonStore({
            root: "data",
            idProperty: "id",
            autoDestroy: true,
            url: _source("requests.summary"),
            baseParams: { fascicle: this.fascicle },
            fields: [ "id", "shortcut", "edition", "edition_shortcut", "total", "check", "error", "ready", "anothers", "debt", "imposed" ]
        });

        this.colModel = new Ext.grid.ColumnModel({
            defaults: {
                sortable: true,
                menuDisabled:true
            },
            columns: [
                {   id:"edition",
                    header: _("Edition"),
                    dataIndex: "edition_shortcut"
                },
                {   id:"fascicle",
                    header: _("Fascicle"),
                    dataIndex: "shortcut"
                },

                {   id:"total",
                    header: _("Total requests"),
                    dataIndex: "total"
                },
                {   id:"uploaded",
                    header: _("To check"),
                    dataIndex: "check"
                },
                {   id:"updated",
                    header: _("With errors"),
                    dataIndex: "error"
                },
                {   id:"mariage",
                    header: _("Ready"),
                    dataIndex: "ready"
                },

                {   id:"foreign",
                    header: _("Another's"),
                    dataIndex: "anothers"
                },
                {   id:"debt",
                    header: _("Debt"),
                    dataIndex: "debt"
                },
                {   id:"maked",
                    header: _("Imposed"),
                    dataIndex: "imposed"
                }
            ]
        });

        Ext.apply(this, {
            border: true,
            stripeRows: true,
            columnLines: true,
            title: _("Summary")
        });

        // Call parent (required)
        Inprint.advertising.downloads.Summary.superclass.initComponent.apply(this, arguments);
    },

    onRender: function() {
        Inprint.advertising.downloads.Summary.superclass.onRender.apply(this, arguments);
    },

    setFascicle: function(fascicle) {
        this.fascicle = fascicle;
    }
});
