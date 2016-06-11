import React, { PropTypes } from 'react';
import classnames from "classnames";

// Props
// elements = {
// 	type: "Document",
// 	title: "Document Title",
// }

export default class CategoryFolder extends React.Component {
  constructor(props, context) {
    super(props, context);

    this.state = {
      bodyClassnames: ["deal-element-folder-wrapper", "collapse"]
    }

    _.bindAll(this, ["selectFile"]);
  }

  selectFile(event) {
    if (event) {
      event.preventDefault();
    }

    this.props.selectElement(this.props.element);
  }

  render() {
    var element = this.props.element;
    var isSelected = this.props.selectedElement &&
                     this.props.selectedElement.id == this.props.element.id &&
                     this.props.selectedElement.type == this.props.element.type;
  	return (
      <div className={classnames({"deal-element-item deal-element-item__file": true, "deal-item-active": isSelected})}>
        <div className="item-header">
          <a className="item-header-item" href="#" onClick={this.selectFile}>{element.title}</a>
        </div>
      </div>
  	);
  }
}
