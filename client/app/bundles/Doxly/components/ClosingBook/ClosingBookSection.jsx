import React, { PropTypes } from 'react';
import ClosingBookTask from "./ClosingBookTask";
import _ from 'lodash';
import classnames from 'classnames';

export default class CategorySection extends React.Component {
  constructor(props, context) {
    super(props, context);

    var sectionBodyClassnames = ["deal-section__panel", "collapse"];
    if (this.props.isExpanding) {
      sectionBodyClassnames.push("in");
    }

    this.state = {
      sectionBodyClassnames: sectionBodyClassnames,
      open: false
    };

    _.bindAll(this, ['toggleContent', "openTaskModal"]);
  }

  toggleContent(event) {
    if (event) {
      event.preventDefault();
    }

    var sectionBodyClassnames = this.state.sectionBodyClassnames;
    if (sectionBodyClassnames.indexOf("in") >= 0) {
      sectionBodyClassnames = _.without(sectionBodyClassnames, "in");
    } else {
      sectionBodyClassnames.push("in");
    }

    this.setState({sectionBodyClassnames: sectionBodyClassnames, open: !this.state.open});
    this.props.selectElement(undefined);
  }

  openTaskModal(event) {
    if (event) {
      event.preventDefault();
    }

    this.props.openTaskModal(this.props.element);
  }

  render() {
    var element = this.props.element;
    var children = element.elements;
    var displayedChildren = [];

    for (let i = 0; i < children.length; i++) {
      let child = children[i];
      let displayedChild;

      if (child.type == "Task") {
        displayedChild = (
          <ClosingBookTask element={child}
                        selectItem={this.props.selectItem}
                        selected={this.props.selected}
                        key={"task_" + (i + 1)} />
        );
      }

      displayedChildren.push(displayedChild);
    }

    var sectionBodyClassnames = this.state.sectionBodyClassnames;
    var toggleClassnames = ["section-header-title"];

    if (sectionBodyClassnames.indexOf("in") == -1) {
      toggleClassnames.push("collapsed");
    }


    var isSelected = this.props.selectedElement &&
                     this.props.selectedElement.id == this.props.element.id &&
                     this.props.selectedElement.type == this.props.element.type;


    return (
      <div className={classnames({"deal-section-item": true, "deal-item-active": isSelected})}>
        <div className="deal-section__header">
          <a className={toggleClassnames.join(" ")} href="#" onClick={this.toggleContent}>{element.title}</a>
        </div>
        <div className={sectionBodyClassnames.join(" ")}>
          <div className="deal-tasks">
            {displayedChildren}
          </div>
        </div>
      </div>
    );
  }
}
