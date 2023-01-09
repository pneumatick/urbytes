import React from 'react';

export default class Following extends React.Component {
    constructor(props) {
        super(props);
        this.state = {};

        this.getFollowing = this.getFollowing.bind(this);
    }

    componentDidMount() {
        this.getFollowing().then(
            (result) => {
                console.log(result.following);
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

    render() {
        return (
            <div className='Following'>
                <h2>Following</h2>
            </div>
        );
    }
}