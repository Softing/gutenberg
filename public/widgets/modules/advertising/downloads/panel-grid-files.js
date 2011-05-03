Inprint.advertising.downloads.Files = Ext.extend(Ext.grid.GridPanel, {

    initComponent: function() {

        this.selectionModel = new Ext.grid.CheckboxSelectionModel();

        this.store = new Ext.data.JsonStore({
            root: "data",
            url: _source("requests.files.list"),
            fields: [
                "id", "object", "name", "description", "mime", "extension",
                "cmwidth", "cmheight", "imagesize", "xunits", "yunits",
                "colormodel", "colorspace", "xresolution", "yresolution", "software",
                "cm_error", "dpi_error",
                "published", "size", "length",
                { name: "created", type: "date", dateFormat: "c" },
                { name: "updated", type: "date", dateFormat: "c" }
            ]
        });

        // Column model
        var  columns  = Inprint.grid.columns.Files();
        this.colModel = new Ext.grid.ColumnModel({
            defaults: {
                sortable: true,
                menuDisabled:true
            },
            columns: [

                this.selectionModel,
                columns.published,
                columns.preview,
                { id:"name", width:200, header: _("Name"), dataIndex: "name", renderer: function(v, p, r) {
                        return String.format('<div><h1>{0}</h1></div><div>{1}</div>', r.get("name"), r.get("software"));
                    } },
                { id:"color", width:50, header: _("Color"), dataIndex: "colormodel", renderer: function(v, p, r) {
                        var string = "{0}";
                        if (r.get("cm_error")) {
                            string = "<span style=\"color:red;\">{0}</span>";
                        }
                        return String.format(string, r.get("colormodel") );
                    } },
                { id:"dpi", width: 60, header: _("DPI"), dataIndex: "imagesize", renderer: function(v, p, r) {
                        var string = "{0}x{1}";
                        if (r.get("dpi_error")) {
                            string = "<span style=\"color:red;\">{0}x{1}</span>";
                        }
                        return String.format(string, r.get("xresolution"), r.get("yresolution") );
                    } },

                { id:"imagesize", width: 80, header: _("Size"), dataIndex: "imagesize", renderer: function(v, p, r) {
                        return String.format('{0}x{1} mm', r.get("cmwidth"), r.get("cmheight"));
                    } },
                { id:"resolution", width:80,  header: _("Resolution"), dataIndex: "imagesize" },


                columns.created,
                columns.updated,
            ]
        });

        this.tbar = [
            {
                scope:this,
                disabled:true,
                ref: "../btnUpload",
                handler: this.cmpUpload,
                cls: "x-btn-text-icon",
                text: _("Upload files"),
                icon: _ico("arrow-transition-270")
            },
            {
                id: "download",
                scope:this,
                disabled: true,
                ref: "../btnDownload",
                handler: this.cmpDownload,
                cls: "x-btn-text-icon",
                text: _("Get archive"),
                icon: _ico("arrow-transition-090")
            },
            {
                id: "safedownload",
                scope:this,
                disabled: true,
                ref: "../btnSafeDownload",
                handler: this.cmpSafeDownload,
                cls: "x-btn-text-icon",
                text: _("Safe download"),
                icon: _ico("arrow-transition-090")
            }
        ];

        Ext.apply(this, {
            border: false,
            disabled: true,
            stripeRows: true,
            columnLines: true,
            sm: this.selectionModel
        });

        // Call parent (required)
        Inprint.advertising.downloads.Files.superclass.initComponent.apply(this, arguments);
    },

    onRender: function() {
        Inprint.advertising.downloads.Files.superclass.onRender.apply(this, arguments);

        this.on("rowcontextmenu", function(thisGrid, rowIndex, evtObj) {

            evtObj.stopEvent();

            var rowCtxMenuItems = [];

            var record = thisGrid.getStore().getAt(rowIndex);
            var selCount = thisGrid.getSelectionModel().getCount();

            thisGrid.rowCtxMenu = new Ext.menu.Menu({
                items : rowCtxMenuItems
            });

            thisGrid.rowCtxMenu.showAt(evtObj.getXY());

        }, this);

        this.getSelectionModel().on("selectionchange", function(sm) {
            sm.getCount() == 0 ? this.btnDownload.disable() : this.btnDownload.enable();
            sm.getCount() == 0 ? this.btnSafeDownload.disable() : this.btnSafeDownload.enable();
        }, this);

    },

    setPkey: function(id) {
        this.pkey = id;
    },

    cmpUpload: function() {

        var Uploader = new Inprint.cmp.Uploader({
            config: {
                pkey: this.pkey,
                uploadUrl: _source("requests.files.upload")
            }
        });

        Uploader.on("fileUploaded", function() {
            Uploader.hide();
            this.cmpReload();
        }, this);

        Uploader.show();
    },

    cmpDownload: function (params) {

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
            action: _source("requests.files.download"),
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
            hidden.value = record.get("object") +"::"+ record.get("id");
            form.appendChild(hidden);
        });

        document.body.appendChild(form);

        form.submit();
    },

    cmpSafeDownload: function() {
        this.cmpDownload({
            translitEnabled: true
        });
    }

});
