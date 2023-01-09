/-  *urbytes
|%
+$  feed-entry  [=source =bite]
++  enjs-update
  =,  enjs:format
  |=  upd=update
  ^-  json
  |^
  ?-    -.upd
      %serve
    ~&  'Improper serve update json conversion'
    !!
      %del
    s+''
      %feed
    (frond 'entries' a+(turn list.upd entry))
      %bites
    (frond 'bites' a+(turn list.upd enbite))
      %likes  (frond 'likes' a+(turn list.upd enlors))
      %shares  (frond 'shares' a+(turn list.upd enlors))
      %following
    =/  conv  |=  p=@p  s+`@t`(scot %p p)
    =/  flist  ~(tap in following.upd)
    (frond 'following' a+(turn flist conv))
      %followers
    =/  conv  |=  p=@p  s+`@t`(scot %p p)
    =/  flist  ~(tap in followers.upd)
    (frond 'followers' a+(turn flist conv))
  ==
  ::
  :: Encode likes or shares
  ++  enlors
    |=  =like
    ^-  json
    a+`(list json)`(limo ~[s+`@t`(scot %p source.like) s+`@t`(scot %uv id.like)])
  ::
  :: Encode a feed entry
  ++  entry
    |=  ent=feed-entry
    ^-  json
    %-  pairs
    :~
      ['source' s+`@t`(scot %p source.ent)]
      ['bite' (enbite bite.ent)]
    ==
  ::
  :: Encode a bite
  ++  enbite
    |=  =bite
    ^-  json
    %-  pairs
    :~  ['date' s+`@t`(scot %da date.bite)]
        ['content' s+content.bite]
        ['likes' (numb ~(wyt in likes.bite))]
        ['shares' (numb ~(wyt in shares.bite))]
        ['comments' (numb (lent comments.bite))]
    ==

  ::++  encomment
  ::|=  comment=[source=@p id=@uvH]
  ::^-  json
  ::%-  pairs
  ::    ['source' s+`@t`(scot %p source.comment)]
  ::    ['id' s+`@t`(scot %uv id.comment)]
  ::==
  --
--