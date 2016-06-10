import React, { PropTypes } from 'react';
import { Modal } from 'react-bootstrap';

export default class NewDocumentModal extends React.Component {
  constructor(props, context) {
    super(props, context);
    _.bindAll(this, ["createDocument", "handleSubmit", "showDialog"]);
  }

  handleSubmit(event) {
    if (event) {
      event.preventDefault();
    }

    var title = $.trim($(this.refs.document_title).val());
    var file = this.refs.file.files[0];
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
      this.props.createDocument(title, file, function() {
        _this.props.closeNewDocumentModal();
      });
    }
  }

  showDialog() {
    $(this.refs.file).click();
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
            <div className="form-group">
              <label>Upload</label>
              <a className="file-input-wrapper btn btn-fileinput  file-inputs" onClick={this.showDialog}>
                <span><i className="icon-icon-uploadcloud"></i> Choose a File</span>
                <input style={{left: "-11008.5px", top: "18.4px"}} ref="file" className="file-inputs" name="file_name" title="<i class='icon-icon-uploadcloud'></i> Choose a File" data-filename-placement="inside" type="file" />
              </a>
            </div>
          </form>
        </Modal.Body>
        <Modal.Footer>
          <button type="button" className="btn btn-default pull-left" onClick={this.props.closeNewDocumentModal}>Cancel</button>
          <button type="button" className="btn btn-primary" onClick={this.handleSubmit}>Create</button>
        </Modal.Footer>
      </Modal>
  	);
  }
}
