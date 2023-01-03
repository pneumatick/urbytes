|%
+$  date  @da
+$  content  @t
+$  id  @uvH
+$  source  @p
+$  who  @p
+$  like  [=source =id]
+$  likes  (list like)
+$  share  [=source =id]
+$  shares  (list share)
+$  following  (set who)
+$  followers  (set who)
+$  bite  [=date =content likes=(set source) shares=(set source) comments=(map source id)]
+$  bites-map  (map id bite)
+$  bites-list  (list id)
+$  comment  [=source =id =bite]
+$  comments-map  (map id comment)
+$  comments-list  (list id)
+$  action
  $%  [%serve =content]
      [%del =id]
      ::[%like =source =id]
      [%like =source =id]
      [%receive-like =id]
      [%share =source =id]
      [%receive-share =id]
      [%comment =source =id =content]
      [%follow =who]
      [%unfollow =who]
  ==
+$  update
  $%  [%serve =content]
      [%del =id]
      [%like =source =id]
::      [%initial =tweets]  Unnecessary?
  ==
--