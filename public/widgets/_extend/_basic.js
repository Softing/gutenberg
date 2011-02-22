//Ext.data.Connection.prototype._handleFailure = Ext.data.Connection.prototype.handleFailure;
//
//Ext.data.Connection.prototype.handleFailure = function(response, e) {
//
//    var errorText = null;
//    var jsonData = Ext.util.JSON.decode(response.responseText);
//
//    if (jsonData.error) {
//        errorText = jsonData.error;
//    }
//
//    if (errorText) {
//        errorText = errorText.replace(/%br%/g, "<br/>");
//        Ext.Msg.show({
//            title:_("Software error"),
//            minWidth:900,
//            maxWidth:900,
//            msg: errorText,
//            buttons: Ext.Msg.OK
//        });
//    }
//
//    Ext.data.Connection.prototype._handleFailure.call(this, response, e);
//};

//Ajax

Ext.Ajax.extraParams = {
    'ajax': true
};

Ext.Ajax.on('beforerequest', function(conn, options) {
    options.extraParams = {
        ajax:true
    };
}, this);

Ext.Ajax.on('requestcomplete', function(conn, response, options) {

    //var jsonData = Ext.util.JSON.decode(response.responseText);
    //
    //if (jsonData.errors) {
    //    Ext.each(jsonData.errors, function(c) {
    //        var title = _("Software error");
    //        var msg = _(c.msg) + " ["+ c.id +"]";
    //        Ext.Msg.show({
    //            title: title,
    //            minWidth:100,
    //            maxWidth:900,
    //            msg: msg,
    //            buttons: Ext.Msg.OK
    //        });
    //    });
    //}

}, this);

Ext.Ajax.on('requestexception', function(conn, response, options) {

    var errorText = _("Error communicating with server");
    var jsonData = Ext.util.JSON.decode(response.responseText);

    if (jsonData && jsonData.error) {
        errorText = jsonData.error;
        errorText = errorText.replace(/%br%/g, "<br/>");
    }

    Ext.Msg.show({
        title:_("Communication error"),
        minWidth:900,
        maxWidth:900,
        msg: errorText,
        buttons: Ext.Msg.OK
    });
}, this);

/* JS */

Array.prototype.contains = function(obj) {
  var i = this.length;
  while (i--) {
    if (this[i] == obj) {
      return true;
    }
  }
  return false;
};
