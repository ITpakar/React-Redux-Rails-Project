import React, { PropTypes } from 'react';
import Deal from './Deal'

export default class DealList extends React.Component {
  static propTypes = {
    dealGroups: PropTypes.arrayOf(PropTypes.shape({
      heading: PropTypes.string,
      deals: PropTypes.array
    }))
  }

  renderDealGroup(dealGroup, index) {
    return (
      <div className="deals-full-group" key={`dealGroup-${index}`}>
        <div className="deals-full-group__header">
            {dealGroup.heading}
        </div>
        {
          _.map(dealGroup.deals, function(deal, i) {
            return (
              <div className="deals-full-group__projects" key={`dealGroup-${index}-${i}`}>
                <Deal {...deal} key={`deal-${index}-${i}`}/>
              </div>
            )
          })
        }
      </div>
    )
  }


  render() {
    let that = this;
    return (
      <div className="panel panel-deals-full">
        {_.map(this.props.dealGroups, function(dealGroup, index) {
          return that.renderDealGroup(dealGroup, index)
        })}
      </div>
    );
  }
}