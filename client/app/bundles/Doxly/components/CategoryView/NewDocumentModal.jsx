import React, { PropTypes } from 'react';
import { Modal } from 'react-bootstrap';
import Dropzone from 'react-dropzone';

export default class NewDocumentModal extends React.Component {
  constructor(props, context) {
    super(props, context);
    this.state = {
      file: undefined
    }

    _.bindAll(this, ["createDocument", "handleSubmit", "addFile"]);
  }

  addFile(files) {
    this.setState({file: files[0]});

    var title = $.trim($(this.refs.document_title).val());
    var file = files[0];

    if (title && file) {
      this.createDocument(title, file);
    }
  }

  handleSubmit(event) {
    if (event) {
      event.preventDefault();
    }

    var title = $.trim($(this.refs.document_title).val());
    var file = this.state.file;
    if (title && file) {
      let _this = this;
      this.createDocument(title, file, function() {
        _this.props.closeNewDocumentModal();
      });
    }
  }

  createDocument(title, file) {
    var _this = this;
    if (title && file) {
      this.props.createDocument({title: title, file: file}, function() {
        _this.props.closeNewDocumentModal();
      });
    }
  }

  render() {
  	return (
      <Modal show={this.props.showNewDocumentModal} onHide={this.props.closeNewDocumentModal} dialogClassName="new-question-modal">
        <Modal.Header closeButton>
          <Modal.Title>
            New Document
          </Modal.Title>
        </Modal.Header>
        <Modal.Body>
          <form onSubmit={this.handleSubmit}>
            <div className="form-group">
              <label htmlFor="input-document-title">File Name</label>
              <input type="text" ref="document_title" required placeholder="Give your document a title" className="form-control" id="input-file-title" name="document_title" />
            </div>
          </form>
          <Dropzone onDrop={this.addFile}>
            <div>Try dropping some files here, or click to select files to upload.</div>
          </Dropzone>
        </Modal.Body>
        <Modal.Footer>
          <button type="button" className="btn btn-default pull-left" onClick={this.props.closeNewDocumentModal}>Cancel</button>
        </Modal.Footer>
      </Modal>
  	);
  }
}
