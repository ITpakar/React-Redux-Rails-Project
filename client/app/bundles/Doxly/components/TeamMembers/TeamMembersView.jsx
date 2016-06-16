import React, { PropTypes } from 'react';
import TeamMembersList from './TeamMembersList';
import SearchInput from '../SearchInput';
import GroupedSelectInput from '../GroupedSelectInput';

export default class TeamMembersView extends React.Component {
  
  constructor(props, context) {
    super(props, context);

    this.state = {
      searchTerm: null
    }

    _.bindAll(this, ['handleSearchChange', 'handleFilterChange', 'handleClick']);
  }

  handleSearchChange(newValue) {
    if (_.isEmpty(newValue)) {
      this.setState({searchTerm: null})
    } else {
      this.setState({searchTerm: newValue})
    }
  }

  handleFilterChange() {

  }

  handleClick() {

  }

  getVisibleUsers() {
    let that = this;
    let teamMembers = _.reject(this.props.teamMembers, function(teamMember) {
      if (that.state.searchTerm === null) {
        return false;
      } else if (_.includes(teamMember['name'].toLowerCase(), that.state.searchTerm.toLowerCase()) || _.includes(teamMember['email'].toLowerCase(), that.state.searchTerm.toLowerCase())) {
        return false;
      } else {
        return true;
      }
    });
    return teamMembers;
  }

  render() {
  	return (
  	  <div className="container-fluid">
  	    <div className="row">
  	      <div className="toolbar-box">
  	        <SearchInput handleChange={this.handleSearchChange} placeholder="Search Users"/>
  	        <GroupedSelectInput options={[
  	            {
  	              heading: "Sort", 
  	              options: ['Manual Sort'],
  	              optionsForHeading: ['Manual Sort'],
  	              initialSelected: 0,
  	              onChange: this.handleFilterChange
  	            }
  	          ]} />
  	          <a href="#" onClick={this.handleClick} className="btn-add-circle btn-add-deal" data-toggle="modal" data-target="#modal-new-deal"></a>
  	      </div>
  	    </div>

  	    <div className="row">
  	      <div className="content-single">
  	        <TeamMembersList teamMembers={this.getVisibleUsers()} />
  	      </div>
  	    </div>
  	  </div>
  	);
  }
}