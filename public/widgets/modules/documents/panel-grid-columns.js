Inprint.documents.GridColumns = function() {

    return {

        viewed: {
            id : 'viewed',
            fixed : true,
            menuDisabled : true,
            header : '&nbsp;',
            width : 26,
            sortable : true,
            renderer : function(value, p, record) {
                if (record.data.islooked)
                    return '<img title="Материал был просмотрен текущим владельцем" src="'+ _ico("eye") +'">';
                return '';
            }
        },

        title: {
            id:"title",
            dataIndex: "title",
            header: _("Title"),
            width: 210,
            sortable: true,
            renderer : function(value, p, record){

                var color = 'black';

                if (!record.get("isopen")) {
                    color = 'gray';
                }

                var header = String.format(
                    '<a style="color:{2}" href="/?aid=document-profile&oid={0}&text={1}" '+
                        'onClick="'+
                            "Inprint.ObjectResolver.resolve({aid:'document-profile',oid:'{0}',text:'{1}'});"+
                        'return false;">{1}'+
                    '</a>',
                    record.data.id, value, color
                );

                var links = record.get("links");
                var linksResult = [];
                for (var f=0; f<links.length;f++) {

                    var file  = String.format(
                        "<a style=\"color:{2}\" href=\"/?aid=document-editor&oid={0}&text={1}\" "+
                            "onClick=\"Inprint.ObjectResolver.resolve({aid:'document-editor',oid:'{0}',text:'{1}'});"+
                            "return false;\"><nobr>{1}</nobr></a>",
                        links[f].id, links[f].name, "gray"
                    );

                    linksResult.push(file);
                }

                var result = "<div style=\"font-size:12px;font-weight:bold;\">"+ header +"</div>"+
                    "<div style=\"margin-top:6px;\">"+ linksResult.join(",&nbsp; ") + "</div>";

                return result;
            }
        },

        edition: {
            id:"edition",
            dataIndex: "edition_shortcut",
            header: _("Edition"),
            width: 80,
            sortable: true
        },

        maingroup: {
            id:"maingroup",
            dataIndex: "maingroup_shortcut",
            header: _("Linked"),
            width: 80,
            sortable: true
        },

        workgroup: {
            id:"workgroup",
            dataIndex: "workgroup_shortcut",
            header: _("Department"),
            width: 80,
            sortable: true
        },

        fascicle: {
            id:"fascicle",
            dataIndex: "fascicle_shortcut",
            header: _("Fascicle"),
            width: 70,
            sortable: true,
            renderer : function(value, p, record) {
                return value;
            }
        },

        headline: {
            id:"headline",
            dataIndex: "headline_shortcut",
            header: _("Headline"),
            width: 90,
            sortable: true
        },

        rubric: {
            id:"rubric",
            dataIndex: "rubric_shortcut",
            header: _("Rubric"),
            width: 80,
            sortable: true
        },

        pages: {
            id:"pages",
            dataIndex: "pages",
            header: _("Pages"),
            width: 55,
            sortable: true
        },

        manager:{
            id:"manager",
            dataIndex: "manager_shortcut",
            header: _("Manager"),
            width: 100,
            sortable: true,
            renderer : function(v, p, record) {
                if (record.data.workgroup == record.data.manager) {
                    v = '<b>' +v+ '</b>';
                }
                return v;
            }
        },

        progress: {
            id:"progress",
            dataIndex: "progress",
            header: _("Progress"),
            sortable: true,
            width: 75,
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

                var text = String.format('<div><div class="x-progress-text {0}" style="width:100%;" id="{1}">{2}</div></div>', textClass, Ext.id(), string);

                var bgcolor  = Color('#' + record.data.color).setSaturation(30);
                var fgcolor  = Color('#' + record.data.color);
                var txtcolor = Color('#' + inverse(record.data.color));

                return String.format(
                    '<div class="x-progress-wrap">'+
                        '<div class="x-progress-inner" style="border:1px solid {4};background:{3}!important;">'+
                            '{2}'+
                            '<div class="x-progress-bar{0}" style="width:{1}%;background:{4}!important;color:{5} !important;">&nbsp;</div>'+
                    '</div>',
                    style, v, text, bgcolor.rgb(), fgcolor.rgb(), txtcolor);
            }
        },

        holder:{
            id:"holder",
            dataIndex: "holder_shortcut",
            header: _("Holder"),
            width: 100,
            sortable: true,
            renderer : function(v, p, record) {
                if (record.data.workgroup == record.data.holder) {
                    v = '<b>' +v+ '</b>';
                }
                return v;
            }
        },

        images:{
            id:"images",
            dataIndex: "images",
            header : '<img src="'+ _ico("camera") +'">',
            width:30,
            sortable: true
        },

        size:{
            id:"size",
            dataIndex: "rsize",
            header : '<img src="'+ _ico("edit") +'">',
            width:40,
            sortable: true,
            renderer : function(value, p, record) {
                if (record.data.rsize)
                    return record.data.rsize;
                if (record.data.psize)
                    return String.format('<span style="color:silver">{0}</span>', record.data.psize);
                return '';
            }
        },

        created: {
            id:"created",
            hidden:true,
            dataIndex: "created",
            header: _("Created"),
            width: 80,
            sortable: true,
            xtype: 'datecolumn', format: 'M d H:i'
        },

        updated: {
            id:"Updated",
            hidden:true,
            dataIndex: "updated",
            header: _("Updated"),
            width: 80,
            sortable: true,
            xtype: 'datecolumn', format: 'M d H:i'
        },

        uploaded: {
            id:"uploaded",
            hidden:true,
            dataIndex: "uploaded",
            header: _("Uploaded"),
            width: 80,
            sortable: true,
            xtype: 'datecolumn', format: 'M d H:i'
        },

        moved: {
            id:"moved",
            hidden:true,
            dataIndex: "moved",
            header: _("Moved"),
            width: 80,
            sortable: true,
            xtype: 'datecolumn', format: 'M d H:i'
        }

    }
};
