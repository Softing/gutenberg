Ext.ux.DateRangeField = Ext.extend(Ext.form.DateField, {minText:"The dates in this field must be equal to or after {0}",maxText:"The dates in this field must be equal to or before {0}",reverseText:"The end date must be posterior to the start date",notEqualText:"The end date can't be equal to the start date",dateSeparator:" - ",hideValidationButton:false,authorizeEqualValues:true,mergeEqualValues:true,autoReverse:true,setDisabledDates:function(a) {
    this.disabledDates = a;
    this.initDisabledDays();
    if (this.menu) {
        this.menu.rangePicker.startDatePicker.setDisabledDates(this.disabledDatesRE);
        this.menu.rangePicker.endDatePicker.setDisabledDates(this.disabledDatesRE)
    }
},setDisabledDays:function(a) {
    this.disabledDays = a;
    if (this.menu) {
        this.menu.rangePicker.startDatePicker.setDisabledDays(a);
        this.menu.rangePicker.endDatePicker.setDisabledDays(a)
    }
},setMinValue:function(a) {
    this.minValue = (typeof a == "string" ? this.parseDate(a) : a);
    if (this.menu) {
        this.menu.rangePicker.startDatePicker.setMinDate(this.minValue);
        this.menu.rangePicker.endDatePicker.setMinDate(this.minValue)
    }
},setMaxValue:function(a) {
    this.maxValue = (typeof a == "string" ? this.parseDate(a) : a);
    if (this.menu) {
        this.menu.rangePicker.startDatePicker.setMaxDate(this.maxValue);
        this.menu.rangePicker.endDatePicker.setMaxDate(this.maxValue)
    }
},validateValue:function(h) {
    h = this.formatDate(h);
    if (!Ext.form.DateField.superclass.validateValue.call(this, h)) {
        return false
    }
    if (h.length < 1) {
        return true
    }
    var c = h;
    h = this.parseDate(h);
    var i = c.split(this.dateSeparator);
    if (i.length == 1) {
        if (!h) {
            this.markInvalid(String.format(this.invalidText, c, this.format));
            return false
        }
        var j = Date.parseDate(i[0], this.format);
        var e = Ext.ux.DateRangeField.superclass.validateValue.call(this, j);
        if (!e) {
            this.markInvalid(String.format(this.invalidText, c, this.format));
            return false
        } else {
            return true
        }
    } else {
        if (i.length == 2) {
            if (!h) {
                this.markInvalid(String.format(this.invalidText, c, this.format + this.dateSeparator + this.format));
                return false
            }
            var k = Date.parseDate(i[0], this.format);
            var g = Date.parseDate(i[1], this.format);
            if (!k || !g) {
                this.markInvalid(String.format(this.invalidText, c, this.format + this.dateSeparator + this.format));
                return false
            }
            var f = Ext.ux.DateRangeField.superclass.validateValue.call(this, k);
            var d = Ext.ux.DateRangeField.superclass.validateValue.call(this, g);
            if (!f || !d) {
                this.markInvalid(String.format(this.invalidText, c, this.format + this.dateSeparator + this.format));
                return false
            }
            var a = Date.parse(g);
            var b = Date.parse(k);
            if ((a - b) < 0) {
                this.markInvalid(this.reverseText);
                return false
            }
            if (!this.authorizeEqualValues && a == b) {
                this.markInvalid(this.notEqualText);
                return false
            }
        } else {
            this.markInvalid(String.format(this.invalidText, c, this.format + this.dateSeparator + this.format));
            return false
        }
    }
    return true
},parseDate:function(f) {
    if (!f || Ext.isDate(f) || this.isRangeDate(f)) {
        return f
    }
    var c = f.split(this.dateSeparator);
    if (c.length == 1) {
        return Ext.ux.DateRangeField.superclass.parseDate.call(this, f)
    } else {
        if (c.length == 2) {
            var b = Date.parseDate(c[0], this.format);
            var e = Date.parseDate(c[1], this.format);
            if ((!b || !e) && this.altFormats) {
                if (!this.altFormatsArray) {
                    this.altFormatsArray = this.altFormats.split("|")
                }
                var d,a;
                if (!b) {
                    for (d = 0,a = this.altFormatsArray.length; d < a && !b; d++) {
                        b = Date.parseDate(c[0], this.altFormatsArray[d])
                    }
                }
                if (!e) {
                    for (d = 0,a = this.altFormatsArray.length; d < a && !e; d++) {
                        e = Date.parseDate(c[1], this.altFormatsArray[d])
                    }
                }
            }
            return{startDate:b,endDate:e}
        } else {
            return f
        }
    }
},formatDate:function(a) {
    if (Ext.isDate(a)) {
        return Ext.ux.DateRangeField.superclass.formatDate.call(this, a)
    }
    if (this.isRangeDate(a)) {
        if (this.mergeEqualValues && Date.parse(a.startDate) == Date.parse(a.endDate)) {
            return a.startDate.dateFormat(this.format)
        } else {
            if (this.autoReverse && Date.parse(a.startDate) > Date.parse(a.endDate)) {
                return a.endDate.dateFormat(this.format) + this.dateSeparator + a.startDate.dateFormat(this.format)
            } else {
                return a.startDate.dateFormat(this.format) + this.dateSeparator + a.endDate.dateFormat(this.format)
            }
        }
    } else {
        return a
    }
},onTriggerClick:function() {
    if (this.disabled) {
        return
    }
    if (!this.menu) {
        this.menu = new Ext.ux.DateRangeMenu({hideOnClick:false,hideValidationButton:this.hideValidationButton})
    }
    this.onFocus();
    Ext.apply(this.menu.rangePicker.startDatePicker, {minDate:this.minValue ? this.minValue : new Date(0),maxDate:this.maxValue ? this.maxValue : new Date(2999, 11, 31),disabledDatesRE:this.disabledDatesRE,disabledDatesText:this.disabledDatesText,disabledDays:this.disabledDays,disabledDaysText:this.disabledDaysText,format:this.format,showToday:this.showToday,minText:String.format(this.minText, this.formatDate(this.minValue)),maxText:String.format(this.maxText, this.formatDate(this.maxValue))});
    Ext.apply(this.menu.rangePicker.endDatePicker, {minDate:this.minValue ? this.minValue : new Date(0),maxDate:this.maxValue ? this.maxValue : new Date(2999, 11, 31),disabledDatesRE:this.disabledDatesRE,disabledDatesText:this.disabledDatesText,disabledDays:this.disabledDays,disabledDaysText:this.disabledDaysText,format:this.format,showToday:this.showToday,minText:String.format(this.minText, this.formatDate(this.minValue)),maxText:String.format(this.maxText, this.formatDate(this.maxValue))});
    var c = new Date();
    var a = new Date();
    var b = this.getValue();
    if (Ext.isDate(b)) {
        c = b;
        a = b
    } else {
        if (this.isRangeDate(b)) {
            c = b.startDate;
            a = b.endDate
        }
    }
    this.menu.rangePicker.startDatePicker.setValue(c);
    this.menu.rangePicker.endDatePicker.setValue(a);
    this.menu.show(this.el, "tl-bl?");
    this.menuEvents("on")
},isRangeDate:function(a) {
    return(Ext.isObject(a) && Ext.isDate(a.startDate) && Ext.isDate(a.endDate))
}});
Ext.reg("daterangefield", Ext.ux.DateRangeField);
Ext.ux.DateRangeMenu = Ext.extend(Ext.menu.DateMenu, {layout:"auto",cls:"x-date-range-menu",initComponent:function() {
    this.on("beforeshow", this.onBeforeShow, this);
    Ext.apply(this, {plain:true,showSeparator:false,items:[this.rangePicker = new Ext.ux.DateRangePicker(this.initialConfig)]});
    this.rangePicker.purgeListeners();
    Ext.menu.DateMenu.superclass.initComponent.call(this);
    this.relayEvents(this.rangePicker, ["select"])
},onBeforeShow:function() {
    if (this.rangePicker) {
        this.rangePicker.startDatePicker.hideMonthPicker(true);
        this.rangePicker.endDatePicker.hideMonthPicker(true)
    }
},showAt:function(c, b, a) {
    this.parentMenu = b;
    if (!this.el) {
        this.render()
    }
    if (a !== false) {
        this.fireEvent("beforeshow", this);
        c = this.el.adjustForConstraints(c)
    }
    this.el.setXY(c);
    if (this.enableScrolling) {
        this.constrainScroll(c[1])
    }
    this.el.show();
    Ext.menu.Menu.superclass.onShow.call(this);
    this.hidden = false;
    this.focus();
    this.fireEvent("show", this)
}});
Ext.reg("daterangemenu", Ext.ux.DateRangeMenu);
Ext.ux.DateRangePicker = Ext.extend(Ext.Panel, {layout:"hbox",layoutConfig:{defaultMargins:{left:5,top:5,right:0,bottom:5}},height:234,width:369,cls:"x-menu-date-range-item",selectedDate:{startDate:null,endDate:null},buttonAlign:"center",hideValidationButton:false,initComponent:function() {
    this.items = [this.startDatePicker = new Ext.DatePicker(Ext.apply({internalRender:this.strict || !Ext.isIE,ctCls:"x-menu-date-item"}, this.initialConfig)),this.endDatePicker = new Ext.DatePicker(Ext.apply({internalRender:this.strict || !Ext.isIE,ctCls:"x-menu-date-item"}, this.initialConfig))];
    this.startDatePicker.on("select", this.startDateSelect, this);
    this.endDatePicker.on("select", this.endDateSelect, this);
    this.tbar = new Ext.Toolbar({items:[this.startDateButton = new Ext.Button({text:"Start Date ...",cls:"x-menu-date-range-item-start-date-button",enableToggle:true,allowDepress:false,toggleGroup:"DateButtonsGroup",toggleHandler:this.onStartDatePress.createDelegate(this)}),this.rangeDateButton = new Ext.Button({text:"Range Date",cls:"x-menu-date-range-item-range-date-button",pressed:true,enableToggle:true,allowDepress:false,toggleGroup:"DateButtonsGroup",toggleHandler:this.onRangeDatePress.createDelegate(this)}),"->",this.endDateButton = new Ext.Button({text:"... End Date",cls:"x-menu-date-range-item-end-date-button",enableToggle:true,allowDepress:false,toggleGroup:"DateButtonsGroup",toggleHandler:this.onEndDatePress.createDelegate(this)})]});
    if (!this.hideValidationButton) {
        this.fbar = new Ext.Toolbar({cls:"x-date-bottom",items:[
            {
                xtype:"button",
                text:"ok",
                width:"auto",
                handler:this.onOkButtonPress.createDelegate(this)
            }
        ]});
        this.height = this.height + 28
    }
    Ext.ux.DateRangePicker.superclass.initComponent.call(this)
},onRangeDatePress:function(a, b) {
    if (b) {
        this.startDatePicker.enable();
        this.endDatePicker.enable();
        this.resetDates()
    }
},onStartDatePress:function(a, b) {
    if (b) {
        this.startDatePicker.enable();
        this.endDatePicker.disable();
        this.resetDates()
    }
},onEndDatePress:function(a, b) {
    if (b) {
        this.startDatePicker.disable();
        this.endDatePicker.enable();
        this.resetDates()
    }
},startDateSelect:function(b, a) {
    this.selectedDate.startDate = a;
    if (this.startDateButton.pressed) {
        this.selectedDate.endDate = this.endDatePicker.maxDate;
        this.returnSelectedDate()
    } else {
        if (this.selectedDate.endDate !== null) {
            this.returnSelectedDate()
        }
    }
},endDateSelect:function(b, a) {
    this.selectedDate.endDate = a;
    if (this.endDateButton.pressed) {
        this.selectedDate.startDate = this.startDatePicker.minDate;
        this.returnSelectedDate()
    } else {
        if (this.selectedDate.startDate !== null) {
            this.returnSelectedDate()
        }
    }
},resetselectedDate:function() {
    this.selectedDate = {startDate:null,endDate:null}
},resetDates:function() {
    this.resetselectedDate();
    this.startDatePicker.setValue(new Date());
    this.endDatePicker.setValue(new Date())
},returnSelectedDate:function() {
    this.fireEvent("select", this, this.selectedDate);
    this.resetselectedDate()
},onOkButtonPress:function(a, b) {
    if (b) {
        if (this.startDateButton.pressed) {
            this.selectedDate = {startDate:this.startDatePicker.getValue(),endDate:this.endDatePicker.maxDate}
        } else {
            if (this.endDateButton.pressed) {
                this.selectedDate = {startDate:this.startDatePicker.minDate,endDate:this.endDatePicker.getValue()}
            } else {
                this.selectedDate = {startDate:this.startDatePicker.getValue(),endDate:this.endDatePicker.getValue()}
            }
        }
        this.returnSelectedDate()
    }
}});
Ext.reg("daterangepicker", Ext.ux.DateRangePicker);