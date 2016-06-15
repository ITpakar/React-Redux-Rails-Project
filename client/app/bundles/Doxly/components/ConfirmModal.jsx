import React, { PropTypes } from 'react';
import { Modal } from 'react-bootstrap';

export default class TaskModal extends React.Component {
  constructor(props, context) {
    super(props, context);
  }

  render() {
    var header;
    if (this.props.confirmTitle) {
      header = (
        <Modal.Header closeButton>
          <Modal.Title>
            {this.props.confirmTitle}
          </Modal.Title>
        </Modal.Header>
      );
    }

  	return (
      <Modal show={this.props.showConfirmModal} onHide={this.props.closeConfirmModal} dialogClassName="new-question-modal">
        {header}
        <Modal.Body>
          <div className="confirmation-content">
            <p>{this.props.confirmText || "Are you sure?"}</p>
          </div>
        </Modal.Body>
        <Modal.Footer>
          <button type="button" className="btn btn-default pull-left" onClick={this.props.dontConfirm}>{this.props.cancelButtonText || "No"}</button>
          <button type="button" className="btn btn-danger" onClick={this.props.doConfirm}>{this.props.confirmButtonText || "Yes"}</button>
        </Modal.Footer>
      </Modal>
  	);
  }
}
