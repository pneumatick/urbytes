import React from 'react';

export default class Likes extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            likes: []
        };

        this.getLikes = this.getLikes.bind(this);
        this.handleUpdate = this.handleUpdate.bind(this);

        this.getLikes().then(
            (result) => {
                this.handleUpdate(result);
                this.props.subscribe();
            }
        );
    }

    async getLikes() {
        const startIdx = 0;
        const endIdx = 0;
        const path = `/likes/between/${startIdx}/${endIdx}`;
        return window.urbit.scry({
            app: "urbytes",
            path: path,
        });
    }

    handleUpdate(upd) {
        this.setState({ likes: this.state.likes.concat(upd.likes) });
    }

    render() {
        let likes = [];

        this.state.likes.forEach((like, idx) => {
            likes.push(
                <div className='like'>
                    <p>Source: {like[0]}</p>
                    <p>ID: {like[1]}</p>
                </div>
            );
        });

        return (
            <div className='Likes'>
                <h2>Likes</h2>
                {likes}
            </div>
        );
    }
}