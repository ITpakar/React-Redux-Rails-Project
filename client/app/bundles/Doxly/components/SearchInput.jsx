import React, { PropTypes } from 'react';

export default class SearchInput extends React.Component {
  constructor(props, context) {
    super(props, context);

    _.bindAll(this, ["handleChange"])
  }

  handleChange(event) {
    this.props.handleChange((this.refs.search_term.value || "").toLowerCase());
  }

  render() {
    return (
      <div className="search-input-box">
        <div className="form-group">
          <input name="search_str" 
                 className="input-search form-control" 
                 placeholder={this.props.placeholder} 
                 onChange={this.props.handleChange}
                 ref="search_term" />
        </div>
        <a href="#"><i className="icon-icon-search"></i></a>
      </div>
    );
  }
}
