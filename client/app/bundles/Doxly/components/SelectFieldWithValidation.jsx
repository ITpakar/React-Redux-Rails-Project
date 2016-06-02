import React, { PropTypes } from 'react';
import classnames from 'classnames';

export default class SelectFieldWithValidation extends React.Component {

  renderErrors() {
    let that = this;
    return (
      <span className={classnames("errors", {"has-error": this.props.errors && this.props.errors.length > 0})}>
      {
        _.map(this.props.errors, function(error, i) {
          return (
            <span className="error-message" key={`${that.props.name}-error-${i}`}>{error}</span>
          )
        })
      }
      </span>
    );
  }

  render() {
    let that = this;

    return (
      <div className="form-group">
        <label htmlFor={this.props.id}>{this.props.label}</label>
        {this.renderErrors()}
        <select id={this.props.id} onChange={this.props.onChange} className="selectpicker form-control show-tick">
          <option>{this.props.placeholder}</option>
          {
            _.map(this.props.options, function(type, index) {
              return (
                <option selected={that.props.value == type} key={`option-${that.props.name}-${index}`}>{type}</option>
              )
            })
          }
        </select>
      </div>
    );
  }
}