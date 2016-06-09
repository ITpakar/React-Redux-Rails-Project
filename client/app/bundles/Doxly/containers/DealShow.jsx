import React, { PropTypes } from 'react';
import { bindActionCreators } from 'redux'
import {connect} from "react-redux";
import CategoryView from "../components/CategoryView/CategoryView"
import actionTypes from "../constants";
import {loadDealSectionsTree} from "../actions/doxlyActions";

class DealShow extends React.Component {
  constructor(props, context) {
    super(props, context);
  }

  componentWillMount() {
    var dealId = this.props.id;
    this.props.loadDealSectionsTree(dealId);
  }

  render() {
    if (this.props.loadingSectionsStatus == actionTypes.REQUESTS.LOADING) {
      return (<div className="is-loading">Loading, please wait...</div>);
    } else {
      return (<CategoryView elements={this.props.elements} />);
    }
  }
}

DealShow.propTypes = {
  id: PropTypes.number.required,
  elements: PropTypes.arrayOf(PropTypes.object),
  loadingSectionsStatus: PropTypes.string,
  loadDealSectionsTree: PropTypes.func.isRequired
}

function stateToProps(state, ownProps) {
  let sectionsStore = state.sectionsStore;
  let props = {};

  if (sectionsStore && sectionsStore.data) {
    if (sectionsStore.status == actionTypes.REQUESTS.FINISH_LOADING) {
      props.elements = sectionsStore.data.data.sections;
      props.loadingSectionsStatus = sectionsStore.status;
    } else if (sectionsStore.status == actionTypes.REQUESTS.LOADING) {
      props.loadingSectionsStatus = sectionsStore.status;
    }
  }

  return props;
}

DealShow = connect(stateToProps, {
  loadDealSectionsTree
})(DealShow);

export default DealShow;
