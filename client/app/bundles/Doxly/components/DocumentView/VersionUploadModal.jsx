import React, { PropTypes } from 'react';
import { Modal } from 'react-bootstrap';

export default class DocumentModal extends React.Component {
  constructor(props, context) {
    super(props, context);
    _.bindAll(this, ["createVersion", "handleSubmit", "showDialog"]);
  }

  handleSubmit(event) {
    if (event) {
      event.preventDefault();
    }

    var file = this.refs.file.files[0];

    if (file) {
      this.createVersion(file);
    }
  }

  createVersion(file) {
    if (file) {
      var _this = this;
      var data = new FormData();

      data.append("version[file]", file);

      this.props.createVersion(data, function() {
        _this.props.closeUploadModal();
      });
    }
  }

  showDialog() {
    $(this.refs.file).click();
  }

  render() {
  	return (
      <Modal show={this.props.showUploadModal} onHide={this.props.closeUploadModal} dialogClassName="new-question-modal">
        <Modal.Header closeButton>
          <Modal.Title>
            Upload New Version
          </Modal.Title>
        </Modal.Header>
        <Modal.Body>
          <form onSubmit={this.handleSubmit}>
            <div className="form-group">
              <a className="file-input-wrapper btn btn-fileinput  file-inputs" onClick={this.showDialog}>
                <span><i className="icon-icon-uploadcloud"></i> Choose a File</span>
                <input style={{left: "-11008.5px", top: "18.4px"}} ref="file" className="file-inputs" name="file_name" title="<i class='icon-icon-uploadcloud'></i> Choose a File" type="file" />
              </a>
            </div>
          </form>
        </Modal.Body>
        <Modal.Footer>
          <button type="button" className="btn btn-default pull-left" onClick={this.props.closeUploadModal}>Cancel</button>
          <button type="button" className="btn btn-primary" onClick={this.handleSubmit}>Upload</button>
        </Modal.Footer>
      </Modal>
  	);
  }
}
