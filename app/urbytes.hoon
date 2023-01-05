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
            `(list [source id])`~
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
      :: Remove the like from the relevent data structures when present,
      :: otherwise add a new like (achieves toggle effect).
      :: TODO: The poke is the same either way, needs cleaning!
      ?.  (~(has in likes-set) [source.action id.action])
        :_  %=  state
              likes  (weld ~[[source.action id.action]] likes)
              likes-set  (~(put in likes-set) [source.action id.action])
            ==
        :~  :*  %pass  /like  %agent  [source.action %urbytes] 
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
      :: TODO: The poke is the same either way, needs cleaning!
      ?.  (~(has in shares-set) [source.action id.action])
        :_  %=  state
              shares  (weld ~[[source.action id.action]] shares)
              shares-set  (~(put in shares-set) [source.action id.action])
            ==
        :~  :*  %pass  /share  %agent  [source.action %urbytes] 
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
      :: TODO: add the source to the bite's shares list (done?)
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
      :: TODO: add a way to delete comments from both this list and
      :: the one in the source bite
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
      ?:  =((~(get by comments-map) id.action) ~)
        !!
      =/  index  (need (find ~[id.action] comments-list))
      ::=/  source  -:(~(get by comments-map) id.action)
      :_  %=  state
            comments-map  (~(del by comments-map) id.action)
            comments-list  (oust [index 1] comments-list)
          ==
      :~  :*  %pass  /comments  %agent  [source.action %urbytes] 
              %poke  %urbytes-action  !>([%remove-comment id.action])
          ==
      ==
    ::
        %remove-comment
      :: Remove a comment that the commenter deleted from your bite
      `state
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