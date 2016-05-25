import React, { PropTypes } from 'react';

export default class SearchInput extends React.Component {
  render() {
    return (
      <div className="search-input-box">
        <div className="form-group">
          <input name="search_str" 
                 className="input-search form-control" 
                 placeholder="Search Deals" 
                 onChange={this.props.handleChange} />
        </div>
        <a href="#"><i className="icon-icon-search"></i></a>
      </div>
    );
  }
}