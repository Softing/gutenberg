// Inprint Content 5.0
// Copyright(c) 2001-2011, Softing, LLC.
// licensing@softing.ru
// http://softing.ru/license

/*
    Фабрика DataStore, привязанна к JsonStore
*/

Ext.namespace("Inprint.factory.store");

Inprint.factory.JsonStore = function () {

    return {

        xtype: "jsonstore",

        fields: [],
        root: 'data',
        idProperty: 'id',
        autoDestroy: true,

        addField: function(field) {
            this.fields.push(field);
            return this;
        },

        setAutoLoad: function(autoLoad) {
            this.autoLoad = autoLoad;
            return this;
        },

        setUrl: function(url) {
            this.url = url;
            return this;
        },

        setSource: function(source) {
            this.url = _source( source );
            return this;
        },

        setRoot: function(root) {
            this.root = root;
            return this;
        },

        setId: function(id) {
            this.idProperty = id;
            return this;
        },

        setParams: function(params) {
            this.baseParams = params;
            return this;
        }

    }
};


