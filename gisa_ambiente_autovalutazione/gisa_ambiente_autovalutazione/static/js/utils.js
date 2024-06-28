Date.prototype.yyyymmdd = function() {
    var mm = this.getMonth() + 1; // getMonth() is zero-based
    var dd = this.getDate();
    var hh = this.getHours();
    var mi = this.getMinutes();
    var ss = this.getSeconds();
    return [this.getFullYear(),
            (mm>9 ? '' : '0') + mm,
            (dd>9 ? '' : '0') + dd,
            (hh>9 ? '' : '0') + hh,
            (mi>9 ? '' : '0') + mi,
            (ss>9 ? '' : '0') + ss
           ].join('_');
  };