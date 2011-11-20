"use strict";
Inprint.fascicle.planner.Context = function(parent, panels) {

    var view  = panels.pages.getView();

    view.on("contextmenu", function( view, index, node, e) {

        if (parent.access.save == false) return false;

        e.stopEvent();

        var selection = panels.pages.cmpGetSelected();
        var selLength = selection.length;

        var disabled = true;
        var disabled1 = true;
        var disabled2 = true;
        var items = [];

        if (parent.access.manage) {

            if (selLength == 1) {
                disabled1 = false;
            }

            if (selLength > 0 && selLength < 3) {
                disabled2 = false;
            }

            disabled = false;
        }

        items.push(
            {
                ref: "../btnPageCreate",
                disabled: disabled,
                text: "Добавить полосу",
                tooltip: 'Добавить новые полосы в этот выпуск',
                icon: _ico("plus-button"),
                cls: 'x-btn-text-icon',
                scope: panels.pages,
                handler: panels.pages.cmpPageCreate
            },
            {
                ref: "../btnPageUpdate",
                disabled:disabled,
                text:'Редактировать',
                icon: _ico("pencil"),
                cls: 'x-btn-text-icon',
                scope: panels.pages,
                handler: panels.pages.cmpPageUpdate
            },
            "-",
            {
                ref: "../btnCompose",
                disabled:disabled2,
                text:'Разметить',
                icon: _ico("wand"),
                cls: 'x-btn-text-icon',
                scope: panels.pages,
                handler: panels.pages.cmpPageCompose
            },
            "-",
            {
                ref: "../btnPageMoveLeft",
                disabled:disabled1,
                text:'Сместить влево',
                tooltip: 'Перенести отмеченные полосы',
                icon: _ico("arrow-stop-180"),
                cls: 'x-btn-text-icon',
                scope:panels.pages,
                handler: panels.pages.cmpPageMoveLeft
            },
            {
                ref: "../btnPageMoveRight",
                disabled:disabled1,
                text:'Сместить вправо',
                tooltip: 'Перенести отмеченные полосы',
                icon: _ico("arrow-stop"),
                cls: 'x-btn-text-icon',
                scope:panels.pages,
                handler: panels.pages.cmpPageMoveRight
            },
            {
                ref: "../btnPageMove",
                disabled:disabled,
                text:'Перенести',
                tooltip: 'Перенести отмеченные полосы',
                icon: _ico("navigation-000-button"),
                cls: 'x-btn-text-icon',
                scope:panels.pages,
                handler: panels.pages.cmpPageMove
            },
            "-",
            {
                ref: "../btnPageClean",
                disabled:disabled,
                text: 'Очистить',
                tooltip: 'Очистить содержимое полос',
                icon: _ico("eraser"),
                cls: 'x-btn-text-icon',
                scope:panels.pages,
                handler: panels.pages.cmpPageClean
            },
            //{
            //    ref: "../btnPageResize",
            //    disabled:disabled,
            //    text: 'Разверстать',
            //    tooltip: 'Добавить новые полосы скопировав содержимое',
            //    icon: _ico("arrow-resize-045"),
            //    cls: 'x-btn-text-icon',
            //    scope:panels.pages,
            //    handler: panels.pages.cmpPageResize
            //},
            "-",
            {
                ref: "../btnPageDelete",
                disabled:disabled,
                text: 'Удалить',
                tooltip: 'Удалить полосы',
                icon: _ico("minus-button"),
                cls: 'x-btn-text-icon',
                scope:panels.pages,
                handler: panels.pages.cmpPageDelete
            }
        );

        items.push('-', {
            icon: _ico("arrow-circle-double"),
            cls: "x-btn-text-icon",
            text: _("Reload"),
            scope: this,
            handler: this.cmpReload
        });

        return new Ext.menu.Menu({ items : items }).showAt( e.getXY() );

    }, view);

};
