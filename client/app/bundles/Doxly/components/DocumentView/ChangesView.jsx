import React, { PropTypes } from 'react';

export default class ChangesView extends React.Component {
  constructor(props, context) {
    super(props, context);
  }

  render() {
    var changes = this.props.changes;
    var displayedChanges = [];

    for (let i = 0; i < changes.length; i++) {
      let change = changes[i];
      let displayChange = (
        <div className="change" key={"change_" + (i + 1)}>
          <div className="title">{change.title}</div>
          <div className="change-item removed">
            <div className="section">
              <p>{change.removed_section}</p>
            </div>
            <div className="details">
              <p>{change.removed_content}</p>
            </div>
          </div>
          <div className="change-item added">
            <div className="section">
              <p>{change.new_section}</p>
            </div>
            <div className="details">
              <p>{change.new_content}</p>
            </div>
          </div>
        </div>
      );

      displayedChanges.push(displayChange);
    }

    return (
      <div className="panel panel-changes">
        {displayedChanges}
      </div>
    );
  }
}
