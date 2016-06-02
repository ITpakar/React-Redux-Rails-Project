import React, { PropTypes } from 'react';

export default class CollaboratorControls extends React.Component {
  render() {
    <div className="form-group">
        <label for="input-deal-collaborators">Collaborators</label>
        <input type="text" name="deal_collaborators_input" id="input-deal-collaborators" className="form-control" placeholder="Enter a name or email address">
        <div className="deal-collaborators-widget">
            <ul>
                <li data-collaborator-id="1">
                    <a href="#">
                        <img className="avatar" src="/assets/img-avatar-2-1807bb0ba1c49d49177f3785907d72377097c4adb75ea9cade83041fad86c28c.png" alt="Img avatar 2"> Alex Vaughn
                    </a>
                </li>
                <li data-collaborator-id="5">
                    <a href="#">
                        <img className="avatar" src="/assets/img-avatar-3-02d0c514f0cd0ea359d3d6cd518ab56696792e4df40af78f2c4dc52a1ad8a971.png" alt="Img avatar 3"> Harvey Specter
                    </a>
                </li>
                <li data-collaborator-id="9">
                    <a href="#">
                        <img className="avatar" src="/assets/img-avatar-4-60c2bad58d5fe03cffa7513597bda39417838a15a53f28ee88482f56d40a83b4.png" alt="Img avatar 4"> Rebecca Moss
                    </a>
                </li>
                <li data-collaborator-id="12">
                    <a href="#">
                        <img className="avatar" src="/assets/img-avatar-5-fb5bde0ee6568b839f1aefedf79b6ce616ffc35a7595fc17abc06fbde882ec7d.png" alt="Img avatar 5"> Louisa Curtis
                    </a>
                </li>
                <li data-collaborator-id="18">
                    <a href="#">
                        <img className="avatar" src="/assets/img-avatar-6-720cf80fed5b4cbed5f35f0071b825e30f25eb1bf316a489f98e5026811e6daa.png" alt="Img avatar 6"> Cecilia Hopkins
                    </a>
                </li>
                <li data-collaborator-id="92">
                    <a href="#">
                        <img className="avatar" src="/assets/img-avatar-1-f9794b468f2151d6f36a2d63f5c1e01036fea5df8d7eb1eaa84e7505efbd7361.png" alt="Img avatar 1"> Alvin Jones
                    </a>
                </li>
            </ul>
        </div>
    </div>
  }
}