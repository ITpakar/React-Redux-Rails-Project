import React, { PropTypes } from 'react';
import ReactDOM from "react-dom";
import Select from 'react-bootstrap-select';

export default class DealTypeGraph extends React.Component {
  constructor(props, context) {
    super(props, context);
    this.state = {
      value: undefined
    };
    _.bindAll(this, ["changePeriod"]);
  }

  changePeriod() {
    var val = $(ReactDOM.findDOMNode(this.refs.period)).find("select").val();

    this.setState({value: val});
    this.props.changePeriod(val);
  }

  render() {
    var value = this.props.selectedValue;
    var periods = this.props.periods;
    var displayedPeriods = [];

    for (let i = 0; i < periods.length; i++) {
      let period = periods[i];
      displayedPeriods.push(
        (
          <option value={period.value} key={"period_" + period.value}>{period.label}</option>
        )
      );
    }
  	return (
      <Select ref="period" name="report_1_period" defaultValue={value} onChange={this.changePeriod} className="show-tick">
        {displayedPeriods}
      </Select>
  	);
  }
}
