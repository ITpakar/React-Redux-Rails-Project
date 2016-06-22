import React from 'react';

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

  getDisplayedErrorMessage: function(field, clientErrors, serverErrors) {
    clientErrors = clientErrors || {};
    serverErrors = serverErrors || {};

    var errors = [];
    var displayedErrors = [];

    if (clientErrors[field]) {
      errors.push(
        (<span className="error-message" key="client_error">{clientErrors[field]}</span>)
      );
    }

    if (serverErrors[field]) {
      for (let i = 0; i < serverErrors[field].length; i++) {
        let message = (
          <span className="error-message" key={"server_error_" + (i + 1)}>{serverErrors[field][i]}</span>
        );
        errors.push(message);
      }
    }

    if (errors.length > 0) {
      displayedErrors = (
        <span className="errors has-error">
          {errors}
        </span>
      );
    }

    return displayedErrors;
  },

  addErrorStates: function(state, serverErrors) {
    state = state || {};
    serverErrors = serverErrors || {};

    if (serverErrors.errors) {
      state.serverErrors = serverErrors.errors;
    } else if (serverErrors.message){
      state.serverMessage = serverErrors.message;
    }
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
  },

  isEmailValid: function(email) {
    if (!email) {
      return email;
    }

    var $emailInput = $("#test_email_input");
    if ($emailInput.length == 0) {
      $("body").append("<div class='hidden' style='display: none !important;'><input type='email' id='test_email_input' /></div>");
    }

    $emailInput = $("#test_email_input");
    $emailInput.val(email);

    return $emailInput[0].checkValidity()
  }
};

export default Util;
