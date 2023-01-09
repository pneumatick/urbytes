import React from 'react';

export default class Following extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            following: []
        };

        this.getFollowing = this.getFollowing.bind(this);
        this.handleUpdate = this.handleUpdate.bind(this);

        this.getFollowing().then(
            (result) => {
                this.handleUpdate(result);
                this.props.subscribe();
            }
        );
    }

    async getFollowing() {
        const startIdx = 0;
        const endIdx = 0;
        const path = `/following/between/${startIdx}/${endIdx}`;
        return window.urbit.scry({
            app: "urbytes",
            path: path,
        });
    }

    handleUpdate(upd) {
        this.setState({ following: this.state.following.concat(upd.following) });
    }

    render() {
        let following = [];

        this.state.following.forEach((who, idx) => {
            following.push(
                <div className='following-who' key={idx}>
                    <p>{who}</p>
                </div>
            );
        })

        return (
            <div className='Following'>
                <h2>Following</h2>
                {following}
            </div>
        );
    }
}