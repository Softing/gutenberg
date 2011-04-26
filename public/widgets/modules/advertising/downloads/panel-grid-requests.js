Inprint.advertising.downloads.Requests = Ext.extend(Ext.grid.GridPanel, {

    initComponent: function() {

        this.access = {};
        this.config = {};
        this.urls = {};

        this.sm = new Ext.grid.CheckboxSelectionModel();

        this.store = Inprint.factory.Store.json(
            _source("requests.list"),
            {
                remoteSort:true
            });

        // Column model
        var  columns  = Inprint.grid.columns.Request();

        this.colModel = new Ext.grid.ColumnModel({
            defaults: {
                sortable: true,
                menuDisabled:true
            },
            columns: [
                this.sm,
                columns.serial,
                columns.check,
                columns.edition,
                columns.advertiser,
                columns.title,
                columns.another,
                columns.position,
                columns.module,
                columns.pages
            ]
        });

        this.tbar = [
            {
                scope:this,
                text: _("All requests"),
                cls: "x-btn-text-icon",
                icon: _ico("moneys"),
                handler : function() {
                    this.cmpLoad({ flt_checked: "all" });
                }
            },
            {
                scope:this,
                text: _("To check"),
                cls: "x-btn-text-icon",
                icon: _ico("exclamation-octagon"),
                handler : function() {
                    this.cmpLoad({ flt_checked: "check" });
                }
            },
            {
                scope:this,
                text: _("With errors"),
                cls: "x-btn-text-icon",
                icon: _ico("exclamation-red"),
                handler : function() {
                    this.cmpLoad({ flt_checked: "error" });
                }
            },
            {
                scope:this,
                text: _("Ready"),
                cls: "x-btn-text-icon",
                icon: _ico("tick-circle"),
                handler : function() {
                    this.cmpLoad({ flt_checked: "ready" });
                }
            },
            {
                scope:this,
                text: _("Imposed"),
                cls: "x-btn-text-icon",
                icon: _ico("printer"),
                handler : function() {
                    this.cmpLoad({ flt_checked: "imposed" });
                }
            }
        ];

        Ext.apply(this, {
            border: false,
            disabled: true,
            stripeRows: true,
            columnLines: true
        });

        // Call parent (required)
        Inprint.advertising.downloads.Requests.superclass.initComponent.apply(this, arguments);
    },

    onRender: function() {
        Inprint.advertising.downloads.Requests.superclass.onRender.apply(this, arguments);

        this.on("rowcontextmenu", function(thisGrid, rowIndex, evtObj) {

            evtObj.stopEvent();

            var rowCtxMenuItems = [];

            var record = thisGrid.getStore().getAt(rowIndex);
            var selCount = thisGrid.getSelectionModel().getCount();

            if (selCount > 0) {

                rowCtxMenuItems.push({
                    icon: _ico("exclamation-octagon"),
                    cls: "x-btn-text-icon",
                    text: _("To check"),
                    scope:this,
                    handler: function() {
                        this.cmpSetStatus("check");
                    }
                });
                rowCtxMenuItems.push({
                    icon: _ico("exclamation-red"),
                    cls: "x-btn-text-icon",
                    text: _("With errors"),
                    scope:this,
                    handler: function() {
                        this.cmpSetStatus("error");
                    }
                });
                rowCtxMenuItems.push({
                    icon: _ico("tick-circle"),
                    cls: "x-btn-text-icon",
                    text: _("Ready"),
                    scope:this,
                    handler: function() {
                        this.cmpSetStatus("ready");
                    }
                });
                rowCtxMenuItems.push({
                    icon: _ico("printer"),
                    cls: "x-btn-text-icon",
                    text: _("Imposed"),
                    scope:this,
                    handler: function() {
                        this.cmpSetStatus("imposed");
                    }
                });


                if (rowCtxMenuItems.length > 0) {
                    rowCtxMenuItems.push("-");
                }

                rowCtxMenuItems.push({
                    icon: _ico("user-silhouette"),
                    cls: "x-btn-text-icon",
                    text: _("Is another's"),
                    scope:this,
                    handler: function() {
                        this.cmpSetStatus("anothers");
                    }
                });
                rowCtxMenuItems.push({
                    icon: _ico("user"),
                    cls: "x-btn-text-icon",
                    text: _("Isn't another's"),
                    scope:this,
                    handler: function() {
                        this.cmpSetStatus("notanothers");
                    }
                });

                if (rowCtxMenuItems.length > 0) {
                    rowCtxMenuItems.push("-");
                }

                rowCtxMenuItems.push({
                    icon: _ico("arrow-transition-090"),
                    cls: "x-btn-text-icon",
                    text: _("Download"),
                    scope:this,
                    handler: this.cmpSave
                });
                rowCtxMenuItems.push({
                    icon: _ico("arrow-transition-090"),
                    cls: "x-btn-text-icon",
                    text: _("Safe download"),
                    scope:this,
                    handler: this.cmpSaveSafe
                });

                thisGrid.rowCtxMenu = new Ext.menu.Menu({
                    items : rowCtxMenuItems
                });

                thisGrid.rowCtxMenu.showAt(evtObj.getXY());
            }

        }, this);

    },

    setFascicle: function(fascicle) {
        this.fascicle = fascicle;
    },

    cmpSetStatus: function (status) {
        var selection = this.getValues("id");
        Ext.Ajax.request({
            url: _source("requests.status"),
            scope:this,
            success: this.cmpReload,
            params: { id: selection, status: status }
        });
    },

    cmpSave: function (params) {

        // generate a new unique id
        var frameid = Ext.id();

        // create a new iframe element
        var frame = document.createElement('iframe');
        frame.id = frameid;
        frame.name = frameid;
        frame.className = 'x-hidden';

        // use blank src for Internet Explorer
        if (Ext.isIE) {
            frame.src = Ext.SSL_SECURE_URL;
        }

        // append the frame to the document
        document.body.appendChild(frame);

        // also set the name for Internet Explorer
        if (Ext.isIE) {
            document.frames[frameid].name = frameid;
        }

        //  create a new form element
        var form = Ext.DomHelper.append(document.body, {
            tag: "form",
            method: "post",
            action: "/downloads/download/",
            target: frameid
        });

        if (params && params.translitEnabled) {
            var hidden = document.createElement("input");
            hidden.type = "hidden";
            hidden.name = "safemode";
            hidden.value = "true";
            form.appendChild(hidden);
        }

        Ext.each(this.getSelectionModel().getSelections(), function(record) {
            var hidden = document.createElement("input");
            hidden.type = "hidden";
            hidden.name = "file[]";
            hidden.value = record.get("document") +"::"+ record.get("id");
            form.appendChild(hidden);
        });

        document.body.appendChild(form);

        form.submit();
    },

    cmpSaveSafe: function() {
        this.cmpSave({
            translitEnabled: true
        });
    }

});
