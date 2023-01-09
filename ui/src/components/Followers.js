import React from 'react';

export default class Followers extends React.Component {
    constructor(props) {
        super(props);
        this.state = {};

        this.getFollowers = this.getFollowers.bind(this);
    }

    componentDidMount() {
        this.getFollowers().then(
            (result) => {
                console.log(result.followers);
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

    render() {
        return (
            <div className='Followers'>
                <h2>Followers</h2>
            </div>
        );
    }
}