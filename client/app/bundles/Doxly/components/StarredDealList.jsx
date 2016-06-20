import React, { PropTypes } from 'react';
import { connect } from 'react-redux'


const StarredDealList = ({deals}) => (
  <li>
    {deals.map(function(deal, index) {
      return (
        <a href={deal.url} key={`starred-deal-${index}`}><i className="icon-icon-star"></i> {deal.title}</a>
      );
    })}
  </li>
);

const mapStateToProps = (state) => {
  return {
    deals: state.dealsStore.starred
  }
}

export default connect(mapStateToProps)(StarredDealList);
