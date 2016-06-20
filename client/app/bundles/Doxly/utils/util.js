var Util = {
  formatDate: function(date, format) {
    if (!date) {
      return "";
    }

    format = format || "MM/DD/YYYY";
    return moment(date).format(format);
  },

  getErrors: function(xhr) {
    var message;
    var errors;

    if (xhr.responseJSON) {
      if (xhr.responseJSON.errors) {
        let messages = xhr.responseJSON.errors.messages;

        if (typeof(messages) == "object") {
          errors = messages;
        } else {
          message = messages;
        }
      } else {
        message = "Unknown error";
      }
    } else {
      message = "Internal server error";
    }

    return {message: message, errors: errors};
  },

  formatNumber: function(number, n, s, c, x) {
    if (!number || !1*number) {
      return number
    }

    x = x || 3;
    s = s || ",";
    c = c || ".";

    if (n === null || n === undefined) {
      var decimalStr = number.toString().split(".")[1];
      n = decimalStr && decimalStr.length || 0;
    }

    var re = '\\d(?=(\\d{' + (x) + '})+' + (n > 0 ? '\\D' : '$') + ')',
        num = (1*number).toFixed(Math.max(0, ~~n));

    return (c ? num.replace('.', c) : num).replace(new RegExp(re, 'g'), '$&' + (s || ','));
  },

  getReportData: function(type, responseData) {
    let reportData = {};
    let labels;
    let ykeys = [];

    if (type == "type"){
      labels = responseData.types;

      for (let i = 0; i < labels.length; i++) {
        ykeys[i] = labels[i].replace(/[^a-z0-9]/ig, "_").replace(/_+/g, "_");
      }

    } else if (type == "size") {
      labels = responseData.sizes;
      ykeys = labels;
    }

    let data = [];
    let results = responseData.results;

    if (type != "member") {
      let xColumns = responseData.group_values;
      for (let i = 0; i < xColumns.length; i++) {
        let d = {};
        d.x = xColumns[i];
        for (let j = 0; j < labels.length; j++) {
          let label = labels[j];
          let r;

          for (let k = 0; k < results.length; k++) {
            let result = results[k];
            if (result.date == d.x) {
              if (type == "type") {
                if (result.transaction_type == label) {
                  r = result;
                }
              } else if (type == "size") {
                if (result.deal_size == label) {
                  r = result;
                }
              }
            }
          }

          if (type == "type") {
            d[ykeys[j]] = (r ? r.count : 0);
          } else if (type == "size") {
            d[ykeys[j]] = (r ? r.count : 0);
          }
        }

        data.push(d);
      }
    }

    let displayedLabels = [];
    if (type == "size") {
      for (let i = 0; i < labels.length; i++) {
        displayedLabels[i] = "$" + Util.formatNumber(labels[i], 0);
      }
    } else {
      displayedLabels = labels;
    }

    reportData.ykeys = ykeys;
    reportData.labels = displayedLabels;
    reportData.data = data;

    return reportData;
  }
};

export default Util;
