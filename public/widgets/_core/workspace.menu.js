// Inprint Content 5.0
// Copyright(c) 2001-2011, Softing, LLC.
// licensing@softing.ru
// http://softing.ru/license

Inprint.Menu = Ext.extend(Ext.Toolbar,{

    initComponent: function(){
        Ext.apply(this, {
            height:26
        });
        Inprint.Menu.superclass.initComponent.apply(this, arguments);
    },

    // Override other inherited methods
    onRender: function(){
        Inprint.Menu.superclass.onRender.apply(this, arguments);
        this.CmpQuery();

        // Start a simple clock task that updates a div once per second
        var task = {
            run: function() {
                var clock = Ext.fly("menu-clock");
                if (clock) {
                    clock.update(new Date().format('g:i A'));
                }
            },
            interval: 60000 //60 second
        };

        var runner = new Ext.util.TaskRunner();
        runner.start(task);
    },

    CmpQuery: function() {
        if (this.items) {
            this.items.each(this.remove, this);
        }
        Ext.Ajax.request({
            url: _url("/menu/"),
            scope: this,
            success: function (response) {
                var result = Ext.util.JSON.decode(response.responseText);
                this.CmpLoad(result.data);
            }
        });
    },

    CmpLoad: function(result) {
        // Обрабатываем все пункты меню
        Ext.each(result, function(item) {
            if (item == '->') {
                this.add(item);
                return;
            } else {
                var btn = this.CmpCreateBtn(item);
                this.add(btn);
            }
        }, this);
        this.add("-");
        var clock = this.add({ id: "menu-clock", xtype: 'tbtext', text: new Date().format('g:i A') });
        this.doLayout();
    },

    CmpCreateBtn: function (item) {

        if ( Inprint.registry[item.id] ) {

            var btn = {};

            btn.aid     = item.id;
            btn.oid     = item.oid;
            btn.icon    = Inprint.registry[btn.aid].icon;
            btn.icon    = _ico(btn.icon);

            if (Inprint.registry[btn.aid]) {
                if (Inprint.registry[btn.aid].xtype) {
                    btn.xtype = Inprint.registry[btn.aid].xtype;
                }
            }

            btn.text        = item.menutext     || Inprint.registry[btn.aid].menutext || item.text || Inprint.registry[btn.aid].text;
            btn.tooltip     = item.tooltip      || Inprint.registry[btn.aid].tooltip

            // Обрабатываем подменю
            if (item.menu) {
                btn.menu = new Ext.menu.Menu();
                Ext.each(item.menu, function(node) {
                    var btn2 = this.CmpCreateBtn(node);
                    btn.menu.add(btn2);
                }, this);
            }

            // Обрабатываем кнопку
            else {

                btn.scope = this;

                // Internal handler
                if (Inprint.registry[btn.aid].handler) {
                    btn.handler = Inprint.registry[btn.aid].handler;
                }

                // Resolve window
                else {
                    btn.handler = function() {
                        Inprint.ObjectResolver.resolve({
                            aid:  btn.aid,
                            oid:  btn.oid,
                            text: item.text || Inprint.registry[btn.aid].text,
                            description: item.description || Inprint.registry[btn.aid].description
                        });
                    };
                }
            }

            return btn;
        }

        return item;
    }

});
