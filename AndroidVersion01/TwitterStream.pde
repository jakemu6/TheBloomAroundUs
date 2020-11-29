void openTwitterStream() {

  ConfigurationBuilder cb = new ConfigurationBuilder();
  cb.setOAuthConsumerKey(consumerKey);
  cb.setOAuthConsumerSecret(consumerSecret);
  cb.setOAuthAccessToken(accessToken);
  cb.setOAuthAccessTokenSecret(accessSecret);

  TwitterStream twitterStream = new TwitterStreamFactory(cb.build()).getInstance();



  FilterQuery filtered = new FilterQuery();

  //String keywords[] = {
  //  "flower"
  //};

  double[][] locations = {{Math.floor(longitude), Math.floor(latitude)}, {Math.ceil(longitude), Math.ceil(latitude)}}; 
    //double[][] locations = {{-74, 40}, {-73, 41}}; //those are the boundary from New York City
    //double[][] locations = {{150, -34}, {151, -33}}; //Sydney Boundaries

  filtered.locations(locations);
  //filtered.track(keywords);

  twitterStream.addListener(listener);


  if (locations[0][0] == 0) {
  } else {
    twitterStream.filter(filtered);

    //uncomment to check location
    //println(Math.floor(longitude));
    //println(Math.ceil(longitude));
    //println(Math.floor(latitude));
    //println(Math.ceil(latitude));
  }

  println("connected");
}





StatusListener listener = new StatusListener() {

  public void onStatus(Status status) {
    if (status.isRetweet() == true || status.getText().length() < 3) {
    } else {
      String stat = status.getText();
      tweets.append(stat);
      
      //Sentiment analysis requires the coreNLP local server to be active on a machine on the same network. network ID to be changed.

      //try {
      //  PostRequest post = new PostRequest("http://192.168.20.5:9000/?properties=%7B%22annotators%22:%22sentiment%22,%22outputFormat%22:%22json%22%7D");
      //  post.addHeader("content-type", "application/json");
      //  post.addData(stat);
      //  post.send();
      //  float sentimentValue = float(parseJSONObject(post.getContent()).getJSONArray("sentences").getJSONObject(0).getString("sentimentValue"));
      //  sentiments.append(sentimentValue);
      //} 
      //catch (Exception e) {
        float sentimentValue = random(0,4);
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
