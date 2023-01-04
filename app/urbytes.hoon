/-  *urbytes
/+  default-agent, dbug
|%
+$  versioned-state
  $%  state-0
  ==
+$  state-0 
  $:  %0
      =bites-map 
      =bites-list 
      =comments-map
      =comments-list
      =likes 
      =shares 
      =following
      =followers
  ==
+$  card  card:agent:gall
--
%-  agent:dbug
=|  state-0
=*  state  -
^-  agent:gall
|_  =bowl:gall
+*  this  .
    def   ~(. (default-agent this %.n) bowl)
::
++  on-init
  ^-  (quip card _this)
  `this
::
++  on-save
  ^-  vase
  !>(state)
::
++  on-load
  |=  old-state=vase
  ^-  (quip card _this)
  =/  old  !<(versioned-state old-state)
  ?-  -.old
    %0  `this(state old)
  ==
::
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  |^
  ?+    mark  (on-poke:def mark vase)
      %urbytes-action
    =^  cards  state
      (handle-poke !<(action vase))
    [cards this]
  ==
  ++  handle-poke
    |=  =action
    ^-  (quip card _state)
    ?-    -.action
        %serve
      :: more needs to be done here, this is not enough
      =/  id-hash  (sham [now.bowl our.bowl content.action])
      =/  bite  ^-  bite  
        :*  now.bowl
            content.action 
            `(set source)`~ 
            `(set source)`~ 
            `(map source id)`~
        ==
      :_  %=  state
            bites-map   (~(put by bites-map) id-hash bite)
            bites-list  (weld ~[id-hash] bites-list)
          ==
      :~  :*  %give  %fact  ~[/updates]  %urbytes-update
              !>(`update`action)
          ==
      ==
    ::
        %del
      :_  %=  state
            bites-map   (~(del by bites-map) id.action)
            bites-list  (skip `(list id)`bites-list |=(a=@uvH =(a id.action)))
          ==
      :~  :*  %give  %fact  ~[/updates]  %urbytes-update
              !>(`update`action)
          ==
      ==
    ::
        %like
      :: TODO: add a way to remove likes from this likes list
      :_  state(likes (weld ~[[source.action id.action]] likes))
      :~  :*  %pass  /like  %agent  [source.action %urbytes] 
              %poke  %urbytes-action  !>([%receive-like id.action])
          ==
      ==
      ::
        %receive-like
      =/  toggle  |=  [=bite src=@p]
        ?-  (~(has in likes.bite) src)
          %.n  (~(put in likes.bite) src)
          %.y  (~(del in likes.bite) src)
        ==
      =/  old-bite  (~(got by bites-map) id.action)
      =/  new-likes  (toggle old-bite src.bowl)
      =/  new-bite  ^-  bite
          :*  date=date.old-bite
              content=content.old-bite
              likes=new-likes
              shares=shares.old-bite
              comments=comments.old-bite
          ==
      :_  state(bites-map (~(put by bites-map) id.action new-bite))
      ~
      :::~  :*  %give  %fact  ~[/updates]  %urbytes-update
      ::        !>(`update`action)
      ::    ==
      ::==
    ::
        %share
      :: TODO: add a way to remove shares from this shares list
      :_  state(shares (weld ~[[source.action id.action]] shares))
      :~  :*  %pass  /like  %agent  [source.action %urbytes] 
              %poke  %urbytes-action  !>([%receive-share id.action])
          ==
      ==
    ::
        %receive-share
      :: TODO: add the source to the bite's shares list
      =/  toggle  |=  [=bite src=@p]
        ?-  (~(has in shares.bite) src)
          %.n  (~(put in shares.bite) src)
          %.y  (~(del in shares.bite) src)
        ==
      =/  old-bite  (~(got by bites-map) id.action)
      =/  new-shares  (toggle old-bite src.bowl)
      =/  new-bite  ^-  bite
          :*  date=date.old-bite
              content=content.old-bite
              likes=likes.old-bite
              shares=new-shares
              comments=comments.old-bite
          ==
      :_  state(bites-map (~(put by bites-map) id.action new-bite))
      ~
      ::`state(shares (weld ~[[src.bowl id.action]] shares))
    ::
        %comment
      :: TODO: add a way to delete comments
      =/  id-hash  (sham [now.bowl our.bowl source.action id.action content.action])
      =/  bite  ^-  bite  
        :*  now.bowl
            content.action 
            `(set source)`~ 
            `(set source)`~ 
            `(map source id)`~
        ==
      =/  comment  [source.action id.action bite]
      :_  %=  state
            comments-map   (~(put by comments-map) id-hash comment)
            comments-list  (weld ~[id-hash] comments-list)
          ==
      ~
    ::
        %follow
      :: add permission checks
      :_  state(following (~(put in following) who.action))
      :~  [%pass /follows %agent [+.action %urbytes] %watch /updates]
      ==
    ::
        %unfollow
      :: add permission checks
      :_  state(following (~(del in following) who.action))
      :~  [%pass /follows %agent [+.action %urbytes] %leave ~]
      ==
    ==
  --
::
++  on-watch
  |=  =path
  ^-  (quip card _this)
  ?+    path  (on-watch:def path)
      [%updates ~]
    ~&  'Got subscribe'  :: for debugging only; remove later
    [~ this(followers (~(put in followers) src.bowl))]
    :::_  this
    :::~  [%give %fact ~ %urbytes-update !>(`update`initial+tweets)]
    ::==
  ==
::
++  on-leave
  |=  =path
  ^-  (quip card _this)
  ?+    path  (on-watch:def path)
      [%updates ~]
    ~&  'Got unsubscribe'  :: for debugging only; remove later
    [~ this(followers (~(del in followers) src.bowl))]
  ==
++  on-peek   on-peek:def
++  on-agent
  |=  [=wire =sign:agent:gall]
  ^-  (quip card _this)
  ?+    wire  (on-agent:def wire sign)
      [%follows ~]
    ?+    -.sign  (on-agent:def wire sign)
        %watch-ack
      ?~  p.sign
        ((slog '%urbytes: Subscribe succeeded!' ~) `this)
      ((slog '%urbytes: Subscribe failed!' ~) `this)
    ::
        %kick
      %-  (slog '%urbytes: Got kick, resubscribing...' ~)
      :_  this
      :~  [%pass /follows %agent [src.bowl %urbytes] %watch /updates]
      ==
    ::
        %fact
      ?+    p.cage.sign  (on-agent:def wire sign)
          %urbytes-update
        ~&  !<(update q.cage.sign)
        `this
      ==
    ==
  ==
::
++  on-arvo   on-arvo:def
++  on-fail   on-fail:def
--