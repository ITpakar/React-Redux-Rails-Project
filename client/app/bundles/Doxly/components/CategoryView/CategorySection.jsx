import React, { PropTypes } from 'react';
import CategoryTask from "./CategoryTask";
import CategoryFolder from "./CategoryFolder";
import CategoryDocument from "./CategoryDocument";
import _ from 'lodash';

// Props
// element = {
// 		type: "Section",
// 		title: "Section Title",
// 		elements: [
// 			{
// 				type: "Task",
// 				title: "Task Title",
// 				status: "Complete",
// 				elements: [
// 					{
// 						type: "Document",
// 						title: "Document Title",
// 					},
// 					{
// 						type: "Folder",
// 						title: "Folder Title",
// 						file_count: 42,
// 						elements: [...] // This would be a bunch of documents
// 					}
// 				]
// 			}
// 		]
// 	}


export default class CategorySection extends React.Component {
  constructor(props, context) {
    super(props, context);

    this.state = {
      sectionBodyClassnames: ["deal-section__panel", "collapse"]
    };

    _.bindAll(this, ['toggleContent']);
  }

  toggleContent() {
    var sectionBodyClassnames = this.state.sectionBodyClassnames;
    if (sectionBodyClassnames.indexOf("in") >= 0) {
      sectionBodyClassnames = _.without(sectionBodyClassnames, "in");
    } else {
      sectionBodyClassnames.push("in");
    }

    this.setState({sectionBodyClassnames: sectionBodyClassnames});
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

    var sectionBodyClassnames = this.state.sectionBodyClassnames;
    var toggleClassnames = [];

    if (sectionBodyClassnames.indexOf("in") == -1) {
      toggleClassnames.push("collapsed");
    }
  	return (
			<div className="deal-section-item">
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
