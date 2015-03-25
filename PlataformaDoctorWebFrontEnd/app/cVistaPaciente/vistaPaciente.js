'use strict';

angular.module('mVistaPaciente', ['ngRoute'])

.config(['$routeProvider', function($routeProvider) {
  $routeProvider.when('/vistaPaciente/:idPaciente/:idDoctor', {
    templateUrl: 'cVistaPaciente/vistaPaciente.html',
    controller: 'vistaPacienteCont'
  });
}])

.controller('vistaPacienteCont', ['$scope','$http','$routeParams',
        function($scope,$http,$routeParams) {
        $scope.idPaciente=$routeParams.idPaciente;
        $scope.idDoctor=$routeParams.idDoctor;
        $http.get('http://neuromed.herokuapp.com/api/doctor/'+$scope.idDoctor).then(function(resp) {
            console.log('Success', resp);
            $scope.medico=resp.data;
            // For JSON responses, resp.data contains the result
        });
        $scope.fecha='';
        $scope.comentario='';
        $http.get('http://neuromed.herokuapp.com/api/paciente/'+$scope.idPaciente).then(function(resp) {
            console.log('Success', resp);
            $scope.paciente=resp.data;
            $scope.info = {
                labels: [],
                nivelDolor:[]
            };

                var datos=$scope.paciente.episodios;
                for(var i in datos)
                {
                    $scope.info.labels.push(datos[i].fecha);
                }


                var datos1=$scope.paciente.episodios;
                for(var i in datos1)
                {
                    $scope.info.nivelDolor.push(datos[i].nivelDolor);
                }



            // For JSON responses, resp.data contains the result

            $(function () {
                $('#grafico').highcharts({
                    chart: {
                        type: 'line'
                    },
                    title: {
                        text: 'Episodios del paciente'
                    },
                    xAxis: {
                        categories: $scope.info.labels
                    },
                    yAxis: {
                        title: {
                            text: 'Nivel de dolor'
                        }
                    },
                    plotOptions: {
                        line: {
                            dataLabels: {
                                enabled: true
                            },
                            enableMouseTracking: false
                        }
                    },
                    series: [{
                        name: 'Nombre del paciente',
                        data: $scope.info.nivelDolor
                    }]
                });
            });
        });

            $scope.config = {
                title: 'Products',
                tooltips: true,
                labels: false,
                mouseover: function() {},
                mouseout: function() {},
                click: function() {},
                legend: {
                    display: true,
                    //could be 'left, right'
                    position: 'right'
                }
            };

            $http.get('http://neuromed.herokuapp.com/api/doctor').then(function(resp) {
                console.log('Success', resp);
                $scope.medicos=resp.data;
                // For JSON responses, resp.data contains the result
            });

            $scope.pedirSegundaOpinion=function(id,mId){
                console.log("Este es el id del episodio: "+id);
                console.log("Este es el id del medico: "+mId);
                var json=[
                    {
                        "idDoctor":mId
                    }
                ];
                var res =$http.put('http://neuromed.herokuapp.com/api/paciente/'+$scope.idPaciente+'/episodio/'+id+'/doctores',json);
                res.success(function(data, status, headers, config) {
                    $scope.message = data;
                    //console.log(data);
                });
                console.log($scope.message);

            };

            $scope.comentar = function(id,comentario){
                console.log("Este es el id: "+id);
                console.log("Este es el comentario: "+comentario);
                var json=[
                    {
                     "idEpisodio":id,
                    "contenido":comentario
                    }
                ];
                console.log(json);
                var res =$http.post('http://neuromed.herokuapp.com/api/doctor/1/comentario',json);
                res.success(function(data, status, headers, config) {
                    $scope.message = data;
                    //console.log(data);
                });
                console.log($scope.message);
                $scope.comentario='';
            }

            $scope.buscarRangoFecha=function(){
                window.alert("Funcion en desarrollo"+$scope.fechaI+" "+$scope.fechaF);
                $http.get('http://neuromed.herokuapp.com/api/paciente/'+$scope.idPaciente+'/episodio'+$scope.fechaI+'/'+$scope.fechaF).then(function(resp) {
                    console.log('SuccessFecha', resp);
                    $scope.episodiosF=resp.data;
                    // For JSON responses, resp.data contains the result
                });

            };


}]);

