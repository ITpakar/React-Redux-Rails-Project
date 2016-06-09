import React, { PropTypes } from 'react';

// Props
// elements = {
// 	type: "Document",
// 	title: "Document Title",
// }

export default class CategoryFolder extends React.Component {
  render() {
    var element = this.props.element;

  	return (
      <div className="deal-element-item deal-element-item__file">
        <div className="item-header">
          <a className="item-header-item" href="/deal-file">{element.title}</a>
        </div>
      </div>
  	);
  }
}
