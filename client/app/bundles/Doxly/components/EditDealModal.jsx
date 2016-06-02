import React, { PropTypes } from 'react';
import _ from 'lodash';
import classnames from 'classnames';
import DatePicker from 'react-datepicker';
import moment from 'moment'

import TextFieldWithValidation from './TextFieldWithValidation';
import SelectFieldWithValidation from './SelectFieldWithValidation';

export default class EditDealModal extends React.Component {

  constructor(props, context) {
    super(props, context);

    this.state = {
      title: this.props.deal.title,
      clientName: this.props.deal.client_name,
      projectedCloseDate: this.props.deal.projected_close_date,
      transactionType: this.props.deal.transaction_type,
      dealSize: this.props.deal.deal_size,
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
    if (attribute == "projectedCloseDate") {
      return function(date) {
        let state = that.state;
        state[attribute] = date.format('MM/DD/YYYY');
        that.setState(state);
      }
    }
    return function(e) {
      let state = that.state;
      state[attribute] = e.target.value;
      that.setState(state);
    }
  }

  handleClick() {
    let data = {
      deal: {
        title: this.state.title,
        client_name: this.state.clientName,
        transaction_type: this.state.transactionType,
        deal_size: this.state.dealSize,
        projected_close_date: this.state.projectedCloseDate,
      }
    }

    let url = this.props.url;
    let that = this;

    $.ajax({
      url: url,
      method: "PUT",
      data: data
    }).done(function(response) {
      window.location.href = response.data.redirect_to;
    }).fail(function(response) {
      console.log(response);
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
    let that = this;
    return (
      <div className="modal fade in" id="modal-edit-deal" tabindex="-1" role="dialog" aria-labelledby="modal-edit-deal-label">
        <div className="modal-dialog" role="document">
            <div className="modal-content">
                <div className="modal-header">
                    <h4 className="modal-title" id="modal-edit-deal-label">Edit Deal</h4>
                </div>
                <div className="modal-body">
                    <form>
                        <div className="container-fluid">
                            <div className="row">
                                <div className="col-xs-12 col-md-6">
                                    <TextFieldWithValidation name="deal_title" 
                                                             label="Deal Title" 
                                                             value={this.state.title}
                                                             placeholder="Give your task a title" 
                                                             required={true} 
                                                             errors={this.state.errors['title']}
                                                             onChange={this.handleChange('title')} />
                                    <TextFieldWithValidation name="deal_client" 
                                                             label="Client Name" 
                                                             value={this.state.clientName}
                                                             placeholder="Add your client's name or other identifier" 
                                                             required={true} 
                                                             errors={this.state.errors['client_name']}
                                                             onChange={this.handleChange('clientName')} />
                                    <div className="form-group">
                                      <label htmlFor="input-deal-date">Projected Close Date</label>
                                      {this.renderErrors('projected_close_date', 'Projected Close Date')}
                                      <DatePicker
                                        selected={moment(this.state.projectedCloseDate)}
                                        onChange={this.handleChange('projectedCloseDate')}
                                        name="deal_date" 
                                        id="input-deal-date" 
                                        className="form-control" 
                                        placeholderText="MM/DD/YYYY" 
                                        required={true} />
                                    </div>
                                    <SelectFieldWithValidation name="transaction_type"
                                                               label="Transaction Type" 
                                                               value={this.state.transactionType}
                                                               placeholder="Select a Transaction Type" 
                                                               required={true} 
                                                               errors={this.state.errors['transaction_type']}
                                                               onChange={this.handleChange('transaction_type')}
                                                               options={this.props.transaction_types} />
                                    <TextFieldWithValidation name="deal_size" 
                                                             label="Deal Size" 
                                                             value={this.state.dealSize}
                                                             placeholder="$" 
                                                             required={true} 
                                                             errors={this.state.errors['deal_size']}
                                                             onChange={this.handleChange('dealSize')} />
                                </div>
                                <div class="col-xs-12 col-md-6">
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
                <div className="modal-footer">
                    <div className="container-fluid">
                        <div className="row">
                            <div className="col-xs-12">
                                <button type="button" className="btn btn-default pull-left" data-dismiss="modal">Cancel</button>
                                <button type="button" className="btn btn-primary" onClick={this.handleClick}>Save Deal</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
      </div>
    );
  }
}