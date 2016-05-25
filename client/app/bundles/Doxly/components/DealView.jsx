import React from 'react';
import DealList from './DealList';
import SearchInput from './SearchInput';
import GroupedSelectInput from './GroupedSelectInput';

import _ from 'lodash';

export default class DealView extends React.Component {

  // Possible value of state.filter are
  // ALL_DEALS, OPEN_DEALS, CLOSED_DEALS, ARCHIVED_DEALS
  // Possible values of state.sort are
  // CLOSE_DATE, DEAL_TITLE, CLIENT_NAME

  constructor(props, context) {
    super(props, context);

    this.state = {
      deals: this.props.initialDeals,
      visibleDeals: this.props.initialDeals,
      search_term: null,
      filter: 'ALL_DEALS',
      sort: 'CLOSE_DATE' 
    }

    _.bindAll(this, ['handleSearchChange', 'handleFilterChange', 'handleSortChange']);
  }

  getVisibleDeals() {
    // Remove deals that don't match the filter
    let that = this;

    let dealGroups = _.map(this.state.deals, function(dealGroup, index) {
      let deals = dealGroup.deals.filter(function(deal) {
        switch(that.state.filter) {
          case 'ALL_DEALS':
            return true;
          case 'OPEN_DEALS':
            return _.includes(['Unstarted', 'Pending', 'Ongoing', 'Completed'], deal.status)
          case 'CLOSED_DEALS':
            return deal.status === 'Closed'
          case 'ARCHIVED_DEALS':
            return deal.status === 'Archived'
        }
      });

      return {
        heading: dealGroup.heading,
        deals: deals
      }

    });

    // Only accept deals that match our search term
    dealGroups = _.map(dealGroups, function(dealGroup, index) {
      let deals = _.reject(dealGroup.deals, function(deal) {
        if (that.state.search_term === null) {
          return false;
        }
        if (_.includes(deal.title.toLowerCase(), that.state.search_term.toLowerCase()) || _.includes(deal.client_name.toLowerCase(), that.state.search_term.toLowerCase())) {
          return false;
        } else {
          return true;
        }
      });

      return {
        heading: dealGroup.heading,
        deals: deals
      }
    });


    // Remove all dealGroups that have 0 deals
    dealGroups = _.reject(dealGroups, function(dealGroup) {
      return _.isEmpty(dealGroup.deals)
    });

    return dealGroups;
  }

  handleSearchChange(e) {
    if (_.isEmpty(e.target.value)) {
      this.setState({search_term: null})
    } else {
      this.setState({search_term: e.target.value})
    }
  }

  handleFilterChange(filter_value) {
    switch(filter_value) {
      case "All Deals":
        this.setState({filter: 'ALL_DEALS'});
        break;
      case "Open Deals":
        this.setState({filter: 'OPEN_DEALS'});
        break;
      case "Archived Deals":
        this.setState({filter: 'ARCHIVED_DEALS'});
        break;
      case "Closed Deals":
        this.setState({filter: 'CLOSED_DEALS'});
        break;
      default:
        this.setState({filter: 'ALL_DEALS'});
    }
  }

  handleSortChange(e) {
    console.log(e);
  }

  render() {
    return (
      <div className="container-fluid">
        <div className="row">
          <div className="toolbar-box">
            <SearchInput handleChange={this.handleSearchChange} />
            <GroupedSelectInput options={[
                {
                  heading: "Show", 
                  options: ['All Deals', 'Open Deals', 'Closed Deals', 'Archived Deals'],
                  optionsForHeading: ['All Deals', 'Open', 'Closed', 'Archived'],
                  initialSelected: 0,
                  onChange: this.handleFilterChange
                },
                {
                  heading: "Sorted By",
                  options: ['Project Close Date', 'Deal Title', 'Client Name'],
                  optionsForHeading: ['Date', 'Title', 'Name'],
                  initialSelected: 0,
                  onChange: this.handleSortChange
                }
              ]} />
          </div>
        </div>

        <div className="row">
          <div className="content-single">
            <DealList dealGroups={this.getVisibleDeals()} />
          </div>
        </div>
      </div>
    );
  }
}