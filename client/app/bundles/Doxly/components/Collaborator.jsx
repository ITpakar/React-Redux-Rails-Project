import React, { Component, PropTypes } from 'react';
import {bindActionCreators} from 'redux';
import {connect} from 'react-redux';
import {removeCollaborator} from '../reducers/collaboratorReducer';
export default class Collaborator extends Component {
  static propTypes = {
    collaborator: PropTypes.object
  }

  _removeCollaborator = () => {
    this.props.removeCollaborator(this.props.collaborator);
  }

  render() {
    const { collaborator } = this.props;
    var avatar;
    if (collaborator.avatar) {
      avatar = (
        <img className="avatar" src={collaborator.avatar} alt="Img avatar 2" />
      );
    }
    return (
      <li key={collaborator.id} data-collaborator-id={collaborator.id}>
        <a onClick={this._removeCollaborator} className={collaborator.role ? "" : "invited"}>
          {avatar} {collaborator.name}
        </a>
      </li>
    );
  }
}
