import React, { propTypes } from 'react';
import classnames from 'classnames';

export default class TextFieldWithValidation extends React.Component {
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
    return (
      <div className="form-group">
        <label htmlFor={this.props.id}>{this.props.label}</label>
        {this.renderErrors()}
        <input type="text" 
               value={this.props.value} 
               onChange={this.props.onChange} 
               name={this.props.name} 
               id={this.props.id} 
               className="form-control" 
               placeholder={this.props.placeholder} 
               required={this.props.required} />
      </div>
    );
    
    
  }
}