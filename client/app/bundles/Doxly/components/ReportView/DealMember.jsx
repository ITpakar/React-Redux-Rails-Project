import React, { PropTypes } from 'react';

export default class DealMember extends React.Component {
  constructor(props, context) {
    super(props, context);
    this.state = {
      period: undefined
    };
  }

  render() {
    var reportData = this.props.data;
    var displayedMembers = [];

    for (let i = 0; i < reportData.members.length; i++) {
      let member = reportData.members[i];
      let avatarUrl = "/assets/img-avatar-5.png";
      let record = _.find(reportData.results, function(result) { return result.user_id == member.id; })
      let count = record && record.count;
      let displayedMember = (
        <div className="team-list-item" key={"member_" + (i + 1)}>
            <div className="team">
                <div className="team-member-item mini">
                    <a href="#">
                        <div className="avatar"><img src={avatarUrl} /></div>
                        <h4>{member.first_name} {member.last_name}</h4>
                    </a>
                </div>
            </div>
            <div className="stat">
                {count}
            </div>
            <div className="graph">
                <div className="report-user-bars">1,2,4,16,8,2,9,12,16,10</div>
            </div>
        </div>
      );

      displayedMembers.push(displayedMember);
    }
  	return (
      <div className="panel panel-report">
          <div className="title">
              <h4>Deals by Team Members</h4>
          </div>
          <div className="team-report">
            {displayedMembers}
          </div>
      </div>
  	);
  }
}
