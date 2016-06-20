import React, { PropTypes } from 'react';
import { Modal } from 'react-bootstrap';
import ReactDOM from "react-dom";
import Select from 'react-bootstrap-select';

export default class FolderModal extends React.Component {
  constructor(props, context) {
    super(props, context);
    _.bindAll(this, ["saveFolder"]);
  }

  saveFolder(event) {
    if (event) {
      event.preventDefault();
    }

    var _this = this;
    var folderAttrs = {};
    var element = this.props.element;

    folderAttrs.name = $.trim($(this.refs.folder_name).val());
    folderAttrs.task_id = this.props.parentElement && this.props.parentElement.id || $.trim($(ReactDOM.findDOMNode(this.refs.task_id)).find("select").val());

    if (folderAttrs.name && folderAttrs.task_id) {
      if (element && element.id) {
        this.props.updateFolder(element.id, folderAttrs, function() {
          _this.props.closeFolderModal();
        });
      } else {
        this.props.createFolder(folderAttrs, function() {
          _this.props.closeFolderModal();
        });
      }
    }
  }

  render() {
    var element = this.props.element;
    var availableTasks = [];

    if (!this.props.parentElement && this.props.tasks) {
      let taskId = element && element.task_id;
      availableTasks = (
        <div className="form-group optional">
          <label htmlFor="input-task-section">Add to Task</label>
          <Select name="task" ref="task_id" defaultValue={taskId} className="show-tick">
            <option>Select a Task</option>
            {this.props.tasks.map(function(task) {
              return (
                <option value={task.id} key={"task_" + task.id}>{task.title}</option>
              )
            })}
          </Select>
        </div>
      );
    }

    var folderName = element && element.title;
    var modalTitle = element && element.id ? "Edit Folder" : "New Folder";
    var submitText = element && element.id ? "Update" : "Create"

  	return (
      <Modal show={this.props.showFolderModal} onHide={this.props.closeFolderModal} dialogClassName="new-question-modal">
        <Modal.Header closeButton>
          <Modal.Title>
            {modalTitle}
          </Modal.Title>
        </Modal.Header>
        <Modal.Body>
          <form onSubmit={this.saveFolder}>
            <div className="form-group">
              <label htmlFor="input-folder-title">Folder Name</label>
              <input type="text" ref="folder_name" required defaultValue={folderName} placeholder="Give your folder a name" className="form-control" id="input-folder-title" name="folder_name" />
            </div>
            {availableTasks}
          </form>
        </Modal.Body>
        <Modal.Footer>
          <button type="button" className="btn btn-default pull-left" onClick={this.props.closeFolderModal}>Cancel</button>
          <button type="button" className="btn btn-primary" onClick={this.saveFolder}>{submitText}</button>
        </Modal.Footer>
      </Modal>
  	);
  }
}
