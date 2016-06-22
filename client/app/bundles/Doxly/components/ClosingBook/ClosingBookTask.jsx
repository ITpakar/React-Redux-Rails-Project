import React, { PropTypes } from 'react';
import ClosingBookFolder from './ClosingBookFolder';
import ClosingBookDocument from "./ClosingBookDocument";
import classnames from 'classnames';


export default class CategoryTask extends React.Component {
  constructor(props, context) {
    super(props, context);

    this.state = {
      bodyClassnames: ["deal-task-item__panel", "collapse"]
    };

    _.bindAll(this, ['toggleContent']);
  }

  toggleContent(event) {
    if (event) {
      event.preventDefault();
    }

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

      if (child.type == "Folder") {
        displayedChild = (
          <ClosingBookFolder element={child}
                             selected={this.props.selected}
                             selectItem={this.props.selectItem}
                             key={"folder_" + (i + 1)} />
        );
      } else if (child.type == "Document") {
        displayedChild = (
          <ClosingBookDocument element={child}
                            selected={this.props.selected}
                             selectItem={this.props.selectItem}
                            key={"document_" + (i + 1)} />
        );
      }

      displayedChildren.push(displayedChild);
    }

    var bodyClassnames = this.state.bodyClassnames;
    var toggleClassnames = ["collapse-trigger"];

    if (bodyClassnames.indexOf("in") == -1) {
      toggleClassnames.push("collapsed");
    }

    var isChecked = (this.props.element.status || "").toLowerCase() == "complete";
    var isSelected = this.props.selectedElement &&
                     this.props.selectedElement.id == this.props.element.id &&
                     this.props.selectedElement.type == this.props.element.type;

    return (
      <div className={classnames({"deal-task-item": true, "deal-item-active" : isSelected, 'complete': this.props.selected[this.props.element.type + '_' + this.props.element.id]})}>
          <div className="deal-task-item__header">
              <span className="checkbox-placeholder"></span>
              <a className="deal-task-item__header-item" href="#" onClick={this.props.selectItem(this.props.element.type, this.props.element.id)}>{element.title}</a>
              <a className={toggleClassnames.join(" ")} href="#" onClick={this.toggleContent}><span>Show Files</span><i>Hide Files</i></a>
          </div>
          <div className={bodyClassnames.join(" ")}>
              <div className="deal-task-elements">
                  {displayedChildren}
              </div>
          </div>
      </div>
    );
  }
}
