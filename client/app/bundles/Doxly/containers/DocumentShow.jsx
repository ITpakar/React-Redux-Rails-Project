import React, { PropTypes } from 'react';
import {connect} from "react-redux";
import DocumentHistoriesView from "../components/DocumentView/DocumentHistoriesView";
import {loadDocument, createVersion} from "../actions/doxlyActions";

class DocumentShow extends React.Component {
  constructor(props, context) {
    super(props, context);
    _.bindAll(this, ["createVersion"]);
  }

  componentWillMount() {
    var documentId = this.props.id;
    this.props.loadDocument(documentId);
  }

  createVersion(formData, successCallback) {
    var _this = this;
    var documentId = this.props.id;
    this.props.createVersion(documentId, formData).then(function() {
      if (successCallback) {
        successCallback();
      }
    });
  }

  render() {
    if (!this.props.document) {
      return (<div className="is-loading">Loading, please wait...</div>);
    } else {
      return (<DocumentHistoriesView document={this.props.document} userId={this.props.userId} createVersion={this.createVersion} />);
    }
  }
}

DocumentShow.propTypes = {
  id: PropTypes.number.isRequired,
  userid: PropTypes.number.isRequired,
  document: PropTypes.object,
  loadingDocumentStatus: PropTypes.string,
  loadDocument: PropTypes.func.isRequired
}

function stateToProps(state, ownProps) {
  let documentStore = state.documentStore;
  let props = {};

  if (documentStore && documentStore.data) {
    props.document = documentStore.data.data.document;
    props.loadingDocumentStatus = documentStore.status;
  }

  return props;
}

DocumentShow = connect(stateToProps, {
  loadDocument,
  createVersion
})(DocumentShow);

export default DocumentShow;
