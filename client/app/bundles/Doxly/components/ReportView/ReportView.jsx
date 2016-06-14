import React, { PropTypes } from 'react';
import DealsByTypeReport from "../../containers/DealsByTypeReport";

export default class ReportView extends React.Component {
  constructor(props, context) {
    super(props, context);
    this.state = {
      value: undefined
    };
    _.bindAll(this, []);
  }

  changePeriod() {
    var val = $(this.refs.period).val();

    this.setState({value: val});
    this.props.changePeriod(val);
  }

  render() {
    var periods = [
      {"6_months": "6 Months"},
      {"3_months": "3 Months"},
      {"1_month": "Last Month"}
    ];

  	return (
      <div className="container-fluid">
        <div className="row">
          <div className="col-xs-12">
            <DealsByTypeReport periods={periods}/>
          </div>
        </div>
        <div className="row">
          <div className="col-xs-12 col-md-6">
            <div className="panel panel-report">
              <div className="title">
                <h4>Deals Size</h4>
                <div className="period">
                  <select name="report_2_period" className="selectpicker form-control show-tick">
                    <option>Last 6 Months</option>
                    <option>Last 3 Months</option>
                    <option>Last Month</option>
                  </select>
                </div>
              </div>
              <div className="report" id="report_2">
              </div>
              <div className="report-legend" id="report_legend_2" />
            </div>
          </div>
          <div className="col-xs-12 col-md-6">
            <div className="panel panel-report">
              <div className="title">
                <h4>Deals by Team Members</h4>
              </div>
              <div className="team-report">
                <div className="team-list-item">
                  <div className="team">
                    <div className="team-member-item mini">
                      <a href="#">
                        <div className="avatar">&lt;%= image_tag "img-avatar-5.png" %&gt;</div>
                        <h4>Harvey Specter</h4>
                      </a>
                    </div>
                  </div>
                  <div className="stat">
                    32
                  </div>
                  <div className="graph">
                    <div className="report-user-bars">1,2,4,16,8,2,9,12,16,10</div>
                  </div>
                </div>
                <div className="team-list-item">
                  <div className="team">
                    <div className="team-member-item mini">
                      <a href="#">
                        <div className="avatar"><div className="no-photo">AV</div></div>
                        <h4>Alex Vaughn</h4>
                      </a>
                    </div>
                  </div>
                  <div className="stat">
                    32
                  </div>
                  <div className="graph">
                    <div className="report-user-bars">4,2,4,6,8,2,6,2,6,8</div>
                  </div>
                </div>
                <div className="team-list-item">
                  <div className="team">
                    <div className="team-member-item mini">
                      <a href="#">
                        <div className="avatar">&lt;%= image_tag "img-avatar-5.png" %&gt;</div>
                        <h4>Harvey Specter</h4>
                      </a>
                    </div>
                  </div>
                  <div className="stat">
                    32
                  </div>
                  <div className="graph">
                    <div className="report-user-bars">1,2,3,6,8,12,19,22,26,30</div>
                  </div>
                </div>
                <div className="team-list-item">
                  <div className="team">
                    <div className="team-member-item mini">
                      <a href="#">
                        <div className="avatar"><div className="no-photo">AV</div></div>
                        <h4>Alex Vaughn</h4>
                      </a>
                    </div>
                  </div>
                  <div className="stat">
                    32
                  </div>
                  <div className="graph">
                    <div className="report-user-bars">5,5,4,6,8,2,9,12,10,13</div>
                  </div>
                </div>
                <div className="team-list-item">
                  <div className="team">
                    <div className="team-member-item mini">
                      <a href="#">
                        <div className="avatar">&lt;%= image_tag "img-avatar-5.png" %&gt;</div>
                        <h4>Harvey Specter</h4>
                      </a>
                    </div>
                  </div>
                  <div className="stat">
                    32
                  </div>
                  <div className="graph">
                    <div className="report-user-bars">1,2,14,16,18,12,9,2,6,10</div>
                  </div>
                </div>
                <div className="team-list-item">
                  <div className="team">
                    <div className="team-member-item mini">
                      <a href="#">
                        <div className="avatar"><div className="no-photo">AV</div></div>
                        <h4>Alex Vaughn</h4>
                      </a>
                    </div>
                  </div>
                  <div className="stat">
                    32
                  </div>
                  <div className="graph">
                    <div className="report-user-bars">1,2,4,6,8,10,9,8,6,1</div>
                  </div>
                </div>
                <div className="team-list-item">
                  <div className="team">
                    <div className="team-member-item mini">
                      <a href="#">
                        <div className="avatar">&lt;%= image_tag "img-avatar-5.png" %&gt;</div>
                        <h4>Harvey Specter</h4>
                      </a>
                    </div>
                  </div>
                  <div className="stat">
                    32
                  </div>
                  <div className="graph">
                    <div className="report-user-bars">1,2,4,1,2,2,4,3,6,3</div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
  	);
  }
}
