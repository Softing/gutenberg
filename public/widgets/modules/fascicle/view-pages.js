Inprint.fascicle.plan.View = Ext.extend(Ext.DataView, {

    initComponent: function() {

        this.url = _url("/fascicle/pages/view/");

        this.tpl = new Ext.XTemplate(
            '{[ this.renderPages(\''+ this.fascicle +'\', values) ]}',
            {
                renderPages: function(fascicle, values){

                    var string = "";

                    var items = values[0];

                    string += '<div class="inprint-plan">';
                    string += '<div class="inprint-plan-block">';

                    for (var c=0; c<items.pageorder.length; c++) {

                        var page = items.pages[ items.pageorder[c] ];

                        var prevPage = items.pages[ items.pageorder[c-1] ];
                        var nextPage = items.pages[ items.pageorder[c+1] ];

                        var pageclass  = "";
                        var alertclass = "";

                        if(page.num && page.num % 2 === 0) {
                            pageclass = "inprint-plan-page-left";
                            if (prevPage && prevPage.num != page.num-1) {
                                alertclass = "inprint-plan-page-alert-left";
                            }
                            if (nextPage && nextPage.num != page.num+1) {
                                alertclass = "inprint-plan-page-alert-right";
                            }
                        }

                        if(page.num && page.num % 2 !== 0) {
                            pageclass = "inprint-plan-page-right";
                            if (prevPage && prevPage.num != page.num-1) {
                                alertclass = "inprint-plan-page-alert-left";
                            }
                            if (nextPage && nextPage.num !== page.num+1) {
                                alertclass = "inprint-plan-page-alert-right";
                            }
                        }

                        string += '<div id="'+ page.id +'" seqnum="'+ page.num +'" class="inprint-plan-page '+ pageclass +' '+ alertclass +'">';

                            if (! page.num ) {
                                page.num = "--";
                            }

                            if (! page.headline ) {
                                page.headline = "";
                            }

                            string += '<div class="inprint-plan-page-title">';
                            string += '<div><nobr>'+ page.num +' - '+ page.headline +'</nobr></div>';
                            string += '</div>';

                            string += '<div class="inprint-plan-page-body"'+
                                ' style="background:url(/fascicle/images/page/'+ fascicle +'/'+ page.id +'/200/240/?rnd='+ Math.random() +') no-repeat;">';

                            if (page.holes) {
                                string += '<div style="clear:both"></div>';
                                string += '<div class="inprint-plan-page-holes">';
                                for (var d=0; d<page.holes.length; d++) {
                                    var hole = items.holes[ page.holes[d] ];
                                    string += '<div class="inprint-plan-page-hole">'+ hole.title +'</div>';
                                }
                                string += '</div>';
                            }

                            if (page.requests) {
                                string += '<div style="clear:both"></div>';
                                string += '<div class="inprint-plan-page-requests">';
                                for (var r=0; r<page.requests.length; r++) {
                                    var request = items.requests[ page.requests[r] ];
                                    string += '<div class="inprint-plan-page-request">'+ request.title +'</div>';
                                }

                                string += '</div>';
                            }

                            if (page.documents) {
                                string += '<div  class="inprint-plan-page-documents">';
                                for (var d2=0; d2<page.documents.length; d2++) {

                                    var myDocument = items.documents[ page.documents[d2] ];

                                    var title;
                                    if (page.documents.length > 5) {
                                        title = Ext.util.Format.ellipsis(myDocument.title, 20, false);
                                    }

                                    if (page.documents.length <= 5) {
                                        title = Ext.util.Format.ellipsis(myDocument.title, 30, false);
                                    }

                                    if (page.documents.length <= 3) {
                                        title = Ext.util.Format.ellipsis(myDocument.title, 50, false);
                                    }

                                    if (page.documents.length == 1) {
                                        title = myDocument.title;
                                    }

                                    var fgcolor  = "#" + myDocument.color;
                                    var txtcolor = inprintColorContrast(myDocument.color);

                                    string += String.format(
                                        "<div class=\"inprint-plan-page-document\">"+
                                            "<a style=\"background:{3}!important;color:{4}!important;\" href=\"#\" onClick=\"Inprint.ObjectResolver.resolve({aid:'document-profile',oid:'{0}',text:'{1}'});return false;\">{2}</a>"+
                                        "</div>",
                                        myDocument.id, escape(myDocument.title), title, fgcolor, txtcolor);
                                }
                                string += '<div style="clear:both"></div>';
                                string += '</div>';
                            }

                            string += '</div>';

                        string += '</div>';

                        var delimeter = '<div style="clear:both"></div>';
                        delimeter += '</div>';
                        delimeter += '<div class="inprint-plan-block">';

                        if(nextPage && page.num && nextPage.num != page.num + 1) {
                            if (  nextPage.num < page.num + 1  ) {
                                string += delimeter;
                            }
                        }

                        if(nextPage && page.num && page.num % 2 !== 0) {
                            string += delimeter;
                        }

                        else if(nextPage && nextPage.num % 2 == page.num % 2) {
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
            fields: [ "pageorder", "pages", "documents", "requests", "holes" ]
        });

        Ext.apply(this, {
            autoWidth:true,
            autoHeight:true,
            simpleSelect: false,
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

    cmpLoad: function(data) {
        this.parent.body.mask("Обновление данных...");
        var rsp = Ext.util.JSON.decode(response.responseText);
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
                this.scrollTop    = this.parent.body.dom.scrollTop;
                this.scrollHeight = this.parent.body.dom.scrollHeight;
                this.getStore().loadData(rsp);
            }
        });
    }

});
