Inprint.fascicle.plan.View = Ext.extend(Ext.DataView, {

    initComponent: function() {
    
        this.url = _url("/fascicle/pages/view/");

        this.tpl = new Ext.XTemplate(
            '{[ this.renderPages(\''+ this.fascicle +'\', values) ]}',
            {
                pageWidth: 130,
                pageHeight: 140,
                renderPages: function(fascicle, values){

                    var string = "";
                    
                    var items = values[0];

                    var pageWidth = this.pageWidth;
                    var pageHeight = this.pageHeight;
                    var blockWidth = (this.pageWidth*2+22);

                    string += '<div class="inprint-plan">';
                    string += '<div class="inprint-plan-block" style="width:'+ blockWidth +'px;">';

                    var numcache = [];

                    for (var c = 0; c < items.pages.length; c++) {

                        var prev_page_num = 0;
                        if (numcache[c-1]) {
                            prev_page_num = parseInt(numcache[c-1][2]);
                        }
                        else if (items.pages[c-1]) {
                            numcache[c-1] = items.pages[c-1].split("::");
                            prev_page_num = parseInt(numcache[c-1][2]);
                        }

                        var next_page_num = 0;
                        if (numcache[c+1]) {
                            prev_page_num = parseInt(numcache[c+1][2]);
                        }
                        else if (items.pages[c+1]) {
                            numcache[c+1] = items.pages[c+1].split("::");
                            next_page_num = parseInt(numcache[c+1][2]);
                        }

                        if (!numcache[c]) {
                            numcache[c] = items.pages[c].split("::");
                        }

                        var page_sid = numcache[c][0];
                        var page_id = numcache[c][1];
                        var page_num = parseInt(numcache[c][2]);
                        var page_pos = parseInt(numcache[c][3]);
                        var page_headline = numcache[c][4];

                        var pageclass  = "";
                        var alertclass = "";

                        if(page_num % 2 == 0) {

                            pageclass = "inprint-plan-page-left";

                            if (prev_page_num != page_num - 1) {
                                alertclass = "inprint-plan-page-alert-left";
                            }
                            if (next_page_num != page_num + 1) {
                                alertclass = "inprint-plan-page-alert-right";
                            }
                        }

                        if(page_num % 2 != 0) {

                            pageclass = "inprint-plan-page-right";

                            if (prev_page_num != page_num - 1) {
                                alertclass = "inprint-plan-page-alert-left";
                            }
                            if (next_page_num != page_num + 1) {
                                alertclass = "inprint-plan-page-alert-right";
                            }
                        }

                        string += '<div id="'+ page_id +'" seqnum="'+ page_num +'" class="inprint-plan-page '+ pageclass +' '+ alertclass +'">';

                            if (! page_num ) {
                                page_num = "--";
                            }

                            if (! page_headline ) {
                                page_headline = "";
                            }

                            string += '<div class="inprint-plan-page-title">';
                            string += '<div><nobr>'+ page_num +' - '+ page_headline +'</nobr></div>';
                            string += '</div>';

                            var imagePosition = (page_pos-1) * pageWidth + (10*(page_pos-1));

                            string += '<div class="inprint-plan-page-body"'+
                                ' style="'+
                                'background:url(/fascicle/sprite/'+ fascicle +'/'+ pageWidth +'/'+ pageHeight +'/) -'+ imagePosition +'px 0px no-repeat;'+
                                'width:'+ pageWidth +'px;'+
                                'height:'+ pageHeight +'px;'+
                                '">';

                            var holesMap = items.holes_map[page_sid];
                            if (holesMap) {
                                var myHoles = holesMap.split("::");
                                string += '<div style="clear:both"></div>';
                                string += '<div class="inprint-plan-page-holes">';
                                for (var h2=0; h2 < myHoles.length; h2++) {

                                    var myHoleHash = items.holes[ myHoles[h2] ];
                                    if (!myHoleHash) continue;

                                    var myHoleObject = myHoleHash.split("::");
                                    var myHole_sid = myHoleObject[0];
                                    var myHole_id = myHoleObject[1];
                                    var myHole_title = myHoleObject[2];
                                    string += '<div class="inprint-plan-page-hole">'+ myHole_title +'</div>';
                                }
                                string += '</div>';
                            }

                            //if (page.requests) {
                            //    string += '<div style="clear:both"></div>';
                            //    string += '<div class="inprint-plan-page-requests">';
                            //    for (var r=0; r<page.requests.length; r++) {
                            //        var request = items.requests[ page.requests[r] ];
                            //        string += '<div class="inprint-plan-page-request">'+ request.title +'</div>';
                            //    }
                            //
                            //    string += '</div>';
                            //}

                            var documentsMap = items.documents_map[page_sid];

                            if (documentsMap) {

                                var myDocuments = documentsMap.split("::");

                                string += '<div  class="inprint-plan-page-documents">';

                                for (var d2=0; d2 < myDocuments.length; d2++) {

                                    var myDocumentHash = items.documents[ myDocuments[d2] ];
                                    if (!myDocumentHash) continue;

                                    var myDocumentObject = myDocumentHash.split("::");
                                    var myDocument_sid = myDocumentObject[0];
                                    var myDocument_id = myDocumentObject[1];
                                    var myDocument_title = myDocumentObject[2];
                                    var myDocument_pages = myDocumentObject[3];
                                    var myDocument_manager = myDocumentObject[4];
                                    var myDocument_color = myDocumentObject[5];

                                    var title = myDocument_title;
                                    if (myDocuments.length > 5) {
                                        title = Ext.util.Format.ellipsis(myDocument_title, 20, false);
                                    }
                                    else if (myDocuments.length <= 3) {
                                        title = Ext.util.Format.ellipsis(myDocument_title, 50, false);
                                    }
                                    else if (myDocuments.length <= 5) {
                                        title = Ext.util.Format.ellipsis(myDocument_title, 30, false);
                                    }

                                    title += "<div>" + myDocument_manager +"</div>";
                                    title += "<div>" + myDocument_pages +"</div>";

                                    var fgcolor  = "#" + myDocument_color;
                                    var txtcolor = inprintColorContrast(myDocument_color);

                                    string += String.format(
                                        "<div class=\"inprint-plan-page-document\">"+
                                            "<a style=\"background:{3}!important;color:{4}!important;\" href=\"#\" onClick=\"Inprint.ObjectResolver.resolve({aid:'document-profile',oid:'{0}',text:'{1}'});return false;\">{2}</a>"+
                                        "</div>",
                                        myDocument_id, escape(myDocument_title), title, fgcolor, txtcolor);
                                }

                                string += '<div style="clear:both"></div>';
                                string += '</div>';
                            }

                            string += '</div>';

                        string += '</div>';

                        var delimeter = '<div style="clear:both"></div>';
                        delimeter += '</div>';
                        delimeter += '<div class="inprint-plan-block" style="width:'+ blockWidth +'px;">';

                        if(next_page_num != page_num + 1) {
                            if (  next_page_num < page_num + 1  ) {
                                string += delimeter;
                            }
                        }

                        if(next_page_num && page_num % 2 != 0) {
                            string += delimeter;
                        }

                        else

                        if(next_page_num % 2 == page_num % 2) {
                            string += delimeter;
                        }

                    }

                    string += '<div style="clear:both"></div>';
                    string += '</div>';
                    string += '<div style="clear:both"></div>';
                    string += '</div>';

                    return string;
                }
            }
        );

        this.store = new Ext.data.JsonStore({
            root: "data",
            baseParams: { fascicle: this.fascicle },
            fields: [ "pageorder", "page", "pages", "documents", "documents_map", "requests", "holes", "holes_map" ]
        });

        Ext.apply(this, {
            autoWidth:true,
            autoHeight:true,
            simpleSelect: true,
            multiSelect: true,
            loadingText:'Загрузка',
            emptyText: 'Полосы не найдены',
            overClass:'inprint-plan-page-over',
            selectedClass: 'inprint-plan-page-selected',
            itemSelector:'div.inprint-plan-page'
        });

        Inprint.fascicle.plan.View.superclass.initComponent.apply(this, arguments);

    },

    onRender: function() {
        Inprint.fascicle.plan.View.superclass.onRender.apply(this, arguments);
    },

    cmpResize: function(value) {

        if (value == 0) {
            this.tpl.pageWidth = 60;
            this.tpl.pageHeight = 70; 
        }
        
        if (value == 50) {
            this.tpl.pageWidth = 130;
            this.tpl.pageHeight = 140; 
        }
        
        if (value == 100) {
            this.tpl.pageWidth = 240;
            this.tpl.pageHeight = 260; 
        }
    },

    cmpLoad: function(data) {
        this.simpleSelect = true;
        this.parent.body.mask("Обновление данных...");
        this.scrollTop    = this.parent.body.dom.scrollTop;
        this.scrollHeight = this.parent.body.dom.scrollHeight;
        this.getStore().loadData(data);
        this.parent.body.unmask();

    },

    cmpReload: function() {
        this.parent.body.mask("Обновление данных...");
        Ext.Ajax.request({
            url: this.url,
            scope: this,
            params: {
                fascicle: this.fascicle
            },
            callback: function() {
                this.parent.body.unmask();
            },
            success: function(response) {
                var rsp = Ext.util.JSON.decode(response.responseText);
                this.cmpLoad(rsp);
            }
        });
    }

});
