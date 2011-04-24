// Inprint Content 5.0
// Copyright(c) 2001-2011, Softing, LLC.
// licensing@softing.ru
// http://softing.ru/license

Inprint.grid.columns.Files = function() {

    return {

        published: {
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

        preview: {
            id:"preview",
            header:_("Preview"),
            width: 100,
            dataIndex: "id",
            sortable: false,
            scope: this,
            renderer: function(v, p, record) {

                if(record.get("name").match(/^.+\.(jpg|jpeg|png|gif|tiff|png)$/i)) {
                    return  String.format(
                        "<a target=\"_blank\" href=\"/files/preview/{0}\"><img src=\"/files/preview/{0}x80\" style=\"border:1px solid silver;\"/></a>",
                    v);
                }

                if(record.get("name").match(/^.+\.(rtf|txt|doc|docx|odt)$/i)) {
                    var file     = record.get("id");
                    var filename = record.get("name");
                    var document = record.get("document");
                    return String.format(
                        "<a href=\"/?aid=document-editor&oid={0}&pid={1}&text={2}\" "+
                            "onClick=\"Inprint.ObjectResolver.resolve({'aid':'document-editor','oid':'{0}','pid':'{1}','description':'{2}'});return false;\">"+
                            "<img src=\"/files/preview/{3}x80\" style=\"border:1px solid silver;\"/></a></a>",
                        file, document, escape(filename), v
                    );
                }

                return String.format("<img src=\"/files/preview/{0}x80\" style=\"border:1px solid silver;\"/></a>", v);
            }
        },

        name: {
            id:'name',
            header: _("File"),
            dataIndex:'name',
            width:250,
            renderer: function(value, meta, record){
                var text = String.format("<h2>{0}</h2>", value);
                if (record.get("description")) {
                    text += String.format("<div><i>{0}</i></div>", record.get("description"));
                }
                text += String.format("<div style=\"padding:5px 0px;\"><a href=\"/files/download/{0}?original=true\">{1}</a></div>", record.get("id"), _("Original file"));
                return text;
            }
        },

        size: {
            id: "size",
            dataIndex:'size',
            header: _("Size"),
            width: 70,
            renderer: Ext.util.Format.fileSize
        },

        length: {
            id: "length",
            dataIndex:'length',
            header: _("Characters"),
            width: 50
        },

        created: {
            id: "created",
            dataIndex: "created",
            header: _("Created"),
            width: 100,
            xtype: 'datecolumn',
            format: 'M d H:i'
        },

        updated: {
            id: "updated",
            dataIndex: "updated",
            header: _("Updated"),
            width: 100,
            xtype: 'datecolumn',
            format: 'M d H:i'
        }

    };

};
