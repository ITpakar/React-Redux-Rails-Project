import React, { Component, PropTypes } from 'react';
import {bindActionCreators} from 'redux';
import {connect} from 'react-redux';
import _ from 'lodash';
import request from 'axios';
import CommentList from './CommentList/CommentList'
import CommentForm from './CommentForm/CommentForm'
import {setComments, addComment} from '../../reducers/commentReducer';
import {setCollaborators} from '../../reducers/collaboratorReducer';

class CommentBox extends Component {
  static propTypes = {
    comments: PropTypes.array,
    setComments: PropTypes.func,
    addComment: PropTypes.func,
    setCollaborators: PropTypes.func,
  }

  componentDidMount() {

    // Fetch all comments from the backend
    this._fetchComments(this.props.element);
    this._fetchCollaborators();

    // Subscribe to Channel
    this._subscribeToChannel();
  }

  componentWillReceiveProps(props) {
    var currentElement = this.props.element;
    var newElement = props.element;
    if (currentElement.id != newElement.id || currentElement.type != currentElement.type) {
      this._fetchComments(newElement);
    }
  }

  _receivedMessage = (data) => {
    this.props.addComment(data);
    this.forceUpdate();
  }

  _fetchComments = (element) => {
    request
      .get('/api/comments?commentable_id=' + element.id + '&commentable_type=' + element.type)
      .then((res) => {
        this.props.setComments(res.data.data.comments);
        // this.forceUpdate();
      });
  }

  _fetchCollaborators = () => {
    let url = "/api/deals/" + this.props.deal_id + "/deal_collaborators";
    request
      .get(url)
      .then((res) => {
        this.props.setCollaborators(res.data.data.collaborators);
      });
  }

  _subscribeToChannel() {
    App.room = App.cable.subscriptions.create("RoomChannel", {
      connected: () => {},
      disconnected: () => {},
      received: (data) => {
        this._receivedMessage(data);
      },
      speak: function(data) {
        this.perform('speak', data);
      }
    });
  }

  _internalTypeCommentsFilter(commentObject) {
    return commentObject.comment_type == 'Internal';
  }
  _externalTypeCommentsFilter(commentObject) {
    return commentObject.comment_type == 'External';
  }
  render() {
    const {comments, collaborators} = this.props;
    var hideChatboxToggle = this.props.hideChatboxToggle;
    var chatboxToggle;

    if (!hideChatboxToggle) {
      chatboxToggle = (
        <div className="chat-box-toggle">
            <div className="btn-group">
                <a className="btn toggle-active" href="#deal-chat-1-internal">Internal Chat</a>
                <a className="btn" href="#deal-chat-1-external">External Chat</a>
            </div>
        </div>
      );
    }
    
    return (
      <div className="chat-box chat-box-small">
        {chatboxToggle}
        <div className="chat-box-details">
          <div className="chat-box-details__instance internal toggle-active" id="deal-chat-1-internal">
            <div className="chat-box__recipients">
                <div className="chat-box__recipients-wrapper">
                    <div className="recipients-items">
                    {
                      collaborators.map((collaborator, index) => (
                        <a href="#" className="avatar" key={index}><img src={collaborator.avatar}/></a>
                      ))
                    }
                    </div>
                    <a href="#" className="recipient-add" data-toggle="modal" data-target="#modal-edit-deal"><i className="icon-icon-plus-circle"></i></a>
                </div>
            </div>
            <CommentList
              comments={comments.filter(this._internalTypeCommentsFilter)} user_id={this.props.user_id}
            />
            <CommentForm
              commentType="Internal" element={this.props.element} user_id={this.props.user_id}
            />
          </div>

          <div className="chat-box-details__instance external" id="deal-chat-1-external">
            <div className="chat-box__recipients">
                <div className="chat-box__recipients-wrapper">
                    <div className="recipients-items">
                        <a href="#" className="avatar"><img src="/assets/img-avatar-2.png"/></a>
                        <a href="#" className="avatar"><img src="/assets/img-avatar-3.png"/></a>
                    </div>
                    <a href="#" className="recipient-add" data-toggle="modal" data-target="#modal-edit-deal"><i className="icon-icon-plus-circle"></i></a>
                </div>
            </div>
            <CommentList
              comments={comments.filter(this._externalTypeCommentsFilter)} user_id={this.props.user_id}
            />

            <CommentForm
              commentType="External" element={this.props.element} user_id={this.props.user_id}
            />
          </div>
        </div>
      </div>
    );
  }
}
export default connect(
  ({commentStore, collaboratorStore}) => ({ comments: commentStore.comments, collaborators: collaboratorStore.collaborators }),
  dispatch => bindActionCreators({setComments, addComment, setCollaborators}, dispatch)
)(CommentBox);
