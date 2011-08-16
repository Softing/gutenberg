// Inprint Content 5.0
// Copyright(c) 2001-2011, Softing, LLC.
// licensing@softing.ru
// http://softing.ru/license

/*
    Фабрика DataStore, привязанна к JsonStore
*/

Ext.namespace("Inprint.factory.store");

Inprint.factory.store.manager = new function () {

    var items = {};

    return {

        /*
            Обвязка необходимыми функциями для конфигурации настроек
        */
        compose: function(store) {

            store.addField = function(field) {
                this.fields.push(field);
                return this;
            }

            store.setAutoLoad = function(autoLoad) {
                this.autoLoad = autoLoad;
                return this;
            };

            store.setUrl = function(url) {
                this.url = url;
                return this;
            };

            store.setSource = function(source) {
                this.url = _source( source );
                return this;
            };

            store.setRoot = function(root) {
                this.root = root;
                return this;
            };

            store.setId = function(id) {
                this.idProperty = id;
                return this;
            };

            store.create = function() {
                return new Ext.data.JsonStore(this);
            };

            return store;
        },

        set: function(name, item) {
            items[name] = item;
        },

        get: function(name) {

            var item = items[name];

            if (!item) {
                alert("Column "+name+" not found!");
                return false;
            }

            item = Inprint.factory.store.manager.compose(item);

            return item;
        }

    }
};

Inprint.setStore = function (name, fnct) {
    return Inprint.factory.store.manager.set(name, fnct);
}

Inprint.getStore = function (name) {
    return Inprint.factory.store.manager.get(name);
}

Inprint.createJsonStore = function () {
    return Inprint.factory.store.manager.compose({
        fields: [],
        root: 'data',
        idProperty: 'id',
        autoDestroy: true
    });
}
