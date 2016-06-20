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
  }
};

export default Util;
