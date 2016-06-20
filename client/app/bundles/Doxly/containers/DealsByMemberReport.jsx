import React, { PropTypes } from 'react';
import {connect} from "react-redux";
import DealMember from "../components/ReportView/DealMember"
import {loadDealsByMember} from "../actions/doxlyActions";

class DealsByMemberReport extends React.Component {
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
    this.props.loadDealsByMember(period);
  }

  componentWillMount() {
    var selectedPeriod = this.getSelectedPeriod();

    this.props.loadDealsByMember(selectedPeriod);
  }

  render() {
    if (!this.props.data) {
      return (<div className="is-loading">Loading, please wait...</div>);
    } else {
      return (<DealMember data={this.props.data}
                          periods={this.props.periods}
                          changePeriod={this.changePeriod}
                          selectedPeriod={this.state.selectedPeriod} />);
    }
  }
}

DealsByMemberReport.propTypes = {
  data: PropTypes.object,
  periods: PropTypes.arrayOf(PropTypes.object),
  loadDealsByMemberStatus: PropTypes.string,
  loadDealsByMember: PropTypes.func.isRequired
}

function stateToProps(state, ownProps) {
  let reportStore = state.reportStore;
  let props = {};

  if (reportStore && reportStore.dealsByMember) {
    props.data = reportStore.dealsByMember.data;
    props.loadDealsByMemberStatus = reportStore.status;
  }

  return props;
}

DealsByMemberReport = connect(stateToProps, {
  loadDealsByMember
})(DealsByMemberReport);

export default DealsByMemberReport;
