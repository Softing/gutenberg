Inprint.fascicle.adverta.Panel = Ext.extend(Ext.Panel, {

    initComponent: function() {
        
        this.manager;
        this.version;
        
        this.access = {};
        
        this.fascicle = this.oid;
        
        this.panels = {
            pages: new Inprint.fascicle.adverta.Pages({
                parent: this,
                oid: this.oid
            }),
            requests: new Inprint.fascicle.adverta.Requests({
                parent: this,
                oid: this.oid
            }),
            summary: new Inprint.fascicle.adverta.Summary({
                parent: this,
                oid: this.oid
            })
        }
        
        this.tbar = [
            '->',
            {
                ref: "../btnSave",
                disabled:true,
                text: 'Сохранить',
                tooltip: 'Сохранить изменения в компоновке выпуска',
                icon: _ico("disk-black"),
                cls: 'x-btn-text-icon',
                scope:this,
                handler: this.cmpSave
            },
            '-',
            {
                ref: "../btnBeginSession",
                icon: _ico("control"),
                cls: 'x-btn-text-icon',
                hidden:false,
                text: 'Открыть сеанс',
                tooltip: 'Открыть сеанс редактирования',
                scope: this,
                handler: this.beginEdit
            },
            {
                ref: "../btnCaptureSession",
                icon: _ico("hand"),
                cls: 'x-btn-text-icon',
                hidden:true,
                text: 'Захватить сеанс',
                tooltip: 'Захватить сеанс редактирования',
                scope: this,
                handler: this.captureSession
            },
            {
                ref: "../btnEndSession",
                icon: _ico("control-stop-square"),
                cls: 'x-btn-text-icon',
                hidden:true,
                text: 'Закрыть сеанс',
                tooltip: 'Закрыть сеанс редактирования',
                scope: this,
                handler: this.endEdit
            },
            "-",
            {
                text: 'Печать А4',
                icon: _ico("printer"),
                cls: 'x-btn-text-icon',
                scope:this, 
                handler: function() {
                    
                }
            },
            {
                text: 'Печать А3',
                icon: _ico("printer"),
                cls: 'x-btn-text-icon',
                scope:this, 
                handler: function() {
                    
                }
            }
        ];
        
        Ext.apply(this, {
            layout: "border",
            autoScroll:true,
            defaults: {
                collapsible: false,
                split: true
            },
            items: [
                {
                    border:false,
                    region: "center",
                    layout: "border",
                    margins: "3 0 3 3",
                    defaults: {
                        collapsible: false,
                        split: true
                    },
                    items: [
                        {
                            region: "center",
                            layout: "fit",
                            items: this.panels.pages
                        },
                        {
                            region:"south",
                            height: 200,
                            minSize: 100,
                            maxSize: 800,
                            layout:"fit",
                            collapseMode: 'mini',
                            items: this.panels["requests"],
                            stateId: 'fasicles.planner.adverta'
                        }
                    ]
                },
                {
                    region:"east",
                    margins: "3 3 3 0",
                    width: 280,
                    minSize: 50,
                    maxSize: 800,
                    layout:"fit",
                    collapseMode: 'mini',
                    items: this.panels["summary"],
                    stateId: 'fasicles.planner.summary'
                }
            ]
        });
        
        Inprint.fascicle.adverta.Panel.superclass.initComponent.apply(this, arguments);

    },

    onRender: function() {
        Inprint.fascicle.adverta.Panel.superclass.onRender.apply(this, arguments);
        
        Inprint.fascicle.adverta.Context(this, this.panels);
        Inprint.fascicle.adverta.Interaction(this, this.panels);
        
        this.cmpInitSession();
        
    },
    
    cmpInitSession: function () {
        this.body.mask("Обновление данных...");
        Ext.Ajax.request({
            url: _url("/fascicle/seance/"),
            scope: this,
            params: {
                fascicle: this.oid
            },
            callback: function() {
                this.body.unmask();
            },
            success: function(response) {
                
                var rsp = Ext.util.JSON.decode(response.responseText)
                
                this.version = rsp.fascicle.version;
                this.manager = rsp.fascicle.manager;
                
                var shortcut = rsp.fascicle.shortcut;
                var description = "";
                
                if (rsp.fascicle.manager) {
                    description += '&nbsp;[<b>Работает '+ rsp.fascicle.manager_shortcut +'</b>]';
                }
                
                description += '&nbsp;[Полос&nbsp;'+ rsp.fascicle.pc +'='+ rsp.fascicle.dc +'+'+ rsp.fascicle.ac;
                description += '&nbsp;|&nbsp;'+ rsp.fascicle.dav +'%/'+ rsp.fascicle.aav +'%]';
                
                var title = Inprint.ObjectResolver.makeTitle(this.parent.oid, this.parent.aid, this.parent.icon, shortcut, description);
                this.parent.setTitle(title)
                
                this.panels.pages.getStore().loadData({ data: rsp.pages });
                this.panels["requests"].getStore().loadData({ data: rsp.requests });
                this.panels["summary"].getStore().loadData({ data: rsp.summary });
                
                Inprint.fascicle.adverta.Access(this, this.panels, rsp.fascicle.access);
                
                this.cmpCheckSession.defer( 50000, this);
            }
        });
    },
    
    cmpReload: function() {
        this.cmpInitSession();
    },

    cmpCheckSession: function () {
        Ext.Ajax.request({
            url: _url("/fascicle/check/"),
            scope: this,
            params: {
                fascicle: this.oid
            },
            success: function(response) {
                var rsp = Ext.util.JSON.decode(response.responseText);
                
                Inprint.fascicle.adverta.Access(this, this.panels, rsp.fascicle.access);
                
                if (this.manager && this.manager != rsp.fascicle.manager) {
                    Ext.MessageBox.alert(_("Error"), _("Another employee %1 captured this issue!", [1]));
                } else {
                    this.cmpCheckSession.defer( 50000, this);
                }
            }
        });
    },

    captureSession: function() {
        this.body.mask("Попытка захвата редактирования...");
        Ext.Ajax.request({
            url: _url("/fascicle/capture/"),
            scope: this,
            params: {
                fascicle: this.oid
            },
            callback: function() { this.body.unmask() },
            success: function(response) {
                var rsp = Ext.util.JSON.decode(response.responseText)
                if (!rsp.success && rsp.errors[0]) {
                    Ext.MessageBox.alert(_("Error"), _(rsp.errors[0].msg));
                }
                this.cmpReload();
            }
        });
    },

    beginEdit: function() {
        
        this.body.mask("Открываем выпуск...");
        
        Ext.Ajax.request({
            url: _url("/fascicle/open/"),
            scope: this,
            params: {
                fascicle: this.oid
            },
            callback: function() { this.body.unmask() },
            success: function(response) {
                var rsp = Ext.util.JSON.decode(response.responseText)
                if (!rsp.success && rsp.errors[0]) {
                    Ext.MessageBox.alert(_("Error"), _(rsp.errors[0].msg));
                }
                this.cmpReload();
            }
        });
    },

    endEdit: function() {
        
        this.body.mask("Закрываем выпуск...");
        
        Ext.Ajax.request({
            url: _url("/fascicle/close/"),
            scope: this,
            params: {
                fascicle: this.oid
            },
            callback: function() { this.body.unmask() },
            success: function(response) {
                var rsp = Ext.util.JSON.decode(response.responseText)
                if (!rsp.success && rsp.errors[0]) {
                    Ext.MessageBox.alert(_("Error"), _(rsp.errors[0].msg));
                }
                this.cmpReload();
            }
        });
    },

    cmpSave: function() {
        
        var pages = this.panels.pages;
        var requests = this.panels["requests"];
        
        var data = [];
        
        // get requests changes
        
        var records = requests.getStore().getModifiedRecords();
        if(records.length) {
            Ext.each(records, function(r, i) {
                var document = r.get('id');
                var pages = r.get('pages');
                data.push(document +'::'+ pages);
            }, this);
        }
        
        this.body.mask("Сохранение данных");
        
        var o = {
            url: _url("/fascicle/save/"),
            params:{
                fascicle: this.oid,
                document: data
            },
            scope:this,
            success: function () {
                requests.getStore().commitChanges();
                this.cmpReload();
            }
        };
        
        Ext.Ajax.request(o);
        
    },

    cmpOnClose: function(inc) {

        if (inc == 'no') {
            return false;
        } else if ( inc == 'yes') {
            this.endEdit();
            Inprint.layout.remove(this);
            return true;
        }
        
        if (this.sessionIsActive) {
            var mbx = Ext.MessageBox.confirm(
                'Подтверждение',
                'Закрыть сессию перед закрытием вкладки?',
                this.cmpOnClose, this
            );
            return false;
        }
        
        return true;
    }

});

Inprint.registry.register("fascicle-adverta", {
    icon: "money",
    text: _("Advertising requests"),
    xobject: Inprint.fascicle.adverta.Panel
});