var Util = {
  getReportData: function(type, responseData) {
    let reportData = {};
    let labels;

    if (type == "type"){
      labels = responseData.types;
    } else if (type == "size") {
      labels = responseData.sizes;
    }

    reportData.ykeys = labels;
    reportData.label = labels;
    reportData.data = [];

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

          if (type == "type") {
            d[label] = (r ? r.count : 0);
          } else if (type == "size") {
            d[label] = (r ? r.count : 0);
          }
        }

        reportData.data.push(d);
      }
    }

    return reportData;
  }
};

export default Util;
