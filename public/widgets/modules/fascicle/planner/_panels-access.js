Inprint.fascicle.planner.Access = function(parent, panels, access) {
    
    parent.access = access;
    
    var pages = panels["pages"];
    var documents = panels["documents"];
    
    //Seance
    _hide(parent.btnCaptureSession, parent.btnBeginSession, parent.btnEndSession);
    _disable(parent.btnCaptureSession, parent.btnBeginSession, parent.btnEndSession, parent.btnSave);
    
    if (access.open) {
        parent.btnBeginSession.show();
        parent.btnBeginSession.enable();
    }
    
    if (access.capture) {
        parent.btnCaptureSession.show();
        parent.btnCaptureSession.enable();
    }
    
    if (access.close) {
        parent.btnEndSession.show();
        parent.btnEndSession.enable();
    }
    
    if (access.save) {
        parent.btnSave.show();
        parent.btnSave.enable();
    }
    
    //Pages
    if (access.manage) {
        parent.btnPageCreate.enable();
        documents.btnCreate.enable();
        documents.btnFromBriefcase.enable();
    } else {
        parent.btnPageCreate.disable();
        documents.btnCreate.disable();
        documents.btnFromBriefcase.disable();
    }
    
    documents.getSelectionModel().on("selectionchange", function(sm) {

        var records = documents.getSelectionModel().getSelections();
        var access = _arrayAccessCheck(records, ['delete', 'recover', 'update', 'capture', 'move', 'transfer', 'briefcase']);
        
        _disable(documents.btnUpdate, documents.btnCapture, documents.btnTransfer, documents.btnMove, documents.btnBriefcase, documents.btnCopy,
                    documents.btnDuplicate, documents.btnRecycle, documents.btnRestore, documents.btnDelete);
        
        if (access.manage) {

            if (sm.getCount() == 1) {
                if (access["update"]    == 'enabled') documents.btnUpdate.enable();
                //if (access["capture"]   == 'enabled') documents.btnCapture.enable();
                //if (access["transfer"]  == 'enabled') documents.btnTransfer.enable();
                if (access["briefcase"] == 'enabled') documents.btnBriefcase.enable();
                if (access["move"]      == 'enabled') documents.btnMove.enable();
                //if (access["move"]      == 'enabled') documents.btnCopy.enable();
                //if (access["move"]      == 'enabled') documents.btnDuplicate.enable();
                //if (access["recover"]   == 'enabled') documents.btnRestore.enable();
                if (access["delete"]    == 'enabled') documents.btnRecycle.enable();
                //if (access["delete"]    == 'enabled') documents.btnDelete.enable();
            }
            
            if (sm.getCount() > 0 ) {
                //if (access["update"]    == 'enabled') documents.btnCapture.enable();
                //if (access["transfer"]  == 'enabled') documents.btnTransfer.enable();
                //if (access["capture"]   == 'enabled') documents.btnCapture.enable();
                //if (access["transfer"]  == 'enabled') documents.btnTransfer.enable();
                if (access["briefcase"] == 'enabled') documents.btnBriefcase.enable();
                if (access["move"]      == 'enabled') documents.btnMove.enable();
                //if (access["move"]      == 'enabled') documents.btnCopy.enable();
                //if (access["move"]      == 'enabled') documents.btnDuplicate.enable();
                //if (access["recover"]   == 'enabled') documents.btnRestore.enable();
                if (access["delete"]    == 'enabled') documents.btnRecycle.enable();
                //if (access["delete"]    == 'enabled') documents.btnDelete.enable();
            }
        }
        
    });
    
}
