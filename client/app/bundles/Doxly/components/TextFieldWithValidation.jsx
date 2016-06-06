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
      <div className={this.props.containerClassName ? this.props.containerClassName : "form-group"}>
        <label htmlFor={this.props.id} className={this.props.label ? '' : 'hidden'}>{this.props.label}</label>
        {this.renderErrors()}
        <input ref='textbox'
               type="text" 
               value={this.props.value} 
               onChange={this.props.onChange} 
               onKeyDown={this.props.onKeyDown} 
               name={this.props.name} 
               id={this.props.id} 
               className="form-control" 
               placeholder={this.props.placeholder} 
               required={this.props.required} />
      </div>
    );
    
    
  }

  clearValue() {
    this.refs.textbox.value = '';
  }
}