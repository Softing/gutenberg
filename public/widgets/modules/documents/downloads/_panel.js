Inprint.documents.downloads.Main = Ext.extend(Ext.grid.GridPanel, {

    initComponent: function() {

        this.access = {};
        this.config = {};
        this.urls = {};

        this.selectionModel = new Ext.grid.CheckboxSelectionModel();

        this.store = new Ext.data.JsonStore({
            root: "data",
            autoLoad: true,
            baseParams: { pictures: true },
            url: _url("/downloads/list/"),
            fields: [
                "id", "downloaded",
                "edition", "edition_shortcut",
                "fascicle", "fascicle_shortcut",
                "document", "document_shortcut",
                "filename", "description", "mime", "extension", "published",  "size", "length",
                { name: "created", type: "date", dateFormat: "c" },
                { name: "updated", type: "date", dateFormat: "c" }
            ]
        });

        // Column model
        this.colModel = new Ext.grid.ColumnModel({
            defaults: {
                sortable: true,
                menuDisabled:true
            },
            columns: [
                this.selectionModel,
                {
                    id:"published",
                    width: 32,
                    dataIndex: "published",
                    sortable: false,
                    renderer: function(v) {
                        var image = '';
                        if (v==1) { image = '<img src="'+ _ico("light-bulb") +'"/>'; }
                        return image;
                    }
                },

                { id:'filename', header: _("File"),     dataIndex:'filename',
                    renderer: function(value, p, record) {
                        var color;
                        record.get("downloaded") == 0 ? color = "black" : color = "#6E6E6E";

                        return String.format("<span style=\"color:{1}\"><b>{0}</b></span>", value, color);
                    }
                },

                { id:'edition',  header: _("Edition"),  dataIndex:'edition_shortcut', width: 120 },
                { id:'fascicle', header: _("Fascicle"), dataIndex:'fascicle_shortcut', width: 80 },

                { id:'document', header: _("Document"), dataIndex:'document_shortcut', width: 200 },
                { id: 'size',    header: _("Size"),     dataIndex:'size',     width:60, renderer:Ext.util.Format.fileSize},
                { id: 'length',  header: _("Length"),   dataIndex:'length',   width:60 },
                { id: 'created', header: _("Created"),  dataIndex:'created',  width:90, xtype: 'datecolumn', format: 'M d H:i' },
                { id: 'updated', header: _("Updated"),  dataIndex:'updated',  width:90, xtype: 'datecolumn', format: 'M d H:i' }
            ]
        });

        this.tbar = [

            {
                scope:this,
                disabled: true,
                ref: "../btnSave",
                handler: this.cmpSave,
                cls: "x-btn-text-icon",
                text: _("Get archive"),
                icon: _ico("arrow-transition-090")
            },

            "->",

            {
                columnWidth: .125,
                xtype: "treecombo",
                name: "edition",
                fieldLabel: _("Edition"),
                emptyText: _("Edition") + "...",
                minListWidth: 250,
                url: _url('/documents/trees/editions/'),
                baseParams: {
                    term: 'editions.documents.work'
                },
                rootVisible:true,
                root: {
                    id:'all',
                    nodeType: 'async',
                    expanded: true,
                    draggable: false,
                    icon: _ico("book"),
                    text: _("All editions")
                },
                listeners: {
                    scope:this,
                    select: function (combo, node) {
                        this.store.baseParams.flt_edition = node.id;
                        this.store.reload();
                    }
                }
            },
            {
                columnWidth:.125,
                xtype: "treecombo",
                name: "fascicle",
                fieldLabel: _("Fascicle"),
                emptyText: _("Fascicle") + "...",
                minListWidth: 250,
                url: _url('/documents/trees/fascicles/'),
                baseParams: {
                    term: 'editions.documents.work'
                },
                rootVisible:true,
                root: {
                    id:'all',
                    nodeType: 'async',
                    expanded: true,
                    draggable: false,
                    icon: _ico("blue-folder-open-document-text"),
                    text: _("All fascicles")
                },
                listeners: {
                    scope:this,
                    select: function (combo, node) {
                        this.store.baseParams.flt_fascicle = node.id;
                        this.store.reload();
                    }
                }
            },
            "-",
            {
                scope:this,
                pressed: false,
                enableToggle: true,
                text: _("Documents"),
                ref: "../btnDocuments",
                cls: "x-btn-text-icon",
                icon: _ico("documents-stack"),
                toggleHandler: function(item, pressed) {
                    this.store.baseParams.documents = pressed;
                    this.store.reload();
                }
            },
            {
                scope:this,
                pressed: true,
                enableToggle: true,
                text: _("Images"),
                ref: "../btnPictures",
                cls: "x-btn-text-icon",
                icon: _ico("pictures-stack"),
                toggleHandler: function(item, pressed) {
                    this.store.baseParams.pictures = pressed;
                    this.store.reload();
                }
            }
        ];

        Ext.apply(this, {
            border:false,
            stripeRows: true,
            columnLines: true,
            sm: this.selectionModel,
            autoExpandColumn: "filename"
        });

        // Call parent (required)
        Inprint.documents.downloads.Main.superclass.initComponent.apply(this, arguments);
    },

    onRender: function() {
        Inprint.documents.downloads.Main.superclass.onRender.apply(this, arguments);

        this.getSelectionModel().on("selectionchange", function(sm) {
            sm.getCount() == 0 ? this.btnSave.disable() : this.btnSave.enable();
        }, this);

    },

    cmpSave: function () {

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
            tag: 'form',
            method: 'post',
            action: "/downloads/download/",
            target: frameid
        });

        Ext.each(this.getSelectionModel().getSelections(), function(record) {
            // create hidden input element with the 'action'
            var hidden = document.createElement('input');
            hidden.type = 'hidden';
            hidden.name = 'file[]';
            hidden.value = record.get("document") +"::"+ record.get("id");
            form.appendChild(hidden);
        });

        document.body.appendChild(form);

        form.submit();
    }

});

Inprint.registry.register("document-downloads", {
    icon: "drive-download",
    text: _("Downloads"),
    description: _("List of downloads"),
    xobject: Inprint.documents.downloads.Main
});
