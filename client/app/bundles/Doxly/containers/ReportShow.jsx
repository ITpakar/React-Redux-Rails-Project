import React, { PropTypes } from 'react';
import {connect} from "react-redux";
import ReportView from "../components/ReportView/ReportView";

class ReportShow extends React.Component {
  constructor(props, context) {
    super(props, context);
  }

  render() {
    return (<ReportView />);
  }
}

// ReportShow = connect()(ReportShow);

export default ReportShow;
