Inprint.fascicle.plan.View = Ext.extend(Ext.DataView, {
    
    initComponent: function() {
    
        this.url = _url("/fascicle/pages/view/");
        
        this.tpl = new Ext.XTemplate(
            '{[ this.renderPages(values) ]}',
            {
                renderPages: function(values){
                    var items = values[0];
                    
                    var string = '<div class="inprint-plan-block">';
                    
                    for (var c=0; c<items.pageorder.length; c++) {
                        
                        var pageorder = items.pageorder[c];
                        var page = items.pages[pageorder];
                        
                        var pageclass;
                        
                        if(page.num && page.num % 2 == 0) {
                            pageclass = "left";
                        }
                        
                        if(page.num && page.num % 2 != 0) {
                            pageclass = "right";
                        }
                        
                        if(page.num && page.num % 2 == 0) {
                            string += '<div style="clear:both"></div>';
                            string += '</div>';
                            string += '<div class="inprint-plan-block">';
                        }
                        
                        string += '<div id="'+ page.id +'" class="inprint-plan-page inprint-plan-page-'+ pageclass +'">';
                            
                            string += '<div class="inprint-plan-page-title">';
                            string += '<div><nobr>'+ page.num +' - '+ page.headline +'</nobr></div>';
                            string += '</div>';
                            
                            
                            
                            string += '<div class="inprint-plan-page-body"'+
                                ' style="background:url(/fascicle/images/view/?page='+ page.id +'&w=110&h=138&rnd='+ Math.random() +') no-repeat;">';
                            
                            if (page.documents) {
                                string += '<div  class="inprint-plan-page-documents">';
                                for (var d=0; d<page.documents.length; d++) {
                                    
                                    var document = items.documents[ page.documents[d] ];
                                    
                                    var title;
                                    if (page.documents.length > 5) {
                                        title = Ext.util.Format.ellipsis(document.title, 20, false);
                                    }
                                    
                                    if (page.documents.length <= 5) {
                                        title = Ext.util.Format.ellipsis(document.title, 30, false);
                                    }
                                    
                                    if (page.documents.length <= 3) {
                                        title = Ext.util.Format.ellipsis(document.title, 50, false);
                                    }
                                    
                                    if (page.documents.length == 1) {
                                        title = document.title;
                                    }
                                    
                                    string += '<div  class="inprint-plan-page-document">'+
                                        '<a href="#" onClick="Inprint.ObjectResolver.resolve({aid:\'document-profile\',oid:\''+ document.id +'\',text:\''+ document.title +'\'});return false;"">'+
                                            title +
                                        '</a>'+
                                    '</div>';
                                }
                                string += '<div style="clear:both"></div>';
                                string += '</div>';
                            }
                            
                            if (page.holes) {
                                string += '<div class="inprint-plan-page-holes">';
                                for (var d=0; d<page.holes.length; d++) {
                                    var hole = items.holes[ page.holes[d] ];
                                    string += '<div class="inprint-plan-page-hole">'+ hole.title +'</div>';
                                }
                                string += '</div>';
                            }
                            
                            string += '</div>';
                        
                        string += '</div>';
                    }
                    
                    string += '<div style="clear:both"></div>';
                    string += '</div>';
                    
                    return string;
                }
            }
        );
        
        this.store = new Ext.data.JsonStore({
            root: "data",
            baseParams: {
                fascicle: this.fascicle
            },
            fields: [
                "index", "pageorder", "pages", "documents", "holes"
            ]
        });
        
        Ext.apply(this, {
            autoWidth:true,
            autoHeight:true,
            simpleSelect: true,
            multiSelect: true,
            loadingText:'Загрузка',
            emptyText: 'Полосы не найдены',
            //deferEmptyText: false,
            overClass:'inprint-plan-page-over',
            selectedClass: 'inprint-plan-page-selected',
            itemSelector:'div.inprint-plan-page'
        });
        
        Inprint.fascicle.plan.View.superclass.initComponent.apply(this, arguments);
        
    },
    
    onRender: function() {
        Inprint.fascicle.plan.View.superclass.onRender.apply(this, arguments);
        
        //this.dataView.on("beforeselect", function() {
        //    return false
        //}, this);
        //
        //this.getStore().on("load", function(){
        //    if (this.scrollTop && this.scrollHeight) {
        //        this.body.dom.scrollTop = this.scrollTop + (this.scrollTop == 0 ? 0 : this.body.dom.scrollHeight - this.scrollHeight);
        //    }
        //}, this);
        
        this.cmpReload();
    },
    
    //cmpUpdateTitle: function(rsp) {
    //    var titlestr = '<div style="padding-left:21px;background:url(' + this.icon + ') 0px -2px no-repeat;"><a href="/?part=' + this.sitepart + '&page=' + this.sitepage;
    //    if (this.oid) titlestr += '&oid=' + this.oid;
    //    titlestr += '&text=' + this.rawTitle + '" onClick="return false;">' + this.rawTitle + '</a>';
    //    
    //    if (rsp.owner) {
    //        titlestr += '&nbsp;[<b>Работает '+ rsp.name +'</b>]';
    //    }
    //    
    //    titlestr += '&nbsp;[Полос&nbsp;'+ rsp.pc +'='+ rsp.dc +'+'+ rsp.ac;
    //    titlestr += '&nbsp;|&nbsp;'+ rsp.dav +'%/'+ rsp.aav +'%]';
    //    titlestr += '</div>';
    //    
    //    this.setTitle(titlestr);
    //},
    
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
                var rsp = Ext.util.JSON.decode(response.responseText)
                this.scrollTop    = this.parent.body.dom.scrollTop;
                this.scrollHeight = this.parent.body.dom.scrollHeight;
                this.getStore().loadData(rsp);
            }
        });
    
    }
    
});