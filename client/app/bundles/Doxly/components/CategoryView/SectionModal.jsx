import React, { PropTypes } from 'react';
import { Modal } from 'react-bootstrap';

export default class SectionModal extends React.Component {
  constructor(props, context) {
    super(props, context);
    _.bindAll(this, ["saveSection"]);
  }

  saveSection(event) {
    if (event) {
      event.preventDefault();
    }

    var _this = this;
    var sectionAttrs = {};
    var element = this.props.element;
    sectionAttrs.name = $.trim($(this.refs.section_name).val());

    if (sectionAttrs.name) {
      if (element && element.id) {
        this.props.updateSection(element.id, sectionAttrs, function() {
          _this.props.closeSectionModal();
        });
      } else {
        this.props.createSection(sectionAttrs, function() {
          _this.props.closeSectionModal();
        });
      }
    }
  }

  render() {
    var element = this.props.element;
    var sectionTitlte = element && element.title;
    var modalTitle = element && element.id ? "Update Section" : "New Section";
    var submitText = element && element.id ? "Update" : "Create"

  	return (
      <Modal show={this.props.showSectionModal} onHide={this.props.closeSectionModal} dialogClassName="new-question-modal">
        <Modal.Header closeButton>
          <Modal.Title>
            {modalTitle}
          </Modal.Title>
        </Modal.Header>
        <Modal.Body>
          <form onSubmit={this.saveSection}>
            <div className="form-group">
              <label htmlFor="input-section-title">Section Title</label>
              <input type="text" ref="section_name" required defaultValue={sectionTitlte} placeholder="Give your section a title" className="form-control" id="input-section-title" name="section_title" />
            </div>
          </form>
        </Modal.Body>
        <Modal.Footer>
          <button type="button" className="btn btn-default pull-left" onClick={this.props.closeSectionModal}>Cancel</button>
          <button type="button" className="btn btn-primary" onClick={this.saveSection}>{submitText}</button>
        </Modal.Footer>
      </Modal>
  	);
  }
}
