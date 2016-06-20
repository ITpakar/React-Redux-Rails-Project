import React, { PropTypes } from 'react';
import { Modal } from 'react-bootstrap';
import ReactDOM from "react-dom";
import Select from 'react-bootstrap-select';
import Util from "../../utils/util";

export default class FolderModal extends React.Component {
  constructor(props, context) {
    super(props, context);
    this.state = {
      clientErrors: undefined,
      serverErrors: undefined,
      isSaving: false
    };
    _.bindAll(this, ["saveFolder"]);
  }

  saveFolder(event) {
    if (event) {
      event.preventDefault();
    }

    if (this.state.isSaving) {
      return;
    }

    var _this = this;
    var folderAttrs = {};
    var element = this.props.element;

    folderAttrs.name = $.trim($(this.refs.folder_name).val());
    folderAttrs.task_id = this.props.parentElement && this.props.parentElement.id || parseInt($.trim($(ReactDOM.findDOMNode(this.refs.task_id)).find("select").val())) || null;

    if (folderAttrs.name && folderAttrs.task_id) {
      this.setState({clientErrors: {}, serverErrors: {}, isSaving: true, serverMessage: undefined});
      if (element && element.id) {
        this.props.updateFolder(element.id, folderAttrs, function() {
          _this.setState({isSaving: false});
          _this.props.closeFolderModal();
        }, function(xhr) {
          var state = {isSaving: false};
          var serverErrors = Util.getErrors(xhr);

          Util.addErrorStates(state, serverErrors);
          _this.setState(state);
        });
      } else {
        this.props.createFolder(folderAttrs, function() {
          _this.setState({isSaving: false});
          _this.props.closeFolderModal();
        }, function(xhr) {
          var state = {isSaving: false};
          var serverErrors = Util.getErrors(xhr);

          Util.addErrorStates(state, serverErrors);
          _this.setState(state);
        });
      }
    } else {
      let clientErrors = {};
      if (!folderAttrs.name) {
        clientErrors.name = "can't be blank";
      }

      if (!folderAttrs.task_id) {
        clientErrors.task_id = "can't be blank";
      }

      this.setState({clientErrors: clientErrors});
    }
  }

  render() {
    var element = this.props.element;
    var availableTasks = [];

    if (!this.props.parentElement && this.props.tasks) {
      let taskId = element && element.task_id;
      let displayedTaskIdErrors = Util.getDisplayedErrorMessage("task_id", this.state.clientErrors, this.state.serverErrors);

      availableTasks = (
        <div className="form-group">
          <label htmlFor="input-task-section">Add to Task</label>
          {displayedTaskIdErrors}
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
    var displayedNameErrors = Util.getDisplayedErrorMessage("name", this.state.clientErrors, this.state.serverErrors);
    var serverMessage;

    if (this.state.serverMessage) {
      serverMessage = (
        <div className="alert alert-danger">{this.state.serverMessage}</div>
      );
    }

  	return (
      <Modal show={this.props.showFolderModal} onHide={this.props.closeFolderModal} dialogClassName="new-question-modal">
        <Modal.Header closeButton>
          <Modal.Title>
            {modalTitle}
          </Modal.Title>
        </Modal.Header>
        <Modal.Body>
          <form onSubmit={this.saveFolder}>
            {serverMessage}
            <div className="form-group">
              <label htmlFor="input-folder-title">Folder Name</label>
              {displayedNameErrors}
              <input type="text" ref="folder_name" required defaultValue={folderName} placeholder="Give your folder a name" className="form-control" id="input-folder-title" name="folder_name" />
            </div>
            {availableTasks}
          </form>
        </Modal.Body>
        <Modal.Footer>
          <button type="button" className="btn btn-default pull-left" onClick={this.props.closeFolderModal}>Cancel</button>
          <button type="button" disabled={this.state.isSaving} className="btn btn-primary" onClick={this.saveFolder}>{submitText}</button>
        </Modal.Footer>
      </Modal>
  	);
  }
}
