var Util = {
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

    reportData.ykeys = ykeys;
    reportData.labels = labels;
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

        reportData.data.push(d);
      }
    }

    return reportData;
  }
};

export default Util;
