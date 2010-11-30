Inprint.fascicle.planner.Pages = Ext.extend(Ext.Panel, {

    initComponent: function() {
        
        
        
        this.view = new Inprint.fascicle.plan.View({
            parent: this.parent,
            fascicle: this.oid
        });
        
        this.tbar = [
            {
                ref: "../btnAdd",
                disabled:true,
                text: "Добавить полосу",
                tooltip: 'Добавить новые полосы в этот выпуск',
                icon: _ico("plus-button"),
                cls: 'x-btn-text-icon',
                scope: this,
                handler: this.cmpAdd
            },
            {
                ref: "../btnEdit",
                disabled:true,
                text:'Редактировать',
                icon: _ico("pencil"),
                cls: 'x-btn-text-icon',
                scope: this,
                handler: this.cmpEdit
            },
            {
                ref: "../btnRemove",
                disabled:true,
                text: 'Удалить',
                tooltip: 'Удалить полосы',
                icon: _ico("minus-button"),
                cls: 'x-btn-text-icon',
                scope:this,
                handler: this.cmpRemove
            },
            {
                ref: "../btnMove",
                disabled:true,
                text:'Перенести',
                tooltip: 'Перенести отмеченные полосы',
                icon: _ico("navigation-000-button"),
                cls: 'x-btn-text-icon',
                scope:this,
                handler: this.cmpMove
            },
            {
                ref: "../btnClean",
                disabled:true,
                text: 'Очистить',
                tooltip: 'Очистить содержимое полос',
                icon: _ico("eraser"),
                cls: 'x-btn-text-icon',
                scope:this,
                handler: this.cmpErase
            },
            {
                ref: "../btnResize",
                disabled:true,
                text: 'Разверстать',
                tooltip: 'Добавить новые полосы скопировав содержимое',
                icon: _ico("arrow-resize-045"),
                cls: 'x-btn-text-icon',
                scope:this,
                handler: this.cmpResize
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
            {
                ref: "../btnLoadSession",
                hidden:true,
                text: 'Загрузить версию',
                tooltip: 'Загрузить другую версию компоновки',
                scope: this,
                handler: this.loadVersion
            }
        ];
        
        Ext.apply(this, {
            border:false,
            layout: "fit",
            autoScroll:true,
            items: this.view
        });
        
        Inprint.fascicle.planner.Pages.superclass.initComponent.apply(this, arguments);

    },

    onRender: function() {
        Inprint.fascicle.planner.Pages.superclass.onRender.apply(this, arguments);
    }
});
