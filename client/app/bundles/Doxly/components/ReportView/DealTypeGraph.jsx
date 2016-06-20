import React, { PropTypes } from 'react';
import ReportPeriods from "./ReportPeriods";

export default class DealTypeGraph extends React.Component {
  constructor(props, context) {
    super(props, context);
    this.state = {
      period: undefined
    };
    _.bindAll(this, ["initializeReport"]);
  }

  initializeReport() {
    var _this = this;
    var reportData = this.props.data;
    if (reportData && reportData.data && reportData.data.length > 0) {
      var labels = reportData.labels;
      var ykeys = reportData.ykeys;
      this.report1 = Morris.Bar({
          element: 'report_1',
          data: reportData.data,
          xkey: 'x',
          ykeys: ykeys,
          labels: labels,
          stacked: true,
          hideHover: true
      });

      this.report1.options.labels.forEach(function(label, i){
          var legendItem = $('<span></span>').css('background', _this.report1.options.barColors[i]),
                  legendText = $('<i></i>').text(label);
          $('#report_legend_1').append(legendItem).append(legendText);
      });
    }
  }

  componentDidMount() {
    this.initializeReport();
  }

  componentDidUpdate() {
    if (this.report1) {
      this.report1.setData(this.props.data.data);
    }
  }

  render() {
    var selectedValue = this.props.selectedPeriod;
  	return (
      <div className="panel panel-report">
        <div className="title">
          <h4>Deals by Type</h4>
          <div className="period">
            <ReportPeriods changePeriod={this.props.changePeriod} periods={this.props.periods} selectedValue={selectedValue} />
          </div>
        </div>
        <div className="report" id="report_1">
        </div>
        <div className="report-legend" id="report_legend_1"></div>
      </div>
  	);
  }
}
