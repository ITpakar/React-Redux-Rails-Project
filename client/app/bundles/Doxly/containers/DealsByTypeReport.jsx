import React, { PropTypes } from 'react';
import {connect} from "react-redux";
import DealTypeGraph from "../components/ReportView/DealTypeGraph"
import {loadDealsByType} from "../actions/doxlyActions";
import Util from "../utils/app_util";

class DealsByTypeReport extends React.Component {
  constructor(props, context) {
    super(props, context);
    this.state = {
      selectedPeriod: undefined
    };
    _.bindAll(this, ["changePeriod", "getSelectedPeriod"]);
  }

  getSelectedPeriod() {
    var selectedPeriod = this.state.selectedPeriod;
    if (!selectedPeriod) {
      let period = this.props.periods[0];
      selectedPeriod = Object.keys(period)[0];
    }

    return selectedPeriod;
  }

  changePeriod(period) {
    this.setState({selectedPeriod: period});
    this.props.loadDealsByType(period);
  }

  componentWillMount() {
    var selectedPeriod = this.getSelectedPeriod();

    this.props.loadDealsByType(selectedPeriod);
  }

  render() {
    console.log("Line 38 ", this.props.data);
    if (!this.props.data) {
      return (<div className="is-loading">Loading, please wait...</div>);
    } else {
      return (<DealTypeGraph data={this.props.data}
                             periods={this.props.periods}
                             changePeriod={this.changePeriod}
                             selectedPeriod={this.state.selectedPeriod} />);
    }
  }
}

DealsByTypeReport.propTypes = {
  data: PropTypes.object,
  periods: PropTypes.arrayOf(PropTypes.object),
  loadDealsByTypeStatus: PropTypes.string,
  loadDealsByType: PropTypes.func.isRequired
}

function stateToProps(state, ownProps) {
  let reportStore = state.reportStore;
  let props = {};

  if (reportStore && reportStore.dealsByType) {
    let data = reportStore.dealsByType.data;
    props.data = Util.getReportData("type", data);
    props.loadDealsByTypeStatus = reportStore.status;
  }

  return props;
}

DealsByTypeReport = connect(stateToProps, {
  loadDealsByType
})(DealsByTypeReport);

export default DealsByTypeReport;
