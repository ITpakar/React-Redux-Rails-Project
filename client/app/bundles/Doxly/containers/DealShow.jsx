import React, { PropTypes } from 'react';
import { bindActionCreators } from 'redux'
import {connect} from "react-redux";
import CategoryView from "../components/CategoryView/CategoryView"
import actionTypes from "../constants";
import {loadCategorySectionsTree, loadDealCollaborators} from "../actions/doxlyActions";
import {doCreateFolder, doCreateTask, doCreateSection, doCreateDocument, doUpdateTask} from "../utils/api";

class DealShow extends React.Component {
  constructor(props, context) {
    super(props, context);
    _.bindAll(this, ["createFolder", "createTask", "createSection", "createDocument", "updateTask"]);
  }

  componentWillMount() {
    var dealId = this.props.id;
    var category = this.props.category;
    this.props.loadCategorySectionsTree(dealId, category);
    this.props.loadDealCollaborators(dealId);
  }

  createFolder(folderAttrs, callback) {
    var _this = this;
    var dealId = this.props.id;
    var category = this.props.category;

    folderAttrs.deal_id = dealId;
    doCreateFolder(folderAttrs).then(function() {
      _this.props.loadCategorySectionsTree(dealId, category);

      if (callback) {
        callback();
      }
    });
  }

  createTask(taskAttrs, callback) {
    var _this = this;
    var dealId = this.props.id;
    var category = this.props.category;

    taskAttrs.deal_id = dealId;
    doCreateTask(taskAttrs).then(function() {
      _this.props.loadCategorySectionsTree(dealId, category);

      if (callback) {
        callback();
      }
    });
  }

  createSection(sectionAttrs, callback) {
    var _this = this;
    var dealId = this.props.id;
    var category = this.props.category;

    sectionAttrs.category_id = category.id;
    doCreateSection(dealId, sectionAttrs).then(function() {
      _this.props.loadCategorySectionsTree(dealId, category);

      if (callback) {
        callback();
      }
    });
  }

  createDocument(formData, callback) {
    var _this = this;
    var dealId = this.props.id;
    var category = this.props.category;

    formData.append("document[deal_id]", dealId)
    doCreateDocument(formData).then(function() {
      _this.props.loadCategorySectionsTree(dealId, category);

      if (callback) {
        callback();
      }
    });
  }

  updateTask(taskId, attrs, successCallback, errorCallback) {
    var _this = this;
    var dealId = this.props.id;
    var category = this.props.category;

    doUpdateTask(taskId, attrs).then(function() {
      _this.props.loadCategorySectionsTree(dealId, category);
      if (successCallback) {
        successCallback();
      }
    }, function() {
      if (errorCallback) {
        errorCallback();
      }
    });
  }

  render() {
    if (!this.props.elements) {
      return (<div className="is-loading">Loading, please wait...</div>);
    } else {
      return (<CategoryView elements={this.props.elements}
                            collaborators={this.props.collaborators}
                            updateTask={this.updateTask}
                            createFolder={this.createFolder}
                            createTask={this.createTask}
                            createSection={this.createSection}
                            createDocument={this.createDocument} />);
    }
  }
}

DealShow.propTypes = {
  id: PropTypes.number.isRequired,
  category: PropTypes.object.isRequired,
  elements: PropTypes.arrayOf(PropTypes.object),
  loadingSectionsStatus: PropTypes.string,
  loadCategorySectionsTree: PropTypes.func.isRequired,
  collaborators: PropTypes.arrayOf(PropTypes.object),
  loadDealCollaborators: PropTypes.func.isRequired
}

function stateToProps(state, ownProps) {
  let sectionsStore = state.sectionsStore;
  let dealCollaboratorsStore = state.dealCollaboratorsStore;
  let props = {};
  let category = ownProps.category;
  let categoryName;

  if (category) {
    categoryName = category.name.toLowerCase();
  }

  if (sectionsStore) {
    if (categoryName == "diligencecategory" && sectionsStore.diligenceSections) {
      props.elements = sectionsStore.diligenceSections.data.sections;
      props.loadingSectionsStatus = sectionsStore.status;
    } else if (categoryName == "closingcategory" && sectionsStore.closingSections) {
      props.elements = sectionsStore.closingSections.data.sections;
      props.loadingSectionsStatus = sectionsStore.status;
    } else if (sectionsStore.allSections){
      props.elements = sectionsStore.allSections.data.sections;
    }
  }

  if (dealCollaboratorsStore && dealCollaboratorsStore.data) {
    props.collaborators = dealCollaboratorsStore.data.data.collaborators;
    props.loadingDealCollaboratorsStatus = dealCollaboratorsStore.status;
  }

  return props;
}

DealShow = connect(stateToProps, {
  loadCategorySectionsTree,
  loadDealCollaborators
})(DealShow);

export default DealShow;
