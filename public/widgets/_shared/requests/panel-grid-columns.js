// Inprint Content 5.0
// Copyright(c) 2001-2011, Softing, LLC.
// licensing@softing.ru
// http://softing.ru/license

Inprint.grid.columns.Request = function() {

    return {

        serial: {
            id:"searial",
            width: 50,
            header: _("NN"),
            dataIndex: "serialnum"
        },

        check: {
            id:"check",
            width: 30,
            header: "",
            dataIndex: "check_status",
            renderer: function(v, p, r) {
                var result = "";
                switch (v)
                {
                    case "error":
                        result = "<img src=\""+ _ico("exclamation-red") +"\">";
                        break;
                    case "check":
                        result = "<img src=\""+ _ico("exclamation-octagon") +"\">";
                        break;
                    case "ready":
                        result = "<img src=\""+ _ico("tick-circle") +"\">";
                        break;
                    case "imposed":
                        result = "<img src=\""+ _ico("printer") +"\">";
                        break;
                    default:
                }
                return "<div align=\"center\">"+ result +"</div>";
            }
        },

        another: {
            id: "another",
            width: 60,
            header: _("Another"),
            dataIndex: "anothers_layout",
            renderer: function(v, p, r) {
                var result = "";
                if (v) {
                    result = "<img src=\""+ _ico("status") +"\">";
                }
                return "<div align=\"center\">"+ result +"</div>";
            }
        },

        title: {
            id:"title",
            width: 350,
            header: _("Title"),
            dataIndex: "shortcut"
        },

        advertiser: {
            id:"advertiser",
            width: 200,
            header: _("Advertiser"),
            dataIndex: "advertiser_shortcut"
        },

        manager: {
            id:"manager",
            width: 120,
            header: _("Manager"),
            dataIndex: "manager_shortcut"
        },

        position: {
            id:"position",
            width: 100,
            header: _("Place"),
            dataIndex: "place_shortcut"
        },

        template: {
            id:"template",
            width: 100,
            header: _("Template"),
            dataIndex: "origin_shortcut"
        },

        module: {
            id:"module",
            width: 100,
            header: _("Module"),
            dataIndex: "module_shortcut"
        },

        pages: {
            id:"pages",
            width: 60,
            header: _("Pages"),
            dataIndex: "pages"
        },

        status: {
            id:"status",
            width: 60,
            header: _("Status"),
            dataIndex: "status"
        },

        payment: {
            id:"payment",
            width: 60,
            header: _("Payment"),
            dataIndex: "payment"
        },

        readiness: {
            id:"readiness",
            width: 80,
            header: _("Readiness"),
            dataIndex: "readiness"
        },

        modified: {
            id:"modified",
            width: 110,
            header: _("Modified"),
            xtype: 'datecolumn',
            format: "Y-m-d H:i",
            dataIndex: "updated"
        }

    };

};
