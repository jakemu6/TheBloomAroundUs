void openTwitterStream() {

  ConfigurationBuilder cb = new ConfigurationBuilder();
  cb.setOAuthConsumerKey(consumerKey);
  cb.setOAuthConsumerSecret(consumerSecret);
  cb.setOAuthAccessToken(accessToken);
  cb.setOAuthAccessTokenSecret(accessSecret);

  TwitterStream twitterStream = new TwitterStreamFactory(cb.build()).getInstance();



  FilterQuery filtered = new FilterQuery();

  double[][] locations = {{151, -34}, {152, -33}}; 
  //double[][] locations = {{-74, 40}, {-73, 41}}; //those are the boundary from New York City


  filtered.locations(locations);

  twitterStream.addListener(listener);


  if (locations[0][0] == 0) {
  } else {
    twitterStream.filter(filtered);
  }

  println("connected");
}





StatusListener listener = new StatusListener() {

  public void onStatus(Status status) {
    if (status.isRetweet() == true || status.getText().length() < 3) {
    } else {
      String stat = status.getText();
      tweets.append(stat);

      //try {
      //  PostRequest post = new PostRequest("http://localhost:9000/?properties=%7B%22annotators%22:%22sentiment%22,%22outputFormat%22:%22json%22%7D");
      //  post.addHeader("content-type", "application/json");
      //  post.addData(stat);
      //  post.send();
      //  float sentimentValue = float(parseJSONObject(post.getContent()).getJSONArray("sentences").getJSONObject(0).getString("sentimentValue"));
      //  sentiments.append(sentimentValue);
      //} 
      //catch (Exception e) {
        float sentimentValue = random(0, 4);
        sentiments.append(sentimentValue);
      //}
      float followerRatio = float(status.getUser().getFollowersCount()) / float(status.getUser().getFriendsCount());
      ratio.append(followerRatio);
      float statusesCount = float(status.getUser().getStatusesCount());
      statuses.append(statusesCount);

      newTweet = true;
    }
  }

  //@Override
  public void onDeletionNotice(StatusDeletionNotice statusDeletionNotice) {
    System.out.println("Got a status deletion notice id:" + statusDeletionNotice.getStatusId());
  }

  //@Override
  public void onTrackLimitationNotice(int numberOfLimitedStatuses) {
    System.out.println("Got track limitation notice:" + numberOfLimitedStatuses);
  }

  //@Override
  public void onScrubGeo(long userId, long upToStatusId) {
    System.out.println("Got scrub_geo event userId:" + userId + " upToStatusId:" + upToStatusId);
  }

  //@Override
  public void onStallWarning(StallWarning warning) {
    System.out.println("Got stall warning:" + warning);
  }

  //@Override
  public void onException(Exception ex) {
    ex.printStackTrace();
  }
};
