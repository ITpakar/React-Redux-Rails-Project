import React, { PropTypes } from 'react';
import { bindActionCreators } from 'redux'
import {connect} from "react-redux";
import CategoryView from "../components/CategoryView/CategoryView"
import actionTypes from "../constants";
import {loadCategorySectionsTree} from "../actions/doxlyActions";

class DealShow extends React.Component {
  constructor(props, context) {
    super(props, context);

    _.bindAll(this, ['onSelectElement']);
  }

  componentWillMount() {
    var dealId = this.props.id;
    var category = this.props.category
    this.props.loadCategorySectionsTree(category, dealId);
  }

  onSelectElement(element) {
    
  }

  render() {
    if (this.props.loadingSectionsStatus == actionTypes.REQUESTS.LOADING) {
      return (<div className="is-loading">Loading, please wait...</div>);
    } else {
      return (<CategoryView elements={this.props.elements} selectElement={this.onSelectElement} />);
    }
  }
}

DealShow.propTypes = {
  id: PropTypes.number.isRequired,
  category: PropTypes.string.isRequired,
  elements: PropTypes.arrayOf(PropTypes.object),
  loadingSectionsStatus: PropTypes.string,
  loadCategorySectionsTree: PropTypes.func.isRequired
}

function stateToProps(state, ownProps) {
  let sectionsStore = state.sectionsStore;
  let props = {};
  let category = ownProps.category;

  if (category) {
    category = category.toLowerCase();
  }

  if (sectionsStore) {
    if (category == "diligence" && sectionsStore.diligenceSections) {
      if (sectionsStore.status == actionTypes.REQUESTS.FINISH_LOADING) {
        props.elements = sectionsStore.diligenceSections.data.sections;
        props.loadingSectionsStatus = sectionsStore.status;
      } else if (sectionsStore.status == actionTypes.REQUESTS.LOADING) {
        props.loadingSectionsStatus = sectionsStore.status;
      }
    } else if (category == "closing" && sectionsStore.closingSections) {
      if (sectionsStore.status == actionTypes.REQUESTS.FINISH_LOADING) {
        props.elements = sectionsStore.closingSections.data.sections;
        props.loadingSectionsStatus = sectionsStore.status;
      } else if (sectionsStore.status == actionTypes.REQUESTS.LOADING) {
        props.loadingSectionsStatus = sectionsStore.status;
      }
    } else if (sectionsStore.allSections){
      if (sectionsStore.status == actionTypes.REQUESTS.FINISH_LOADING) {
        props.elements = sectionsStore.allSections.data.sections;
        props.loadingSectionsStatus = sectionsStore.status;
      } else if (sectionsStore.status == actionTypes.REQUESTS.LOADING) {
        props.loadingSectionsStatus = sectionsStore.status;
      }
    }
  }

  return props;
}

DealShow = connect(stateToProps, {
  loadCategorySectionsTree
})(DealShow);

export default DealShow;
