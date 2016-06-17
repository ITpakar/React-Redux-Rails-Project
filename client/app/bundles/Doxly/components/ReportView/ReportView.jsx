import React, { PropTypes } from 'react';
import DealsByTypeReport from "../../containers/DealsByTypeReport";
import DealsBySizeReport from "../../containers/DealsBySizeReport";
import DealsByMemberReport from "../../containers/DealsByMemberReport";

export default class ReportView extends React.Component {
  constructor(props, context) {
    super(props, context);
    this.state = {
      value: undefined
    };
  }

  render() {
    var periods = [
      {value: "6_months", label: "6 Months"},
      {value: "3_months", label: "3 Months"},
      {value: "1_month", label: "Last Month"}
    ];

  	return (
      <div className="container-fluid">
        <div className="row">
          <div className="col-xs-12">
            <DealsByTypeReport periods={periods}/>
          </div>
        </div>
        <div className="row">
          <div className="col-xs-12 col-md-6">
            <DealsBySizeReport periods={periods}/>
          </div>
          <div className="col-xs-12 col-md-6">
            <DealsByMemberReport periods={periods} />
          </div>
        </div>
      </div>
  	);
  }
}
