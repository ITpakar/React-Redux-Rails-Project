import React, { PropTypes } from 'react';
import { Modal } from 'react-bootstrap';

export default class NewSectionModal extends React.Component {
  constructor(props, context) {
    super(props, context);
    _.bindAll(this, ["createSection"]);
  }

  createSection(event) {
    if (event) {
      event.preventDefault();
    }

    var _this = this;
    var sectionAttrs = {};
    sectionAttrs.name = $.trim($(this.refs.section_name).val());

    if (sectionAttrs.name) {
      this.props.createSection(sectionAttrs, function() {
        _this.props.closeNewSectionModal();
      });
    }
  }

  render() {
  	return (
      <Modal show={this.props.showNewSectionModal} onHide={this.props.closeNewSectionModal} dialogClassName="new-question-modal">
        <Modal.Header closeButton>
          <Modal.Title>
            New Section
          </Modal.Title>
        </Modal.Header>
        <Modal.Body>
          <form onSubmit={this.createSection}>
            <div className="form-group">
              <label htmlFor="input-section-title">Section Title</label>
              <input type="text" ref="section_name" required placeholder="Give your section a title" className="form-control" id="input-section-title" name="section_title" />
            </div>
          </form>
        </Modal.Body>
        <Modal.Footer>
          <button type="button" className="btn btn-default pull-left" onClick={this.props.closeNewSectionModal}>Cancel</button>
          <button type="button" className="btn btn-primary" onClick={this.createSection}>Create</button>
        </Modal.Footer>
      </Modal>
  	);
  }
}
