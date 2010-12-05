Inprint.fascicle.planner.Access = function(parent, panels, access) {
    
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
    _disable(parent.btnPageCreate, parent.btnPageUpdate, parent.btnPageDelete, parent.btnPageMove, parent.btnPageClean, parent.btnPageResize);
    if (access.manage) {
        _enable(parent.btnPageCreate, parent.btnPageUpdate, parent.btnPageDelete, parent.btnPageMove, parent.btnPageClean, parent.btnPageResize);
    }
}
