import React from 'react';

export default class Followers extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            followers: []
        };

        this.getFollowers = this.getFollowers.bind(this);
        this.handleUpdate = this.handleUpdate.bind(this);

        this.getFollowers().then(
            (result) => {
                this.handleUpdate(result);
                this.props.subscribe();
            }
        );
    }

    async getFollowers() {
        const startIdx = 0;
        const endIdx = 0;
        const path = `/followers/between/${startIdx}/${endIdx}`;
        return window.urbit.scry({
            app: "urbytes",
            path: path,
        });
    }

    handleUpdate(upd) {
        this.setState({ followers: this.state.followers.concat(upd.followers) });
    }

    render() {
        let followers = [];

        this.state.followers.forEach((who, idx) => {
            followers.push(
                <div className='followers-who' key={idx}>
                    <p>{who}</p>
                </div>
            );
        });

        return (
            <div className='Followers'>
                <h2>Followers</h2>
                {followers}
            </div>
        );
    }
}