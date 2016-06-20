import React, { PropTypes } from 'react';
import { Modal } from 'react-bootstrap';
import Util from "../../utils/util";

export default class DocumentModal extends React.Component {
  constructor(props, context) {
    super(props, context);
    this.state = {
      filename: undefined,
      clientErrors: undefined,
      serverErrors: undefined,
      isSaving: false,
      serverMessage: undefined
    }
    _.bindAll(this, ["createVersion", "handleSubmit", "showDialog", "setFilename"]);
  }

  handleSubmit(event) {
    if (event) {
      event.preventDefault();
    }

    var file = this.refs.file.files[0];

    this.createVersion(file);
  }

  createVersion(file) {
    if (this.state.isSaving) {
      return false;
    }

    if (file) {
      var _this = this;
      var data = new FormData();

      data.append("version[file]", file);

      this.setState({clientErrors: {}, serverErrors: {}, isSaving: true, serverMessage: undefined});
      this.props.createVersion(data, function() {
        _this.setState({isSaving: false});
        _this.refs.version_form.reset();
        _this.props.closeVersionModal();
      }, function(xhr) {
        var state = {isSaving: false};
        var serverErrors = Util.getErrors(xhr);

        Util.addErrorStates(state, serverErrors);
        _this.setState(state);
      });
    } else {
      var errors = {};
      errors.file = "can't be blank";

      this.setState({clientErrors: errors});
    }
  }

  showDialog() {
    $(this.refs.file).click();
  }

  setFilename() {
    var file = this.refs.file.files[0];
    if (file) {
      this.setState({filename: file.name});
    } else {
      this.setState({filename: undefined});
    }
  }

  render() {
    var placeholder;
    if (this.state.filename) {
      placeholder = (<span>{this.state.filename}</span>);
    } else {
      placeholder = (<span><i className="icon-icon-uploadcloud"></i> Choose a File</span>);
    }

    var displayedFileErrors = Util.getDisplayedErrorMessage("file", this.state.clientErrors, this.state.serverErrors);
    var serverMessage;

    if (this.state.serverMessage) {
      serverMessage = (
        <div className="alert alert-danger">{this.state.serverMessage}</div>
      );
    }

  	return (
      <Modal show={this.props.showVersionModal} onHide={this.props.closeVersionModal} dialogClassName="new-question-modal">
        <Modal.Header closeButton>
          <Modal.Title>
            Upload New Version
          </Modal.Title>
        </Modal.Header>
        <Modal.Body>
          <form className="upload-version-form" onSubmit={this.handleSubmit} ref="version_form">
            {serverMessage}
            <div className="form-group">
              <label>New file</label>
              {displayedFileErrors}
              <a className="file-input-wrapper btn btn-fileinput file-inputs" onClick={this.showDialog}>
                {placeholder}
                <input style={{left: "-11008.5px", top: "18.4px"}} ref="file" onChange={this.setFilename} className="file-inputs" name="file_name" title="<i class='icon-icon-uploadcloud'></i> Choose a File" type="file" />
              </a>
            </div>
          </form>
        </Modal.Body>
        <Modal.Footer>
          <button type="button" className="btn btn-default pull-left" onClick={this.props.closeVersionModal}>Cancel</button>
          <button type="button" disabled={this.state.isSaving} className="btn btn-primary" onClick={this.handleSubmit}>Upload</button>
        </Modal.Footer>
      </Modal>
  	);
  }
}
