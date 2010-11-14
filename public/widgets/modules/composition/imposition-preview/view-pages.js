/*
 * Inprint Content 4.0
 * Copyright(c) 2001-2009, Softing, LLC.
 * licensing@softing.ru
 *
 * http://softing.ru/license
 */

/*
 * Inprint Content 4.0
 * Copyright(c) 2001-2009, Softing, LLC.
 * licensing@softing.ru
 *
 * http://softing.ru/license
 */

Inprint.composition.preview.View = Ext.extend(Ext.Panel, {
    
    initComponent: function() {
    
	this.fascicle = this.oid;
	            
        this.url = {
            load: '/composite2/check/'
        };
        
        var tmpl = new Ext.XTemplate('<div class="inprint-planner-view">',
              '<table>',
              '<tpl for=".">',
                  '<tpl if="type == \'page\' ">',
                      '<td valign="top">',
                          '<div class="inprint-planner-catchword">  {catchword}  </div>',
                              '<div id="{uuid}" class="inprint-planner-box inprint-planner-box-status-{status} inprint-planner-box-age-{age}" style="border:1px solid {color};">',
                              '<div class="advert">',
                                  '<tpl for="advert">',
                                      '<span>{size}</span>',
                                  '</tpl>',
                              '</div>',
                              '<tpl for="documents">',
                                  '<div class="text">',
                                      '<div>',
                                          '<div style="width:5px;height:7px;float:left;margin:3px 1px 0px 0px;background:{color};"></div>',
                                          "<a style=\"text-decoration:none;\" href=\"/?part=documents&page=formular&oid={uuid}&text={title}\" onClick=\"Inprint.objResolver('documents', 'formular', { oid:'{uuid}', text:'{title}' });return false;\">{title}</a>",
                                          '<div style="padding:2px 2px 2px 2px;"><nobr>{page_str}</nobr></div>',
                                      '</div>',
                                  '</div>',
                              '</tpl>',
                              '<img src="/data/im/st.gif" width="80" height="1">',
                          '</div>',
                          '<div class="inprint-planner-number" align="center"><span>{seqnum}</span></div>',
                      '</td>',
                  '</tpl>',
                  '<tpl if="type == \'blank\' ">',
                      '<td valign="top">',
                          '<div class="inprint-planner-catchword">{catchword}</div>',
                          '<div id="{seqnum}" seqnum="{number}" class="inprint-planner-box inprint-planner-box-blank">',
                              '<img src="/data/im/st.gif" width="80" height="1">',
                          '</div>',
                          '<div class="inprint-planner-number" align="center"><span>{seqnum}</span></div>',
                      '</td>',
                  '</tpl>',
                  '<tpl if="type == \'clean\' ">',
                      '<td valign="top">',
                          '<div class="inprint-planner-box-free">',
                              '<img src="/data/im/st.gif" width="92" height="1">',
                          '</div>',
                      '</td>',
                  '</tpl>',
                  '<tpl if="type == \'newline\'">',
                      '<td>',
                      '<div class="inprint-planner-spacer">',
                      '</div>',
                      '</td>',
                      '</table>',
                      '<table class="thumb-wrap">',
                  '</tpl>',
              '</tpl>',
              '</table>',
              '<div class="x-clear"></div>',
          '</div>');
        
        this.dataView = new Ext.DataView({
            
            autoWidth:true,
            autoHeight:true,
            simpleSelect: false,
            multiSelect: false,
            loadingText:'Загрузка',
            emptyText: 'Полосы не найдены',
            overClass:'x-view-over',
            itemSelector:'div.inprint-planner-box',
            tpl: tmpl,
            
            store: new Ext.data.Store({
                autoLoad:false,
                baseParams: {
                    fascicle: this.fascicle
                },
                proxy: new Ext.data.HttpProxy({ url: this.url.load }),
                reader: new Ext.data.ArrayReader({
                    id: 4,
                    fields: [ 'type', 'status', 'seqnum', 'color', 'uuid', 'catchword', 'age',  'documents', 'advert' ]
                })
            })
        });
        
        Ext.apply(this, {
            layout: 'fit',
            autoScroll:true,
            bodyStyle:'padding:8px 0px 0px 8px',
            tbar: [
                {
                    text: 'Печать А3',
                    icon: _icon("printer"),
                    cls: 'x-btn-text-icon',
                    scope:this, 
                    handler: function() {
                        this.cmpPrintPage({ mode:'landscape', size:'a3' });
                    }
                },
                {
                    text: 'Печать А4',
                    icon: _icon("printer"),
                    cls: 'x-btn-text-icon',
                    scope:this, 
                    handler: function() {
                        this.cmpPrintPage({ mode:'landscape', size:'a4' });
                    }
                }
            ],
            
            items: this.dataView
        });
        
        Inprint.composition.preview.View.superclass.initComponent.apply(this, arguments);
        
    },
    
    onRender: function() {
        Inprint.composition.preview.View.superclass.onRender.apply(this, arguments);
        
        this.dataView.on("beforeselect", function() {
            return false
        }, this);
        
        this.getStore().on("load", function(){
            if (this.scrollTop && this.scrollHeight) {
                this.body.dom.scrollTop = this.scrollTop + (this.scrollTop == 0 ? 0 : this.body.dom.scrollHeight - this.scrollHeight);
            }
        }, this);
        
        this.cmpReload();
    },
    
    /* Print imposition plan */
    
    cmpPrintPage: function(opt) {
        window.location = '/composite2/pdf/?fascicle='+ this.fascicle +'&mode='+opt.mode+'&size='+opt.size;
    },
    
    /* Reload imposition layout */
    
    cmpUpdateTitle: function(rsp) {
        var titlestr = '<div style="padding-left:21px;background:url(' + this.icon + ') 0px -2px no-repeat;"><a href="/?part=' + this.sitepart + '&page=' + this.sitepage;
        if (this.oid) titlestr += '&oid=' + this.oid;
        titlestr += '&text=' + this.rawTitle + '" onClick="return false;">' + this.rawTitle + '</a>';
        
        if (rsp.owner) {
            titlestr += '&nbsp;[<b>Работает '+ rsp.name +'</b>]';
        }
        
        titlestr += '&nbsp;[Полос&nbsp;'+ rsp.pc +'='+ rsp.dc +'+'+ rsp.ac;
        titlestr += '&nbsp;|&nbsp;'+ rsp.dav +'%/'+ rsp.aav +'%]';
        titlestr += '</div>';
        
        this.setTitle(titlestr);
    },
    
    getStore: function() {
        return this.dataView.getStore();
    },
    
    cmpLoadData: function(data) {
        this.scrollTop = this.body.dom.scrollTop;
        this.scrollHeight = this.body.dom.scrollHeight;
        
        this.getStore().loadData(data);
    },
    
    cmpReload: function() {
        
        this.body.mask("Обновление данных...");
        
        Ext.Ajax.request({
            url: this.url.load,
            scope: this,
            params: {
                fascicle: this.fascicle
            },
            callback: function() {
                this.body.unmask();
            },
            success: function(response) {
                var rsp = Ext.util.JSON.decode(response.responseText)
                
                this.cmpUpdateTitle(rsp);
                this.cmpLoadData(rsp.pages);
                
            },
            failure: Inprint.ajax.failure
        });
        
    }
    
});