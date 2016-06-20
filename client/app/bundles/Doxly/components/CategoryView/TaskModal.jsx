import React, { PropTypes } from 'react';
import { Modal } from 'react-bootstrap';

export default class TaskModal extends React.Component {
  constructor(props, context) {
    super(props, context);
    _.bindAll(this, ["saveTask"]);
  }

  saveTask(event) {
    if (event) {
      event.preventDefault();
    }

    var _this = this;
    var taskAttrs = {};
    var element = this.props.element;

    taskAttrs.title = $.trim($(this.refs.task_title).val());
    taskAttrs.description = $.trim($(this.refs.task_description).val());
    taskAttrs.section_id = this.props.parentElement && this.props.parentElement.id || $.trim($(this.refs.task_section).val());
    taskAttrs.assignee_id = this.props.assignee && this.props.assignee.organization_user_id || $.trim($(this.refs.task_assignee).val());

    if (taskAttrs.title && taskAttrs.section_id) {
      if (element && element.id) {
        this.props.updateTask(element.id, taskAttrs, function() {
          _this.props.closeTaskModal();
        });
      } else {
        this.props.createTask(taskAttrs, function() {
          _this.props.closeTaskModal();
        });
      }
    }
  }

  render() {
    var availableSections;
    var element = this.props.element;
    if (!this.props.parentElement && this.props.sections) {
      let selected = element && element.section_id;
      availableSections = (
        <div className="form-group optional">
          <label htmlFor="input-task-section">Add to Section</label>
          <select name="task_section" ref="task_section" defaultValue={selected} className="form-control custom-select">
            <option>Select a Section</option>
            {this.props.sections.map(function(section) {
              return (
                <option value={section.id} key={"section_" + section.id}>{section.title}</option>
              )
            })}
          </select>
        </div>
      );
    }

    var assignees;
    if (!this.props.assignee && this.props.assignees) {
      let selected = element && element.assignee_id;
      assignees = (
        <div className="form-group optional">
          <label htmlFor="input-task-assignee">Add an Assignee</label>
          <select name="task_assignee" ref="task_assignee" defaultValue={selected} className="form-control custom-select">
            <option>Select a Team Member</option>
            {this.props.assignees.map(function(assignee) {
              return (
                <option value={assignee.organization_user_id} key={"assignee_" + assignee.id}>{assignee.first_name} {assignee.last_name}</option>
              );
            })}
          </select>
        </div>
      );
    }

    var taskTitle = element && element.title;
    var taskDescription = element && element.description;
    var modalTitle = element && element.id ? "Update Task" : "New Task"
    var submitText = element && element.id ? "Update" : "Create";

  	return (
      <Modal show={this.props.showTaskModal} onHide={this.props.closeTaskModal} dialogClassName="new-question-modal">
        <Modal.Header closeButton>
          <Modal.Title>
            {modalTitle}
          </Modal.Title>
        </Modal.Header>
        <Modal.Body>
          <form onSubmit={this.saveTask}>
            <div className="form-group">
              <label htmlFor="input-task-title">Task Title</label>
              <input type="text" ref="task_title" required defaultValue={taskTitle} placeholder="Give your task a title" className="form-control" id="input-task-title" name="task_title" />
            </div>
            <div className="form-group">
              <label htmlFor="input-task-description">Task Description</label>
              <textarea ref="task_description" defaultValue={taskDescription} placeholder="Explain this task" className="form-control" id="input-task-description" name="task_description" />
            </div>
            {availableSections}
            {assignees}
          </form>
        </Modal.Body>
        <Modal.Footer>
          <button type="button" className="btn btn-default pull-left" onClick={this.props.closeTaskModal}>Cancel</button>
          <button type="button" className="btn btn-primary" onClick={this.saveTask}>{submitText}</button>
        </Modal.Footer>
      </Modal>
  	);
  }
}
