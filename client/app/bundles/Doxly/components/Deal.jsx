import React, { PropTypes } from 'react';
import _ from 'lodash';

export default class Deal extends React.Component {

  static propTypes = {
    percentCompleted: PropTypes.number.isRequired,
    projectTitle: PropTypes.string.isRequired,
    dealTitle: PropTypes.string.isRequired,
    collaborators: PropTypes.arrayOf(PropTypes.shape({
      avatar: PropTypes.string
    })),
    date: PropTypes.string.isRequired

  }

  renderCollaborators(collaborators) {
    return (
      <div className="item-collaborators-wraper">
          {_.map(collaborators, function(collaborator, i) {
            return (
              <a href="#" className="avatar" key="1">
                <img src={collaborator.avatar} />
              </a>
            );
          })}
      </div>
    )
  }

  render() {
    return (
      <div className="project-item">
          <div className="item-percent">
              <div className="progress-pie-chart" data-percent={this.props.percentCompleted}></div>
          </div>
          <div className="item-body">
              <a href="/deals/1" className="item-body__project">
                  <div className="title">{this.props.projectTitle}</div>
                  <div className="copy">
                    {this.props.dealTitle}
                    {(() => {
                      if (this.props.starred) {
                        return (
                          <span className="star"></span>
                        )
                      }
                    })()}
                  </div>
              </a>
              <div className="item-body__collaborators">
                  <div className="title">Collaborators</div>
                  {this.renderCollaborators(this.props.collaborators)}

              </div>
              <div className="item-body__timestamp">
                  <div className="title"><span className="timestamp">{this.props.date}</span></div>
              </div>
          </div>
      </div>
    );
  }
}