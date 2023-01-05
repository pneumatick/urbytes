|%
+$  date  @da
+$  content  @t
+$  id  @uvH
+$  source  @p
+$  who  @p
+$  like  [=source =id]
+$  likes  (list like)
+$  likes-set  (set like)
+$  share  [=source =id]
+$  shares  (list share)
+$  share-set  (list share)
+$  following  (set who)
+$  followers  (set who)
+$  bite  [=date =content likes=(set source) shares=(set source) comments=(list [source id])]
+$  bites-map  (map id bite)
+$  bites-list  (list id)
+$  feed  (list [=source =id =bite])
+$  comment  [=source =id =bite]
+$  comments-map  (map id comment)
+$  comments-list  (list id)
+$  action
  $%  [%serve =content]
      [%del =id]
      [%like =source =id]
      [%receive-like =id]
      [%share =source =id]
      [%receive-share =id]
      [%comment =source =id =content]
      [%receive-comment bite-id=id comment-id=id]
      [%follow =who]
      [%unfollow =who]
  ==
+$  update
  $%  [%serve =content]
      [%del =id]
      [%like =source =id]
  ==
--