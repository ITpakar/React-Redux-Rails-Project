var Util = {
  formatDate: function(date, format) {
    if (!date) {
      return "";
    }

    format = format || "MM/DD/YYYY";
    return moment(date).format(format);
  }
};

export default Util;
