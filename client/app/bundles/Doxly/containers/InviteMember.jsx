import React, { PropTypes } from 'react';
import {doInviteMember} from "../utils/api";
import InviteMemberModal from "../components/TeamMembers/InviteMemberModal";

class InviteMember extends React.Component {
  constructor(props, context) {
    super(props, context);
    _.bindAll(this, ["inviteMember"]);
  }

  inviteMember(attrs, successCallback, errorCallback) {
    doInviteMember(attrs).then(successCallback, errorCallback);
  }

  render() {
    return (<InviteMemberModal emailDomain={this.props.emailDomain}
                           showInviteModal={this.props.showInviteModal}
                           closeInviteModal={this.props.closeInviteModal}
                           inviteMember={this.inviteMember} />);
  }
}

export default InviteMember;
