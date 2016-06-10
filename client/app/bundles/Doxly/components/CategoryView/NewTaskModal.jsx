import React, { PropTypes } from 'react';
import { Modal } from 'react-bootstrap';

export default class NewTaskModal extends React.Component {
  constructor(props, context) {
    super(props, context);
    _.bindAll(this, ["createTask"]);
  }

  createTask(event) {
    if (event) {
      event.preventDefault();
    }

    var _this = this;
    var taskAttrs = {};
    taskAttrs.title = $.trim($(this.refs.task_title).val());
    taskAttrs.description = $.trim($(this.refs.task_description).val());

    if (taskAttrs.title) {
      this.props.createTask(taskAttrs, function() {
        _this.props.closeNewTaskModal();
      });
    }
  }

  render() {
  	return (
      <Modal show={this.props.showNewTaskModal} onHide={this.props.closeNewTaskModal} dialogClassName="new-question-modal">
        <Modal.Header closeButton>
          <Modal.Title>
            New Task
          </Modal.Title>
        </Modal.Header>
        <Modal.Body>
          <form onSubmit={this.createTask}>
            <div className="form-group">
              <label htmlFor="input-task-title">Task Title</label>
              <input type="text" ref="task_title" required placeholder="Give your task a title" className="form-control" id="input-task-title" name="task_title" />
            </div>
            <div className="form-group">
              <label htmlFor="input-task-description">Task Description</label>
              <textarea ref="task_description" placeholder="Give your task a description" className="form-control" id="input-task-description" name="task_description" />
            </div>
          </form>
        </Modal.Body>
        <Modal.Footer>
          <button type="button" className="btn btn-default pull-left" onClick={this.props.closeNewTaskModal}>Cancel</button>
          <button type="button" className="btn btn-primary" onClick={this.createTask}>Create</button>
        </Modal.Footer>
      </Modal>
  	);
  }
}
