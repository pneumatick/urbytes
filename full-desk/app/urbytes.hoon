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
      =likes-set
      =shares
      =shares-set 
      =following
      =followers
      =feed
      =feed-map
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
      :: Serve a bite
      ?.  =(src.bowl our.bowl)  (on-poke:def mark vase)
      =/  id-hash  (sham [now.bowl our.bowl content.action])
      =/  bite  ^-  bite  
        :*  now.bowl
            content.action 
            `(set source)`~ 
            `(set source)`~ 
            `(list [source id])`~
        ==
      :_  %=  state
            bites-map   (~(put by bites-map) id-hash bite)
            bites-list  (weld ~[id-hash] bites-list)
          ==
      :~  :*  %give  %fact  ~[/updates]  %urbytes-update
              ::!>(`update`action)
              !>([%serve id-hash bite])
          ==
      ==
    ::
        %del
      :: Delete a bite
      ?.  =(src.bowl our.bowl)  (on-poke:def mark vase)
      :_  %=  state
            bites-map   (~(del by bites-map) id.action)
            bites-list  (skip `(list id)`bites-list |=(a=@uvH =(a id.action)))
          ==
      :~  :*  %give  %fact  ~[/updates]  %urbytes-update
              !>([%del id.action])
          ==
      ==
    ::
        %like
      :: Like a bite
      :: TODO: The poke is the same either way, needs cleaning!
      ?.  =(src.bowl our.bowl)  (on-poke:def mark vase)
      ?.  (~(has in likes-set) [source.action id.action])
        :_  %=  state
              likes  (weld ~[[source.action id.action]] likes)
              likes-set  (~(put in likes-set) [source.action id.action])
            ==
        :~  :*  %pass  /likes  %agent  [source.action %urbytes] 
                %poke  %urbytes-action  !>([%receive-like id.action])
            ==
        ==
      =/  index  (need (find ~[[source.action id.action]] likes))
      :_  %=  state
            likes  (oust [index 1] likes)
            likes-set  (~(del in likes-set) [source.action id.action])
          ==
      :~  :*  %pass  /likes  %agent  [source.action %urbytes] 
              %poke  %urbytes-action  !>([%receive-like id.action])
          ==
      ==
      ::
        %receive-like
      :: Receive a like
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
      [~ state(bites-map (~(put by bites-map) id.action new-bite))]
    ::
        %share
      :: Share a bite
      :: TODO: The poke is the same either way, needs cleaning!
      ?.  =(src.bowl our.bowl)  (on-poke:def mark vase)
      ?.  (~(has in shares-set) [source.action id.action])
        :_  %=  state
              shares  (weld ~[[source.action id.action]] shares)
              shares-set  (~(put in shares-set) [source.action id.action])
            ==
        :~  :*  %pass  /shares  %agent  [source.action %urbytes] 
                %poke  %urbytes-action  !>([%receive-share id.action])
            ==
        ==
      =/  index  (need (find ~[[source.action id.action]] shares))
      :_  %=  state
            shares  (oust [index 1] shares)
            shares-set  (~(del in shares-set) [source.action id.action])
          ==
      :~  :*  %pass  /shares  %agent  [source.action %urbytes] 
              %poke  %urbytes-action  !>([%receive-share id.action])
          ==
      ==
    ::
        %receive-share
      :: Receive a share
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
      [~ state(bites-map (~(put by bites-map) id.action new-bite))]
    ::
        %comment
      :: Make a comment on a bite
      ?.  =(src.bowl our.bowl)  (on-poke:def mark vase)
      =/  id-hash  (sham [now.bowl our.bowl source.action id.action content.action])
      =/  bite  ^-  bite  
        :*  now.bowl
            content.action 
            `(set source)`~ 
            `(set source)`~ 
            `(list [source id])`~
        ==
      =/  comment  [source.action id.action bite]
      :_  %=  state
            comments-map   (~(put by comments-map) id-hash comment)
            comments-list  (weld ~[id-hash] comments-list)
          ==
      :~  :*  %pass  /comments  %agent  [source.action %urbytes] 
              %poke  %urbytes-action  !>([%receive-comment id.action id-hash])
          ==
      ==
    ::
        %receive-comment
      :: Receive a comment on a bite
      =/  old-bite  (~(got by bites-map) bite-id.action)
      =/  new-comments  (weld ~[[src.bowl comment-id.action]] comments.old-bite)
      =/  new-bite  ^-  bite
          :*  date=date.old-bite
              content=content.old-bite
              likes=likes.old-bite
              shares=shares.old-bite
              comments=new-comments
          ==
      :_  state(bites-map (~(put by bites-map) bite-id.action new-bite))
      ~
    ::
        %del-comment
      :: Delete a comment that you made
      ?.  =(src.bowl our.bowl)  (on-poke:def mark vase)
      =/  comment  (~(got by comments-map) comment-id.action)
      =/  index  (need (find ~[comment-id.action] comments-list))
      :_  %=  state
            comments-map  (~(del by comments-map) comment-id.action)
            comments-list  (oust [index 1] comments-list)
          ==
      :~  :*  %pass  /comments  %agent  [source.comment %urbytes] 
              %poke  %urbytes-action  
              !>([%remove-comment id.comment comment-id.action])
          ==
      ==
    ::
        %remove-comment
      :: Remove a comment that a commenter deleted from your bite
      =/  old-bite  (~(got by bites-map) bite-id.action)
      =/  index  (need (find ~[[src.bowl comment-id.action]] comments.old-bite))
      =/  new-bite  ^-  bite  
          :*  date=date.old-bite
              content=content.old-bite
              likes=likes.old-bite
              shares=shares.old-bite
              comments=(oust [index 1] comments.old-bite)
          ==
      :-  ~
      state(bites-map (~(put by bites-map) bite-id.action new-bite))
    ::
        %follow
      ?.  =(src.bowl our.bowl)  (on-poke:def mark vase)
      :_  state(following (~(put in following) who.action))
      :~  [%pass /follows %agent [+.action %urbytes] %watch /updates]
      ==
    ::
        %unfollow
      ?.  =(src.bowl our.bowl)  (on-poke:def mark vase)
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
      [%ui ~]
    `this
  ==
::
++  on-leave
  |=  =path
  ^-  (quip card _this)
  ?+    path  (on-watch:def path)
      [%updates ~]
    ~&  'Got unsubscribe'  :: for debugging only; remove later
    [~ this(followers (~(del in followers) src.bowl))]
      [%ui ~]
    ~&  'Got UI unsubscribe'  :: for debugging
    `this
  ==
::
++  on-peek
  |=  =path
  ^-  (unit (unit cage))
  ?>  (team:title our.bowl src.bowl)
  =/  now=@  (unm:chrono:userlib now.bowl)
  ?+    path  (on-peek:def path)
      [%x %feed *]
    ?+    t.t.path  (on-peek:def path)
        [%between @ @ ~]
      =/  start=@  (rash i.t.t.t.path dem)
      =/  end=@  (rash i.t.t.t.t.path dem)
      :^  ~  ~  %urbytes-update
      !>  ^-  update
      [%feed (swag [start end] feed)]
    ==
    ::
      [%x %bites *]
    ?+    t.t.path  (on-peek:def path)
        [%between @ @ ~]
      =/  idtob  |=  =id  (~(got by bites-map) id)
      =/  start=@  (rash i.t.t.t.path dem)
      =/  end=@  (rash i.t.t.t.t.path dem)
      =/  ids  (swag [start end] bites-list)
      :^  ~  ~  %urbytes-update
      !>  ^-  update
      [%bites (turn ids idtob)]
    ==
    ::
      [%x %likes *]
    ?+    t.t.path  (on-peek:def path)
        [%between @ @ ~]
      :: TODO: add between
      :^  ~  ~  %urbytes-update
      !>  ^-  update
      [%likes likes]
    ==
    ::
      [%x %shares *]
    ?+    t.t.path  (on-peek:def path)
        [%between @ @ ~]
      :: TODO: add between
      :^  ~  ~  %urbytes-update
      !>  ^-  update
      [%shares shares]
    ==
      [%x %following *]
    ?+    t.t.path  (on-peek:def path)
        [%between @ @ ~]
      :: TODO: add between
      :^  ~  ~  %urbytes-update
      !>  ^-  update
      [%following following]
    ==
      [%x %followers *]
    ?+    t.t.path  (on-peek:def path)
        [%between @ @ ~]
      :: TODO: add between
      :^  ~  ~  %urbytes-update
      !>  ^-  update
      [%followers followers]
    ==
  ==
::
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
        =/  sign  !<(update q.cage.sign)
        ?+    -.sign  (on-agent:def)        :: might not want this default
            %serve
          :-  ~ 
          %=  this
                feed  (weld ~[[src.bowl bite.sign]] feed)
                feed-map  (~(put by feed-map) [src.bowl id.sign] bite.sign)
          ==
            %del
          =/  bite  (~(got by feed-map) [src.bowl id.sign])
          =/  index  (need (find ~[[src.bowl bite]] feed))
          :-  ~ 
          %=  this
                feed  (oust [index 1] feed)
                feed-map  (~(del by feed-map) [src.bowl id.sign])
          ==
        ==
      ==
    ==
  ==
::
++  on-arvo   on-arvo:def
++  on-fail   on-fail:def
--