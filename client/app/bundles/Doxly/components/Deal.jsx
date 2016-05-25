import React, { PropTypes } from 'react';
import _ from 'lodash';

export default class Deal extends React.Component {

  static propTypes = {
    completion_percent: PropTypes.number.isRequired,
    client_name: PropTypes.string.isRequired,
    title: PropTypes.string.isRequired,
    collaborators: PropTypes.arrayOf(PropTypes.shape({
      avatar: PropTypes.string
    })),
    projected_close_date: PropTypes.string.isRequired

  }

  renderCollaborators(collaborators) {
    return (
      <div className="item-collaborators-wraper">
          {_.map(collaborators, function(collaborator, i) {
            return (
              <a href="#" className="avatar" key={i}>
                <img src={collaborator.avatar_name} />
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
              <div className="progress-pie-chart" data-percent={this.props.completion_percent}></div>
          </div>
          <div className="item-body">
              <a href={`/app/deals/${this.props.id}`} className="item-body__project">
                  <div className="title">{this.props.client_name}</div>
                  <div className="copy">
                    {this.props.title}
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
                  <div className="title"><span className="timestamp">{this.props.projected_close_date}</span></div>
              </div>
          </div>
      </div>
    );
  }
}