
// Use Parse.Cloud.define to define as many cloud functions as you want.

Parse.Cloud.afterSave("CandidateVotes", function(request) {
  query = new Parse.Query("CategoryCandidates");
  query.get(request.object.get("candidateID").id, {
    success: function(candidate) {
      candidate.increment("votes");
      candidate.save();
    },
    error: function(error) {
    }
  });
});

Parse.Cloud.define("userHasVoted", function(request, response) {
  var query = new Parse.Query("CandidateVotes");
  query.equalTo("userID", request.params.userID);
  query.find({
    success: function() {
      response.success("user has voted");
    },
    error: function() {
      response.error("user hasn't voted");
    }
  });
});