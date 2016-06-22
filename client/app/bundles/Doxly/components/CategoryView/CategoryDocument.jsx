import React, { PropTypes } from 'react';
import classnames from "classnames";
import _ from "lodash";

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
    var selectedElement = this.props.selectedElement;
    var isSelected = selectedElement &&
                     selectedElement.id == element.id &&
                     selectedElement.type == element.type;
    var latestVersion;
    var dealDocument = element.deal_documents[element.deal_documents.length - 1];

    if (dealDocument && dealDocument.versions && dealDocument.versions.length > 0) {
      let versionNumber = _.max(_.map(dealDocument.versions, function(version) { return parseInt(version.name);}));
      if (versionNumber > 1) {
        latestVersion = (
          <span className="badge">V{versionNumber}</span>
        );
      }
    }

    return (
      <div className={classnames({"deal-element-item deal-element-item__file": true, "deal-item-active": isSelected})}>
        <div className="item-header">
          <a className="item-header-item" href="#" onClick={this.selectFile}>{element.title} {latestVersion}</a>
          <div className={classnames({'badge-signed': true, "signed": element.signers_count == element.signed_count, "hidden": element.signers_count == 0})}>
            {element.signed_count}/{element.signers_count} signed
          </div>
        </div>
      </div>
  	);
  }
}
