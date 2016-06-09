import React, { PropTypes } from 'react';
import CategorySection from "./CategorySection";
import CategoryTask from "./CategoryTask";
import CategoryDocument from "./CategoryDocument";

// Props
// elements = {
// 	type: "Folder",
// 	title: "Folder Title",
// 	file_count: 42,
// 	elements: [...] // This would be a bunch of documents
// }

export default class CategoryFolder extends React.Component {
  constructor(props, context) {
    super(props, context);

    this.state = {
      bodyClassnames: ["deal-element-folder-wrapper", "collapse"]
    }

    _.bindAll(this, ['toggleContent']);
  }

  toggleContent() {
    var bodyClassnames = this.state.bodyClassnames;
    if (bodyClassnames.indexOf("in") >= 0) {
      bodyClassnames = _.without(bodyClassnames, "in");
    } else {
      bodyClassnames.push("in");
    }

    this.setState({bodyClassnames: bodyClassnames});
  }

  render() {
    var element = this.props.element;
    var children = element.elements;
    var displayedChildren = [];

    for (let i = 0; i < children.length; i++) {
      let child = children[i];
      let displayedChild;

      if (child.type == "Section") {
        displayedChild = (
          <CategorySection element={child} />
        );
      } else if (child.type == "Task") {
        displayedChild = (
          <CategoryTask element={child} />
        );
      } else if (child.type == "Folder") {
        displayedChild = (
          <CategoryFolder element={child} />
        );
      } else if (child.type == "Document") {
        displayedChild = (
          <CategoryDocument element={child} />
        );
      }

      displayedChildren.push(displayedChild);
    }

    var bodyClassnames = this.state.bodyClassnames;
    var toggleClassnames = ["collapse-trigger"];

    if (bodyClassnames.indexOf("in") == -1) {
      bodyClassnames.push("collapsed");
    }

  	return (
      <div className="deal-element-item deal-element-item__folder">
        <div className="item-header">
          <a className="item-header-item" href="/deal-file">{element.title}</a>
          <a className={toggleClassnames.join(" ")} href="#" onClick={this.toggleContent}>
            <span>Show {element.file_count} Files</span>
            <i>Hide Files</i>
          </a>
        </div>
        <div className={bodyClassnames.join(" ")}>
          <div className="deal-element-folder-elements">
            {displayedChildren}
          </div>
        </div>
      </div>
  	);
  }
}
