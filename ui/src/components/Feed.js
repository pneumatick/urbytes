import React from 'react';

export default class Feed extends React.Component {
    constructor(props) {
        super(props);
        this.state = { 
            bites: [],
            feed: [],
            results: [],
            status: null,
            latestUpdate: null
        };

        this.getLikes = this.getLikes.bind(this);
        this.getShares = this.getShares.bind(this);
        this.getFollowing = this.getFollowing.bind(this);
        this.getFollowers = this.getFollowers.bind(this);
        this.getFeed = this.getFeed.bind(this);

        this.subscribe = this.subscribe.bind(this);
        this.handleUpdate = this.handleUpdate.bind(this);
    }

    componentDidMount() {
        this.getFeed().then(
            (result) => {
                //this.handleUpdate(result);
                //this.setState({ latestUpdate: result.time });
                console.log(result.entries);
                this.subscribe();
            }
        );
        this.getBites().then(
            (result) => {
                console.log(result.bites);
                this.subscribe();
            }
        );
        this.getLikes().then(
            (result) => {
                console.log(result.likes);
                this.subscribe();
            }
        );
        this.getShares().then(
            (result) => {
                console.log(result.shares);
                this.subscribe();
            }
        );
        this.getFollowing().then(
            (result) => {
                console.log(result.following);
                this.subscribe();
            }
        );
        this.getFollowers().then(
            (result) => {
                console.log(result.followers);
                this.subscribe();
            }
        );
    }

    async getFeed() {
        const { feed } = this.state;
        const startIdx = feed.length === 0 ? 0 : feed.length - 1;
        const endIdx = startIdx + 10;
        const path = `/feed/between/${startIdx}/${endIdx}`;
        return window.urbit.scry({
            app: "urbytes",
            path: path,
        });
    }

    async getBites() {
        const { bites } = this.state;
        const startIdx = bites.length === 0 ? 0 : bites.length - 1;
        const endIdx = startIdx + 10;
        const path = `/bites/between/${startIdx}/${endIdx}`;
        return window.urbit.scry({
            app: "urbytes",
            path: path,
        });
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

    async getShares() {
        const startIdx = 0;
        const endIdx = 0;
        const path = `/shares/between/${startIdx}/${endIdx}`;
        return window.urbit.scry({
            app: "urbytes",
            path: path,
        });
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

    async getFollowers() {
        const startIdx = 0;
        const endIdx = 0;
        const path = `/followers/between/${startIdx}/${endIdx}`;
        return window.urbit.scry({
            app: "urbytes",
            path: path,
        });
    }

    subscribe() {
        try {
            window.urbit.subscribe({
                app: "urbytes",
                path: "/ui",
                event: this.handleUpdate,
                err: () => this.setErrorMsg("Subscription rejected"),
                quit: () => this.setErrorMsg("Kicked from subscription"),
            });
        } catch {
            this.setErrorMsg("Subscription failed");
        }
    }

    handleUpdate(upd) {
        console.log(upd)
    }

    render() {
        return (
            <div className='Feed'>
                <p>Feed</p>
            </div>
        );
    }
}