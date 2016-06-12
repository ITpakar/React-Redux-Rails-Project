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
    this.state = {
      searchTreeValue: ""
    };
    _.bindAll(this, ["createFolder",
                     "createTask",
                     "createSection",
                     "createDocument",
                     "updateTask",
                     "searchTree",
                     "hasMatchedChildren",
                     "searchTreeByValue",
                     "flattenElements",
                     "removeUnmatchedChildren"]);
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

  searchTree(value) {
    this.setState({searchTreeValue: value});
  }

  flattenElements(elements) {
    if (!elements) {
      return [];
    }

    var results = [];
    for (let i = 0; i < elements.length; i++) {
      let el = elements[i];
      results.push(el);
      results = _.union(results, this.flattenElements(el.elements))
    }

    return results;
  }

  hasMatchedChildren(element, matchedElements) {
    if (!element || !element.elements) {
      return false;
    }

    var matched = false;

    for (let i = 0; i < element.elements.length; i++) {
      let el = element.elements[i];

      for (let j = 0; j < matchedElements.length; j++) {
        let matchedEl = matchedElements[j];
        matched = matched || matchedEl.type == el.type && matchedEl.id == el.id;
      }

      matched = matched || this.hasMatchedChildren(el, matchedElements);
    }

    return matched;
  }

  removeUnmatchedChildren(element, matchedElements) {
    if (element && element.elements) {
      for (let i = element.elements.length - 1; i >= 0; i--) {
        let el = element.elements[i];
        let matched = false;

        for (let j = 0; j < matchedElements.length; j++) {
          let matchedEl = matchedElements[j];
          matched = matched || el.type == matchedEl.type && el.id == matchedEl.id;
        }

        if (!matched) {
          matched = this.hasMatchedChildren(el, matchedElements);

          if (matched) {
            this.removeUnmatchedChildren(el, matchedElements);
          } else {
            element.elements.splice(i, 1);
          }
        }
      }
    }
  }

  searchTreeByValue(elements, value) {
    if (!value || !elements) {
      return elements;
    }

    // Search flatten al elements
    var flattenedElements = this.flattenElements(elements);
    var matchedElements = [];

    // Second, store all matched elements inside matchedElements
    for (let i = 0; i < flattenedElements.length; i++) {
      let el = flattenedElements[i];
      let matched = (el.title || "").toLowerCase().indexOf(value) >= 0 || (el.description || "").toLowerCase().indexOf(value) >= 0;

      if (matched) {
        matchedElements.push(el);
      }
    }

    // Construct new tree base on the matchedElements
    var newTree = [];
    for (let i = 0; i < elements.length; i++) {
      let el = elements[i];
      let matched = false;

      for (let j = 0; j < matchedElements.length; j++) {
        let matchedEl = matchedElements[j];
        matched = matched || el.type == matchedEl.type && el.id == matchedEl.id;
      }

      if (matched) {
        newTree.push(el);
      } else {
        // If element is not matched, but it has matched descendants
        // Then we need to remove any children that are not matched.
        matched = this.hasMatchedChildren(el, matchedElements);
        if (matched) {
          newTree.push(el);
          this.removeUnmatchedChildren(el, matchedElements);
        }
      }
    }

    return newTree;
  }

  render() {
    if (!this.props.elements) {
      return (<div className="is-loading">Loading, please wait...</div>);
    } else {
      var elements = this.searchTreeByValue(jQuery.extend(true, [], this.props.elements), this.state.searchTreeValue);
      return (<CategoryView elements={elements}
                            collaborators={this.props.collaborators}
                            updateTask={this.updateTask}
                            searchTree={this.searchTree}
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
