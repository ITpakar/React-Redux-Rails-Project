import React, { PropTypes } from 'react';
import TeamMembersList from './DealList';
import SearchInput from '../SearchInput';
import GroupedSelectInput from '../GroupedSelectInput';

export default class TeamMembersView extends React.Component {
  
  handleSearchChange() {

  }

  handleFilterChange() {

  }

  handleClick() {

  }

  getVisibleUsers() {

  }

  render() {
  	return (
  	  <div className="container-fluid">
  	    <div className="row">
  	      <div className="toolbar-box">
  	        <SearchInput handleChange={this.handleSearchChange} />
  	        <GroupedSelectInput options={[
  	            {
  	              heading: "Sort", 
  	              options: ['Manual Sort'],
  	              optionsForHeading: ['Manual Sort'],
  	              initialSelected: 0,
  	              onChange: this.handleFilterChange
  	            },
  	            {
  	          ]} />
  	          <a href="#" onClick={this.handleClick} className="btn-add-circle btn-add-deal" data-toggle="modal" data-target="#modal-new-deal"></a>
  	      </div>
  	    </div>

  	    <div className="row">
  	      <div className="content-single">
  	        <DealList dealGroups={this.getVisibleUsers()} />
  	      </div>
  	    </div>
  	  </div>
  	);
  }
}