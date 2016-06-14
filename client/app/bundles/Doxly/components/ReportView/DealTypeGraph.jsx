import React, { PropTypes } from 'react';
import ReportPeriods from "./ReportPeriods";

export default class DealTypeGraph extends React.Component {
  constructor(props, context) {
    super(props, context);
    this.state = {
      period: undefined
    };
    _.bindAll(this, []);
  }

  componentDidMount() {
    console.log("Line 13 ", this.props.data);
    // var report1 = Morris.Bar({
    //     element: 'report_1',
    //     data: this.props.data,
    //     xkey: 'x',
    //     ykeys: ['p1', 'p2', 'p3', 'p4', 'p5', 'p6', 'p7'],
    //     labels: ['M&A', 'Venture Capital', 'Commercial Lending', 'Etc', 'Other Type', 'TBD', 'Flexible Category Type'],
    //     stacked: true,
    //     hideHover: true
    // })
  }

  render() {
    var selectedValue = this.props.selectedPeriod;
  	return (
      <div className="panel panel-report">
        <div className="title">
          <h4>Deals by Type</h4>
          <div className="period">
            <ReportPeriods onChange={this.props.changePeriod} periods={this.props.periods} selectedValue={selectedValue} />
          </div>
        </div>
        <div className="report" id="report_1">
        </div>
        <div className="report-legend" id="report_legend_1"></div>
      </div>
  	);
  }
}
