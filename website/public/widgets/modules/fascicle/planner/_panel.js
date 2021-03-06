Inprint.fascicle.planner.Panel = Ext.extend(Ext.Panel, {

    initComponent: function() {

        this.manager = null;
        this.version = null;

        this.access = {};

        this.fascicle = this.oid;

        this.panels = {
            pages: new Inprint.fascicle.planner.Pages({
                parent: this,
                oid: this.fascicle
            }),
            documents: new Inprint.fascicle.planner.Documents({
                parent: this,
                oid: this.fascicle
            }),
            requests: new Inprint.fascicle.planner.Requests({
                parent: this,
                oid: this.fascicle
            }),
            summary: new Inprint.fascicle.planner.Summary({
                parent: this,
                oid: this.fascicle
            })
        };

        this.tbar = [
            {
                ref: "../btnPageCreate",
                disabled:true,
                text: "Добавить полосу",
                tooltip: 'Добавить новые полосы в этот выпуск',
                icon: _ico("plus-button"),
                cls: 'x-btn-text-icon',
                scope: this.panels.pages,
                handler: this.panels.pages.cmpPageCreate
            },
            {
                ref: "../btnPageUpdate",
                disabled:true,
                text:'Редактировать',
                icon: _ico("pencil"),
                cls: 'x-btn-text-icon',
                scope: this.panels.pages,
                handler: this.panels.pages.cmpPageUpdate
            },
            "-",
            {
                ref: "../btnPageMoveLeft",
                disabled:true,
                text:'Сместить влево',
                tooltip: 'Перенести отмеченные полосы',
                icon: _ico("arrow-stop-180"),
                cls: 'x-btn-text-icon',
                scope:this.panels.pages,
                handler: this.panels.pages.cmpPageMoveLeft
            },
            {
                ref: "../btnPageMoveRight",
                disabled:true,
                text:'Сместить вправо',
                tooltip: 'Перенести отмеченные полосы',
                icon: _ico("arrow-stop"),
                cls: 'x-btn-text-icon',
                scope:this.panels.pages,
                handler: this.panels.pages.cmpPageMoveRight
            },
            {
                ref: "../btnPageMove",
                disabled:true,
                text:'Перенести',
                tooltip: 'Перенести отмеченные полосы',
                icon: _ico("navigation-000-button"),
                cls: 'x-btn-text-icon',
                scope:this.panels.pages,
                handler: this.panels.pages.cmpPageMove
            },
            "-",
            {
                ref: "../btnPageClean",
                disabled:true,
                text: 'Очистить',
                tooltip: 'Очистить содержимое полос',
                icon: _ico("eraser"),
                cls: 'x-btn-text-icon',
                scope:this.panels.pages,
                handler: this.panels.pages.cmpPageClean
            },
            "-",
            {
                ref: "../btnPageDelete",
                disabled:true,
                text: 'Удалить',
                tooltip: 'Удалить полосы',
                icon: _ico("minus-button"),
                cls: 'x-btn-text-icon',
                scope:this.panels.pages,
                handler: this.panels.pages.cmpPageDelete
            },
            '-',
            {
                width: 100,
                value:50,
                xtype: "slider",
                increment: 50,
                minValue: 0,
                maxValue: 100,
                listeners: {
                    scope:this,
                    'afterrender': function (slider) {                        
                        var value = Ext.state.Manager.get("planner.page.size");
                        if (value >= 0 || value <= 100) {
                            slider.setValue(value);
                        }
                    },
                    'changecomplete': function(slider, value) {
                        this.panels.pages.cmpResize(value);
                    }
                }
                
            },
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
                text: _("Reports"),
                icon: _ico("printer"),
                cls: 'x-btn-text-icon',
                scope:this,
                menu: [
                    {
                        text: _("Fascicle") + "/A4",
                        icon: _ico("printer"),
                        cls: 'x-btn-text-icon',
                        scope:this,
                        handler: function() {
                            window.location = "/fascicle/print/"+ this.oid +"/landscape/a4";
                        }
                    },
                    {
                        text: _("Fascicle") + "/A3",
                        icon: _ico("printer"),
                        cls: 'x-btn-text-icon',
                        scope:this,
                        handler: function() {
                            window.location = "/fascicle/print/"+ this.oid +"/landscape/a3";
                        }
                    },
                    {
                        text: _("Advertising"),
                        icon: _ico("printer"),
                        cls: 'x-btn-text-icon',
                        scope:this,
                        handler: function() {
                            window.location = "/reports/advertising/fascicle/"+ this.oid;
                        }
                    }
                ]
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
                            layout:"card",
                            activeItem: 0,
                            collapseMode: 'mini',
                            items: [
                                this.panels.documents,
                                this.panels.requests
                            ],
                            stateId: 'fasicles.planner.documents'
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
                    items: this.panels.summary,
                    stateId: 'fasicles.planner.summary'
                }
            ]
        });

        Inprint.fascicle.planner.Panel.superclass.initComponent.apply(this, arguments);

    },

    onRender: function() {
        Inprint.fascicle.planner.Panel.superclass.onRender.apply(this, arguments);
        Inprint.fascicle.planner.Context(this, this.panels);
        Inprint.fascicle.planner.Interaction(this, this.panels);
        this.cmpInitSession(true);
    },

    cmpReload: function() {
        this.cmpInitSession(false);
    },

    cmpInitSession: function (check) {

        this.body.mask("Обновление данных...");

        Ext.Ajax.request({
            url: _url("/fascicle/seance/"),
            scope: this,
            params: { fascicle: this.oid },
            callback: function() { this.body.unmask(); },
            success: function(response) {
                this.cmpUpdateSession(Ext.util.JSON.decode(response.responseText));
                if(check) { this.cmpCheckSession.defer( 6000, this); }
            }
        });
    },

    cmpCheckSession: function () {
        Ext.Ajax.request({
            url: _url("/fascicle/check/"),
            scope: this,
            params: { fascicle: this.oid },
            success: function(response) {

                var oldManager = this.access.manager;

                this.cmpUpdateSession(Ext.util.JSON.decode(response.responseText));

                if (oldManager && oldManager != this.access.manager) {
                    Ext.MessageBox.alert(_("Error"), _("Another employee %1 captured this issue!", [ this.access.manager_shortcut ]));
                } else {
                    this.cmpCheckSession.defer( 6000, this);
                }

            }
        });
    },

    cmpUpdateSession: function (rsp) {

        var access      = rsp.data.access;
        var fascicle    = rsp.data.fascicle;
        var summary     = rsp.data.summary;

        var advertising = rsp.data.advertising;
        var composition = rsp.data.composition;
        var documents   = rsp.data.documents;
        var requests    = rsp.data.requests;

        this.access = access;

        Inprint.fascicle.planner.Access(this, this.panels, access);

        var shortcut = rsp.data.fascicle.shortcut;
        var description = "";
        if (access.manager) {
            description += '&nbsp;[<b>Работает '+ access.manager_shortcut +'</b>]';
        }
        description += '&nbsp;[Полос&nbsp;'+ summary.pc +'='+ summary.dc +'+'+ summary.ac;
        description += '&nbsp;|&nbsp;'+ summary.dav +'%/'+ summary.aav +'%]';
        var title = Inprint.ObjectResolver.makeTitle(this.parent.aid, this.parent.oid, null, this.parent.icon, shortcut, description);
        this.parent.setTitle(title);

        if (composition) {
            this.panels.pages.getView().cmpLoad({ data: composition });
        }
        
        if (documents)   { this.panels.documents   .getStore().loadData({ data: documents }); }
        if (requests)    { this.panels.requests    .getStore().loadData({ data: requests }); }
        if (advertising) { this.panels.summary     .getStore().loadData({ data: advertising }); }

    },

    captureSession: function() {
        this.body.mask("Попытка захвата редактирования...");
        Ext.Ajax.request({
            url: _url("/fascicle/capture/"),
            scope: this,
            params: {
                fascicle: this.oid
            },
            callback: function() { this.body.unmask(); },
            success: function(response) {
                var rsp = Ext.util.JSON.decode(response.responseText);
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
            callback: function() { this.body.unmask(); },
            success: function(response) {
                var rsp = Ext.util.JSON.decode(response.responseText);
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
            callback: function() { this.body.unmask(); },
            success: function(response) {
                var rsp = Ext.util.JSON.decode(response.responseText);
                if (!rsp.success && rsp.errors[0]) {
                    Ext.MessageBox.alert(_("Error"), _(rsp.errors[0].msg));
                }
                this.cmpReload();
            }
        });
    },

    cmpSave: function() {

        var pages     = this.panels.pages;
        var documents = this.panels.documents;
        var modules   = this.panels.summary;

        // get documents changes
        var data1 = [];
        var records1 = documents.getStore().getModifiedRecords();
        if(records1.length) {
            Ext.each(records1, function(r, i) {
                var document = r.get('id');
                var pages = r.get('pages');
                data1.push(document +'::'+ pages);
            }, this);
        }

        // get modules changes
        var data2 = [];
        var records2 = modules.getStore().getModifiedRecords();
        if(records2.length) {
            Ext.each(records2, function(r, i) {
                var place = r.get('id');
                var pages = r.get('pages');
                data2.push(place +'::'+ pages);
            }, this);
        }

        this.body.mask("Сохранение данных");

        var o = {
            url: _url("/fascicle/save/"),
            params:{
                fascicle: this.oid,
                document: data1,
                module: data2
            },
            scope:this,
            success: function () {
                modules.getStore().commitChanges();
                documents.getStore().commitChanges();
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

Inprint.registry.register("fascicle-planner", {
    icon: "clock",
    text: _("Planning"),
    xobject: Inprint.fascicle.planner.Panel
});
