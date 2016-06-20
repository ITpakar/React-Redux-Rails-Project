import React, { PropTypes } from 'react';
import { Modal } from 'react-bootstrap';
import ReactDOM from "react-dom";
import Select from 'react-bootstrap-select';
import Util from "../../utils/util";

export default class TaskModal extends React.Component {
  constructor(props, context) {
    super(props, context);
    this.state = {
      clientErrors: undefined,
      serverErrors: undefined,
      isSaving: false
    };
    _.bindAll(this, ["saveTask"]);
  }

  saveTask(event) {
    if (event) {
      event.preventDefault();
    }

    if (this.state.isSaving) {
      return;
    }

    var _this = this;
    var taskAttrs = {};
    var element = this.props.element;

    taskAttrs.title = $.trim($(this.refs.task_title).val());
    taskAttrs.description = $.trim($(this.refs.task_description).val());
    taskAttrs.section_id = this.props.parentElement && this.props.parentElement.id || parseInt($.trim($(ReactDOM.findDOMNode(this.refs.task_section)).find("select").val())) || null;
    taskAttrs.assignee_id = this.props.assignee && this.props.assignee.organization_user_id || parseInt($.trim($(ReactDOM.findDOMNode(this.refs.task_assignee)).find("select").val())) || null;

    if (taskAttrs.title && taskAttrs.section_id) {
      this.setState({clientErrors: {}, serverErrors: {}, isSaving: true, serverMessage: undefined});
      if (element && element.id) {
        this.props.updateTask(element.id, taskAttrs, function() {
          _this.setState({isSaving: false});
          _this.props.closeTaskModal();
        }, function(xhr) {
          var serverErrors = Util.getErrors(xhr);
          var state = {isSaving: false};

          Util.addErrorStates(state, serverErrors);
          _this.setState(state);
        });
      } else {
        this.props.createTask(taskAttrs, function() {
          _this.setState({isSaving: false});
          _this.props.closeTaskModal();
        }, function(xhr) {
          var serverErrors = Util.getErrors(xhr);
          var state = {isSaving: false};

          Util.addErrorStates(state, serverErrors);
          _this.setState(state);
        });
      }
    } else {
      var errors = {};
      if (!taskAttrs.title) {
        errors.title = "can't be blank";
      }

      if (!taskAttrs.section_id) {
        errors.section_id = "can't be blank";
      }

      this.setState({clientErrors: errors});
    }
  }

  render() {
    var availableSections;
    var element = this.props.element;
    var clientErrors = this.state.clientErrors;
    var serverErrors = this.state.serverErrors;

    if (!this.props.parentElement && this.props.sections) {
      let selected = element && element.section_id;
      let displayedSectionErrors = Util.getDisplayedErrorMessage("section_id", clientErrors, serverErrors);

      availableSections = (
        <div className="form-group">
          <label htmlFor="input-task-section">Add to Section</label>
          {displayedSectionErrors}
          <Select name="task_section" ref="task_section" defaultValue={selected} className="show-tick">
            <option>Select a Section</option>
            {this.props.sections.map(function(section) {
              return (
                <option value={section.id} key={"section_" + section.id}>{section.title}</option>
              )
            })}
          </Select>
        </div>
      );
    }

    var assignees;
    if (!this.props.assignee && this.props.assignees) {
      let selected = element && element.assignee_id;
      let displayedAssigneeErrors = Util.getDisplayedErrorMessage("assignee_id", clientErrors, serverErrors);

      assignees = (
        <div className="form-group optional">
          <label htmlFor="input-task-assignee">Add an Assignee</label>
          {displayedAssigneeErrors}
          <Select name="task_assignee" ref="task_assignee" defaultValue={selected} className="show-tick">
            <option>Select a Team Member</option>
            {this.props.assignees.map(function(assignee) {
              return (
                <option value={assignee.organization_user_id} key={"assignee_" + assignee.id}>{assignee.first_name} {assignee.last_name}</option>
              );
            })}
          </Select>
        </div>
      );
    }

    var taskTitle = element && element.title;
    var taskDescription = element && element.description;
    var modalTitle = element && element.id ? "Update Task" : "New Task"
    var submitText = element && element.id ? "Update" : "Create";
    var displayedTitleErrors = Util.getDisplayedErrorMessage("title", clientErrors, serverErrors);
    var displayedDescriptionErrors = Util.getDisplayedErrorMessage("description", clientErrors, serverErrors);
    var serverMessage;

    if (this.state.serverMessage) {
      serverMessage = (
        <div className="alert alert-danger">{this.state.serverMessage}</div>
      );
    }

  	return (
      <Modal show={this.props.showTaskModal} onHide={this.props.closeTaskModal} dialogClassName="new-question-modal">
        <Modal.Header closeButton>
          <Modal.Title>
            {modalTitle}
          </Modal.Title>
        </Modal.Header>
        <Modal.Body>
          <form onSubmit={this.saveTask}>
            {serverMessage}
            <div className="form-group">
              <label htmlFor="input-task-title">Task Title</label>
              {displayedTitleErrors}
              <input type="text" ref="task_title" required defaultValue={taskTitle} placeholder="Give your task a title" className="form-control" id="input-task-title" name="task_title" />
            </div>
            <div className="form-group">
              <label htmlFor="input-task-description">Task Description</label>
              {displayedDescriptionErrors}
              <textarea ref="task_description" defaultValue={taskDescription} placeholder="Explain this task" className="form-control" id="input-task-description" name="task_description" />
            </div>
            {availableSections}
            {assignees}
          </form>
        </Modal.Body>
        <Modal.Footer>
          <button type="button" className="btn btn-default pull-left" onClick={this.props.closeTaskModal}>Cancel</button>
          <button type="button" disabled={this.state.isSaving} className="btn btn-primary" onClick={this.saveTask}>{submitText}</button>
        </Modal.Footer>
      </Modal>
  	);
  }
}
