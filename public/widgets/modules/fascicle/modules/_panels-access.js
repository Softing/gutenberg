Inprint.fascicle.modules.Access = function(parent, panels) {
    
    parent.access["manage"] = true;
    
    var pages = panels["pages"];
    
    if (parent.access["manage"]) {
        pages.btnCreate.enable();
    }
}
