|%
+$  date  @da
+$  content  @t
+$  id  @uvH
+$  source  @p
+$  who  @p
+$  like  [=source =id]
+$  share  [=source =id]
+$  comment  [=source =id =bite]
+$  bite  [=date =content likes=(set source) shares=(set source) comments=(list [source id])]
+$  likes  (list like)
+$  likes-set  (set like)
+$  shares  (list share)
+$  shares-set  (set share)
+$  following  (set who)
+$  followers  (set who)
+$  bites-map  (map id bite)
+$  bites-list  (list id)
+$  feed  (list [source bite])
+$  feed-map  (map [source id] bite)
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
      [%del-comment comment-id=id]
      [%remove-comment bite-id=id comment-id=id]
      [%follow =who]
      [%unfollow =who]
  ==
+$  update
  $%  [%serve =id =bite]
      [%del =id]
      [%feed list=feed]
      [%bites list=(list bite)]
      [%likes list=likes]
      [%shares list=shares]
      [%following =following]
      [%followers =followers]
  ==
--