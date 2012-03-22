// Inprint Content 5.0
// Copyright(c) 2001-2011, Softing, LLC.
// licensing@softing.ru
// http://softing.ru/license

Inprint.documents.GridColumns = function() {

    return {

        viewed: {
            id : 'viewed',
            width : 23,
            fixed : true,
            header : '&nbsp;',
            menuDisabled: true,
            renderer : function(value, p, record) {
                if (!record.data.islooked) {
                    return '<img title="" src="'+ _ico("flag") +'">';
                }
                return '';
            }
        },

        title: {
            id:"title",
            width: 210,
            dataIndex: "title",
            header: _("Title"),
            menuDisabled: false,
            renderer : function(value, p, record){

                var color = 'black';

                if (!record.get("isopen")) {
                    color = 'gray';
                }

                var header = String.format(
                    "<a style=\"color:{3}\" href=\"/workspace/?aid=document-profile&oid={0}&text={1}\""+
                        " onClick=\"Inprint.ObjectResolver.resolve({aid:'document-profile',oid:'{0}',text:'{1}'});return false;\">{2}"+
                    "</a>",
                    record.data.id, escape(value), value, color
                );

                var access = record.get("access");

                var links  = record.get("links");
                var linksResult = [];

                if (links) {
                    for (var f=0; f<links.length;f++) {

                        var color    = (access.fedit) ? "black" : "gray";
                        var text     = links[f].name;
                        var file     = links[f].id;
                        var document = record.get("id");

                        linksResult.push(String.format(
                            "<a style=\"color:{4}\" href=\"/?aid=document-editor&oid={0}&pid={1}&text={2}\" "+
                                "onClick=\"Inprint.ObjectResolver.resolve({'aid':'document-editor','oid':'{0}','pid':'{1}','description':'{2}'});return false;\">"+
                                "<nobr>{3}</nobr></a>",
                            file, document, escape(text), text, color
                        ));

                    }
                }

                var result = "<span style=\"font-size:11px;font-weight:bold;\">"+ header +"</span>";
                if (linksResult.length > 0 ) {
                    result += "<span> &nbsp;&mdash;&nbsp; "+ linksResult.join(",&nbsp; ") + "</span>";
                }

                return result;
            }
        },

        edition: {
            id:"edition",
            width: 80,
            menuDisabled: true,
            header: _("Edition"),
            dataIndex: "edition_shortcut"
        },

        maingroup: {
            id:"maingroup",
            width: 80,
            menuDisabled: true,
            header: _("Department"),
            dataIndex: "maingroup_shortcut"
        },

        workgroup: {
            id:"workgroup",
            width: 80,
            hidden: true,
            menuDisabled: true,
            header: _("Where"),
            dataIndex: "workgroup_shortcut"
        },

        fascicle: {
            id:"fascicle",
            width: 70,
            menuDisabled: true,
            header: _("Fascicle"),
            dataIndex: "fascicle_shortcut",
            renderer : function(value, p, record) {
                return value;
            }
        },

        headline: {
            id:"headline",
            menuDisabled: true,
            dataIndex: "headline_shortcut",
            header: _("Headline"),
            width: 90
        },

        rubric: {
            id:"rubric",
            menuDisabled: true,
            dataIndex: "rubric_shortcut",
            header: _("Rubric"),
            width: 80
        },

        pages: {
            id:"pages",
            menuDisabled: true,
            dataIndex: "pages",
            header: _("Pages"),
            width: 55
        },

        progress: {
            id:"progress",
            width: 75,
            dataIndex: "progress",
            header: _("Progress"),
            menuDisabled: true,
            renderer : function(v, p, record) {

                p.css += ' x-grid3-progresscol ';
                var string = '';

                if (record.data.pdate) {
                    string = _fmtDate(record.data.pdate, 'M j');
                }
                else if (record.data.rdate) {
                    string = _fmtDate(record.data.rdate, 'M j');
                }

                var style = '';
                var textClass = (v < 55) ? 'x-progress-text-back' : 'x-progress-text-front' + (Ext.isIE6 ? '-ie6' : '');

                var fgcolor  = "#" + record.data.color;
                var bgcolor  = inprintColorLuminance(record.data.color, 0.7);
                var txtcolor = inprintColorContrast(record.data.color);

                var text = String.format(
                    '<div class="x-progress-text {0}" style="width:100%;color:{3}!important;" id="{1}">{2}</div>',
                    textClass, Ext.id(), string, txtcolor);

                return String.format(
                    '<div class="x-progress-wrap">'+
                        '<div class="x-progress-inner" style="border:1px solid {4};background:{3}!important;">'+
                            '{2}'+
                            '<div class="x-progress-bar{0}" style="width:{1}%;background:{4}!important;color:{5}!important;">&nbsp;</div>'+
                    '</div>',
                    style, v, text, bgcolor, fgcolor, txtcolor);
            }
        },

        manager: {
            id:"manager",
            dataIndex: "manager_shortcut",
            header: _("Manager"),
            width: 100,
            menuDisabled: true,
            renderer : function(v, p, record) {
                if (record.data.workgroup == record.data.manager) {
                    v = '<b>' +v+ '</b>';
                }
                return v;
            }
        },

        holder: {
            id:"holder",
            dataIndex: "holder_shortcut",
            header: _("Holder"),
            width: 100,
            menuDisabled: true,
            renderer : function(v, p, record) {
                if (record.data.workgroup == record.data.holder) {
                    v = '<b>' +v+ '</b>';
                }
                return v;
            }
        },

        images: {
            id:"images",
            menuDisabled: true,
            dataIndex: "images",
            header : '<img src="'+ _ico("camera") +'">',
            width:23
        },

        size: {
            id:"size",
            dataIndex: "rsize",
            header : '<img src="'+ _ico("edit") +'">',
            width:40,
            menuDisabled: true,
            renderer : function(value, p, record) {
                if (record.data.rsize) {
                    return record.data.rsize;
                }
                if (record.data.psize) {
                    return String.format('<span style="color:silver">{0}</span>', record.data.psize);
                }
                return '';
            }
        },

        created: {
            id:"created",
            hidden:true,
            menuDisabled: true,
            dataIndex: "created",
            header: _("Created"),
            width: 80,
            xtype: 'datecolumn',
            format: 'M d H:i'
        },

        updated: {
            id:"updated",
            hidden:true,
            menuDisabled: true,
            dataIndex: "updated",
            header: _("Updated"),
            width: 80,
            xtype: 'datecolumn',
            format: 'M d H:i'
        },

        uploaded: {
            id:"uploaded",
            hidden:true,
            menuDisabled: true,
            dataIndex: "uploaded",
            header: _("Uploaded"),
            width: 80,
            xtype: 'datecolumn',
            format: 'M d H:i'
        },

        moved: {
            id:"moved",
            hidden:true,
            menuDisabled: true,
            dataIndex: "moved",
            header: _("Moved"),
            width: 80,
            xtype: 'datecolumn',
            format: 'M d H:i'
        }

    };

};
