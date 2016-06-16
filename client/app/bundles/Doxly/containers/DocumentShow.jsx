import React, { PropTypes } from 'react';
import {connect} from "react-redux";
import DocumentHistoriesView from "../components/DocumentView/DocumentHistoriesView";
import {loadDocument} from "../actions/doxlyActions";

class DocumentShow extends React.Component {
  constructor(props, context) {
    super(props, context);
    _.bindAll(this, []);
  }

  componentWillMount() {
    var documentId = this.props.id;
    this.props.loadDocument(documentId);
  }

  render() {
    if (!this.props.document) {
      return (<div className="is-loading">Loading, please wait...</div>);
    } else {
      let dealDocument = this.props.document.deal_documents[0];

      if (dealDocument) {
        return (<DocumentHistoriesView document={this.props.document} />);
      } else {
        return (
          <div>This document does not have any files</div>
        );
      }
    }
  }
}

DocumentShow.propTypes = {
  id: PropTypes.number.isRequired,
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
  loadDocument
})(DocumentShow);

export default DocumentShow;
