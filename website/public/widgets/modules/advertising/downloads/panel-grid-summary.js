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
            fields: [ "id", "shortcut", "edition", "edition_shortcut", "total", "check", "error", "ready", "anothers", "imposed" ]
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
                    scope:this,
                    dataIndex: "total",
                    renderer: function(v, p, r) {
                        return String.format("<a id=\"total-{1}\" href=\"javascript:void(0);\">{0}</a>", r.get("total"), r.get("id"));
                    }
                },
                {   id:"check",
                    header: _("To check"),
                    dataIndex: "check",
                    renderer: function(v, p, r) {
                        return String.format("<a id=\"check-{1}\" href=\"javascript:void(0);\">{0}</a>", r.get("check"), r.get("id"));
                    }
                },
                {   id:"error",
                    header: _("With errors"),
                    dataIndex: "error",
                    renderer: function(v, p, r) {
                        return String.format("<a id=\"error-{1}\" href=\"javascript:void(0);\">{0}</a>", r.get("error"), r.get("id"));
                    }
                },
                {   id:"ready",
                    header: _("Ready"),
                    dataIndex: "ready",
                    renderer: function(v, p, r) {
                        return String.format("<a id=\"ready-{1}\" href=\"javascript:void(0);\">{0}</a>", r.get("ready"), r.get("id"));
                    }
                },
                {   id:"imposed",
                    header: _("Imposed"),
                    dataIndex: "imposed",
                    renderer: function(v, p, r) {
                        return String.format("<a id=\"imposed-{1}\" href=\"javascript:void(0);\">{0}</a>", r.get("imposed"), r.get("id"));
                    }
                },
                {   id:"anothers",
                    header: _("Another's"),
                    dataIndex: "anothers"
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

        this.on("rowclick", function(grid, ri, e) {

                var filter;
                var record = grid.getStore().getAt(ri);

                if(e.within_el('total-'+record.get("id"))) {
                    filter = "all";
                }
                if(e.within_el('check-'+record.get("id"))) {
                    filter = "check";
                }
                if(e.within_el('error-'+record.get("id"))) {
                    filter = "error";
                }
                if(e.within_el('ready-'+record.get("id"))) {
                    filter = "ready";
                }
                if(e.within_el('imposed-'+record.get("id"))) {
                    filter = "imposed";
                }

                if (filter) {
                    this.parent.cmpShowRequests(record.get("id"), filter);
                }

            });
    },

    setFascicle: function(fascicle) {
        this.fascicle = fascicle;
    }
});
