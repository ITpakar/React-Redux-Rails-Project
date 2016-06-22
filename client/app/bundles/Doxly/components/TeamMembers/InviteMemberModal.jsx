import React, { PropTypes } from 'react';
import { Modal } from 'react-bootstrap';
import Util from "../../utils/util";

export default class DocumentModal extends React.Component {
  constructor(props, context) {
    super(props, context);
    this.state = {
      clientErrors: undefined,
      serverErrors: undefined,
      isInviting: false,
      serverMessage: undefined
    }
    _.bindAll(this, ["inviteMember"]);
  }

  inviteMember(event) {
    if (event) {
      event.preventDefault();
    }

    var _this = this;
    var attrs = {};
    var emailDomain = this.props.emailDomain;

    attrs.first_name = this.refs.first_name.value;
    attrs.last_name = this.refs.last_name.value;
    attrs.email = this.refs.email.value;

    var isEmailValid = Util.isEmailValid(attrs.email);
    var isCorrectDomain;

    if (isEmailValid) {
      let regText = "@" + emailDomain.replace(/\./g, "\\.").replace(/\-/g, "\\-") + "$";
      let exp = new RegExp(regText);

      isCorrectDomain = exp.test(attrs.email)
    }

    if (attrs.first_name && attrs.last_name && isEmailValid && isCorrectDomain) {
      this.setState({isInviting: true, clientErrors: {}, serverErrors: {}, serverMessage: undefined});
      this.props.inviteMember(attrs, function() {
        _this.setState({isInviting: false});
        _this.props.closeInviteModal();
      }, function(xhr) {
        var state = {isInviting: false};
        var serverErrors = Util.getErrors(xhr);

        Util.addErrorStates(state, serverErrors);
        _this.setState(state);
      });
    } else {
      var errors = {};

      if (!attrs.first_name) {
        errors.first_name = "can't be blank";
      }

      if (!attrs.last_name) {
        errors.last_name = "can't be blank";
      }

      if (!attrs.email) {
        errors.email = "can't be blank";
      } else if (!isEmailValid) {
        errors.email = "is not valid";
      } else if (!isCorrectDomain) {
        errors.email = "must end with " + emailDomain;
      }

      this.setState({clientErrors: errors, serverErrors: {}, serverMessage: undefined});
    }
  }

  render() {
    var emailDomain = this.props.emailDomain || "example.com";
    var clientErrors = this.state.clientErrors;
    var serverErrors = this.state.serverErrors;
    var displayedFirstNameError = Util.getDisplayedErrorMessage("first_name", clientErrors, serverErrors);
    var displayedLastNameError = Util.getDisplayedErrorMessage("last_name", clientErrors, serverErrors);
    var displayedEmailError = Util.getDisplayedErrorMessage("email", clientErrors, serverErrors);
    var serverMessage;

    if (this.state.serverMessage) {
      serverMessage = (
        <div className="alert alert-danger">{this.state.serverMessage}</div>
      );
    }

  	return (
      <Modal show={this.props.showInviteModal} onHide={this.props.closeInviteModal} dialogClassName="new-question-modal">
        <Modal.Header closeButton>
          <Modal.Title>
            New User
          </Modal.Title>
        </Modal.Header>
        <Modal.Body>
          <form className="invite-member-form" onSubmit={this.inviteMember}>
            {serverMessage}
            <div className="form-group">
              <label>First Name</label>
              {displayedFirstNameError}
              <input type="text" placeholder="John" className="form-control" ref="first_name" required />
            </div>

            <div className="form-group">
              <label>First Name</label>
              {displayedLastNameError}
              <input type="text" placeholder="Doe" className="form-control" ref="last_name" required />
            </div>

            <div className="form-group">
              <label>Email</label>
              {displayedEmailError}
              <input type="email" placeholder={"example@" + emailDomain} className="form-control" ref="email" required />
            </div>
          </form>
        </Modal.Body>
        <Modal.Footer>
          <button type="button" className="btn btn-default pull-left" onClick={this.props.closeInviteModal}>Cancel</button>
          <button type="button" disabled={this.state.isSaving} className="btn btn-primary" onClick={this.inviteMember}>Create</button>
        </Modal.Footer>
      </Modal>
  	);
  }
}
