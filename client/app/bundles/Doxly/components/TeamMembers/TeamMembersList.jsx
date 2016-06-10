import React, { PropTypes } from 'react';
import Avatar from './Avatar'

export default class TeamMembersList extends React.Component {
  renderTeamItem(teamMember) {
  	return (
  	  <div className="team-list-item">
  	      <div className="team">
  	          <div className="team-member-item">
  	              <a href="/team-item">
                      <Avatar url={teamMember['avatar_name']} initials={teamMember['initials']} />
  	                  <h4>{teamMember['name']}</h4>
  	                  <span>{teamMember['email']}</span>
  	              </a>
  	          </div>
  	      </div>
  	      <div className="stat">
  	          <div className="team-stat-item">
  	              <b>{teamMember['active_deal_count']}</b> Active Deals
  	          </div>
  	          <div className="team-stat-item">
  	              <b>{teamMember['completed_deal_count']}</b> Complete Deals
  	          </div>
  	      </div>
  	      <div className="actions">
  	          <a className="fa fa-gear" href="#"></a>
  	      </div>
  	  </div>
  	);
  }

  render() {
  	let that = this;
  	return (
  	  <div className="panel panel-teams-list">
        <div className="inner">
          {_.map(this.props.teamMembers, function(teamMember) {
          	return that.renderTeamItem(teamMember);
          })}
        </div>
    </div>
  	);
  }
}