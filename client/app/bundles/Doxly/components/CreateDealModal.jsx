import React, { PropTypes } from 'react';
import _ from 'lodash';
import classnames from 'classnames';

export default class CreateDealModal extends React.Component {

  constructor(props, context) {
    super(props, context);

    this.state = {
      dealTitle: "",
      clientName: "",
      projectedCloseDate: "",
      transactionType: "",
      dealSize: "",
      errors: {
        title: [],
        client_name: [],
        projected_close_date: [],
        transaction_type: [],
        deal_size: [],
      }
    }

    _.bindAll(this, ['handleChange', 'handleClick']);
  }

  handleChange(attribute) {
    let that = this;
    return function(e) {
      let state = that.state;
      state[attribute] = e.target.value;
      that.setState(state);
    }
  }

  handleClick() {
    let data = {
      deal: {
        organization_id: this.props.organization_id,
        title: this.state.dealTitle,
        client_name: this.state.clientName,
        transaction_type: this.state.transactionType,
        deal_size: this.state.dealSize,
        projected_close_date: this.state.projectedCloseDate,
        status: "Unstarted",
        activated: true
      }
    }

    let url = this.props.url;
    let that = this;

    $.ajax({
      url: url,
      method: "POST",
      data: data
    }).done(function(response) {
      window.location.href = response.data.redirect_to;
    }).fail(function(response) {
      that.setState({errors: response.responseJSON.errors.messages});
    });
  }

  renderErrors(id, name) {
    return (
      <span className={classnames("errors", {"has-error": this.state.errors[id] && this.state.errors[id].length > 0})}>
        {
          _.map(this.state.errors[id], function(error, i) {
            return (
              <span className="error-message" key={`${name}-error-${i}`}>{error}</span>
            )
          })
        }
      </span>
    )
  }

  render() {
    return (
      <div className="modal fade" id="modal-new-deal" tabIndex={-1} role="dialog" aria-labelledby="modal-new-deal-label">
        <div className="modal-dialog" role="document">
          <div className="modal-content">
            <div className="modal-header">
              <h4 className="modal-title" id="modal-new-deal-label">New Deal</h4>
            </div>
            <div className="modal-body">
              <form>
                <div className="form-group">
                  <label htmlFor="input-deal-title">Deal Title</label>
                  {this.renderErrors('title', 'Deal Title')}
                  <input type="text" value={this.state.dealTitle} onChange={this.handleChange('dealTitle')} name="deal_title" id="input-deal-title" className="form-control" placeholder="Give your task a title" required />
                </div>
                <div className="form-group">
                  <label htmlFor="input-deal-client">Client Name</label>
                  {this.renderErrors('client_name', 'Client Name')}
                  <input type="text" value={this.state.dealClient} onChange={this.handleChange('clientName')} name="deal_client" id="input-deal-client" className="form-control" placeholder="Add your client's name or other identifier" required />
                </div>
                <div className="form-group">
                  <label htmlFor="input-deal-date">Projected Close Date</label>
                  {this.renderErrors('projected_close_date', 'Projected Close Date')}
                  <input type="text" value={this.state.projectedCloseDate} onChange={this.handleChange('projectedCloseDate')} name="deal_date" id="input-deal-date" className="form-control" placeholder="MM/DD/YYYY" required />
                </div>
                <div className="form-group">
                  <label htmlFor="input-deal-transaction">Transaction Type</label>
                  {this.renderErrors('transaction_type', 'Transaction Type')}
                  <select id="input-deal-transaction" onChange={this.handleChange('transactionType')} className="selectpicker form-control show-tick">
                    <option>Select a Transaction Type</option>
                    {
                      _.map(this.props.transaction_types, function(type, index) {
                        return (
                          <option>{type}</option>
                        )
                      })
                    }
                  </select>
                </div>
                <div className="form-group">
                  <label htmlFor="input-deal-size">Deal Size</label>
                  {this.renderErrors('deal_size', 'Deal Size')}
                  <input type="text" value={this.state.dealSize} onChange={this.handleChange('dealSize')} name="deal_size" id="input-deal-size" className="form-control" placeholder="$" required />
                </div>
              </form>
            </div>
            <div className="modal-footer">
              <button type="button" className="btn btn-default pull-left" data-dismiss="modal">Cancel</button>
              <button type="button" className="btn btn-primary" onClick={this.handleClick}>Create</button>
            </div>
          </div>
        </div>
      </div>
    );
  }
}