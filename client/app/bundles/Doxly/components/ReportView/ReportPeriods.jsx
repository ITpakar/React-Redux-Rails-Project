import React, { PropTypes } from 'react';

export default class DealTypeGraph extends React.Component {
  constructor(props, context) {
    super(props, context);
    this.state = {
      value: undefined
    };
    _.bindAll(this, ["changePeriod"]);
  }

  changePeriod() {
    var val = $(this.refs.period).val();

    this.setState({value: val});
    this.props.changePeriod(val);
  }

  render() {
    var value = this.props.selectedValue;
  	return (
      <select ref="period" name="report_1_period" defaultValue={value} onChange={this.changePeriod} className="form-control show-tick">
        <option value="6_months">Last 6 Months</option>
        <option value="3_months">Last 3 Months</option>
        <option value="1_month">Last Month</option>
      </select>
  	);
  }
}
