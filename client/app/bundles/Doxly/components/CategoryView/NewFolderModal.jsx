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
    folderAttrs.task_id = this.props.parentElement && this.props.parentElement.id || $.trim($(this.refs.task_id).val());

    if (folderAttrs.name && folderAttrs.task_id) {
      this.props.createFolder(folderAttrs, function() {
        _this.props.closeNewFolderModal();
      });
    }
  }

  render() {
    var availableTasks = [];
    if (!this.props.parentElement && this.props.tasks) {
      availableTasks = (
        <div className="form-group optional">
          <label htmlFor="input-task-section">Add to Task</label>
          <select name="task" ref="task_id" className="form-control show-tick">
            <option>Select a Task</option>
            {this.props.tasks.map(function(task) {
              return (
                <option value={task.id} key={"task_" + task.id}>{task.title}</option>
              )
            })}
          </select>
        </div>
      );
    }

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
            {availableTasks}
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
