import React, { PropTypes } from 'react';
import {bindActionCreators} from 'redux';
import {connect} from 'react-redux';
import _ from 'lodash';
import request from 'axios';
import Collaborator from './Collaborator';
import {setCollaborators, addCollaborator, removeCollaborator} from '../reducers/collaboratorReducer';
import TextFieldWithValidation   from './TextFieldWithValidation';

class CollaboratorControls extends React.Component {
  constructor(props, context) {
    super(props, context);

    this.state = {
      error: []
    };
  }

  componentDidMount() {
    this._reset();
    $("#modal-edit-deal").on('hidden.bs.modal', this._reset);
  }

  _reset = () => {
    // Fetch all collaborators from the backend
    this._fetchCollaborators();
    this._clearCollaboratorInput();
  }

  _fetchCollaborators = () => {
    let url = "/api/deals/" + this.props.dealId + "/deal_collaborators";
    request
      .get(url)
      .then((res) => {
        console.log(res.data.data.collaborators);
        this.props.setCollaborators(res.data.data.collaborators);
        this.forceUpdate();
      });
  }
  _handleKeyDown = (e) => {
    console.log(e.keyCode);
    if (e.keyCode == 13) {
      const collaboratorIdentifier = e.target.value;
      request
        .get('/api/deals/' + this.props.dealId + '/deal_collaborators/find?collaborator_identifier=' + collaboratorIdentifier)
        .then((res) => {
          this.props.addCollaborator(res.data.data.collaborator);
          this.forceUpdate();
          this._clearCollaboratorInput();
        })
        .catch(error => {
          this._clearCollaboratorInput(error.data ? error.data.errors.messages[0] : "Connect failed");
        });
    }
  }
  _removeCollaborator = (collaborator) => {
    console.log(collaborator);
    this.props.removeCollaborator(collaborator);
    this.forceUpdate();
  }

  _clearCollaboratorInput = (error) => {
    let state = this.state;
    state['error'] = error ? [ error ] : [ ];
    this.setState(state);
    this.refs.collaboratorIdentifier.clearValue();
  }

  render() {
    let { collaborators } = this.props;
    return (
      <div className="form-group">
        <label for="input-deal-collaborators">Collaborators</label>
        <TextFieldWithValidation ref="collaboratorIdentifier"
                                 name="deal_collaborators_input" 
                                 placeholder="Enter a name or email address" 
                                 errors={this.state.error}
                                 onKeyDown={this._handleKeyDown} 
                                 containerClassName="no-margin"/>
        <div className="deal-collaborators-widget">
          <ul>
            {
              collaborators.map(collaborator => (
                <Collaborator 
                  key={collaborator.id}
                  collaborator={collaborator}
                  removeCollaborator={this._removeCollaborator}
                />
              ))
            }   
          </ul>
        </div>
      </div>
    );
  }
}
export default connect(
  ({collaboratorStore}) => ({ collaborators: collaboratorStore.collaborators }),
  dispatch => bindActionCreators({setCollaborators, addCollaborator, removeCollaborator}, dispatch)
)(CollaboratorControls);