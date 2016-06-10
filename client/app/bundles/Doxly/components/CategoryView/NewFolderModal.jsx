import React, { PropTypes } from 'react';
import { Modal } from 'react-bootstrap';

export default class NewFolderModal extends React.Component {
  constructor(props, context) {
    super(props, context);
    _.bindAll(this, ["createFolder"]);
  }

  createFolder(event) {
    if (event) {
      event.preventDefault();
    }

    var _this = this;
    var folderAttrs = {};
    folderAttrs.name = $.trim($(this.refs.folder_name).val());

    if (folderAttrs.name) {
      this.props.createFolder(folderAttrs, function() {
        _this.props.closeNewFolderModal();
      });
    }
  }

  render() {
  	return (
      <Modal show={this.props.showNewFolderModal} onHide={this.props.closeNewFolderModal} dialogClassName="new-question-modal">
        <Modal.Header closeButton>
          <Modal.Title>
            New Folder
          </Modal.Title>
        </Modal.Header>
        <Modal.Body>
          <form onSubmit={this.createFolder}>
            <div className="form-group">
              <label htmlFor="input-folder-title">Folder Name</label>
              <input type="text" ref="folder_name" required placeholder="Give your folder a name" className="form-control" id="input-folder-title" name="folder_name" />
            </div>
          </form>
        </Modal.Body>
        <Modal.Footer>
          <button type="button" className="btn btn-default pull-left" onClick={this.props.closeNewFolderModal}>Cancel</button>
          <button type="button" className="btn btn-primary" onClick={this.createFolder}>Create</button>
        </Modal.Footer>
      </Modal>
  	);
  }
}
