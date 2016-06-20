import React, { PropTypes } from 'react';
import { Modal } from 'react-bootstrap';
import Util from "../../utils/util";

export default class SectionModal extends React.Component {
  constructor(props, context) {
    super(props, context);
    this.state = {
      clientErrors: undefined,
      serverErrors: undefined,
      serverMessage: undefined,
      isSaving: false
    };
    _.bindAll(this, ["saveSection"]);
  }

  saveSection(event) {
    if (event) {
      event.preventDefault();
    }

    if (this.state.isSaving) {
      return;
    }

    var _this = this;
    var sectionAttrs = {};
    var element = this.props.element;
    sectionAttrs.name = $.trim($(this.refs.section_name).val());

    if (sectionAttrs.name) {
      this.setState({clientErrors: {}, serverErrors: {}, isSaving: true});
      if (element && element.id) {
        this.props.updateSection(element.id, sectionAttrs, function() {
          _this.props.closeSectionModal();
          _this.setState({isSaving: false});
        }, function(xhr) {
          _this.setState({serverErrors: xhr.responseJSON.errors});
          _this.setState({isSaving: false});
        });
      } else {
        this.props.createSection(sectionAttrs, function() {
          _this.props.closeSectionModal();
          _this.setState({isSaving: false});
        }, function(xhr) {
          var serverErrors = Util.getErrors(xhr);
          var state = {isSaving: false};

          if (serverErrors.errors) {
            state.serverErrors = serverErrors.errors;
          } else if (serverErrors.message){
            state.errorMessage = serverErrors.message;
          }

          _this.setState(state);
        });
      }
    } else {
      this.setState({clientErrors: {name: "Name can't be blank"}});
    }
  }

  render() {
    var element = this.props.element;
    var sectionTitlte = element && element.title;
    var modalTitle = element && element.id ? "Update Section" : "New Section";
    var submitText = element && element.id ? "Update" : "Create";
    var clientErrors = this.state.clientErrors;
    var serverErrors = this.state.serverErrors;
    var displayedNameErrors;
    var nameErrors = [];

    if (clientErrors && clientErrors.name) {
      let nameErrorText = (
        <span className="error-message" key={"client_error"}>{clientErrors.name}</span>
      );

      nameErrors.push(nameErrorText);
    }

    if (serverErrors && serverErrors.name) {
      for (let i = 0; i < serverErrors.name.length; i++) {
        let nameErrorText = (
          <span className="error-message" key={"server_error_" + (i + 1)}>{serverErrors.name[i]}</span>
        );

        nameErrors.push(nameErrorText);
      }
    }

    if (nameErrors.length > 0) {
      displayedNameErrors = (
        <span className="errors has-error">
          {nameErrors}
        </span>
      );
    }

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
              {displayedNameErrors}
              <input type="text" ref="section_name" required defaultValue={sectionTitlte} placeholder="Give your section a title" className="form-control" id="input-section-title" name="section_title" />
            </div>
          </form>
        </Modal.Body>
        <Modal.Footer>
          <button type="button" className="btn btn-default pull-left" onClick={this.props.closeSectionModal}>Cancel</button>
          <button type="button" disabled={this.state.isSaving} className="btn btn-primary" onClick={this.saveSection}>{submitText}</button>
        </Modal.Footer>
      </Modal>
  	);
  }
}
