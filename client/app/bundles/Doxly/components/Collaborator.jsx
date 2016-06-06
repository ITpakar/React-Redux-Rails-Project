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
    return (
      <li key={collaborator.id} data-collaborator-id={collaborator.id}>
        <a onClick={this._removeCollaborator}>
          <img className="avatar" src="/assets/img-avatar-2-1807bb0ba1c49d49177f3785907d72377097c4adb75ea9cade83041fad86c28c.png" alt="Img avatar 2" /> {collaborator.name}
        </a>
      </li>
    );
  }
}
