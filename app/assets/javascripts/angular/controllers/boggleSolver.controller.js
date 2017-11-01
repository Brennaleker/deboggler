angular.module("deboggler")
  .controller("boggleSolverCtrl", ["$scope", "$http", function($scope, $http) {

    $scope.solutions
  // TODO Add input validation for a..z && qu
  // TODO Add input to allow user to change the boardWidth
  // TODO Allow user to select another language
  // TODO change input validation based on alphabet
    $scope.boardWidth = 4

    $scope.boardInput = []

    $scope.generateBoard = function() {
      for(x = 0; x < $scope.boardWidth; x++) {
        var wordArray = [];
        for(y = 0; y < $scope.boardWidth; y++) {
          wordArray.push("");
        }
        $scope.boardInput.push(wordArray);
      }
    }

    $scope.solve = function() {
      $http.get('/api/solve.json', {params:{board_input: JSON.stringify($scope.boardInput)}})
        .then(function(response){
            $scope.solutions = response['data']['json'];
      }, function(error){
        console.log("We ran into an error: " + error);
      })
    }

    $scope.generateBoard();
  }]);
