% Main code for problem solving using object oriented approach.
% Results should be the same as the ones obtained through the imperative
% approach. Therefore all tests should pass. 
clc
clear all

%% Numerical values


%% Definition and solution of the problem

num_data = load('numerical_inputs_articulated_3D.mat');
% prob = ProblemDef(num_data);

% mainGeometry contains the main information of the problem.
% articulated3Gproblem is created to actually SOLVE the problem.
problemSolver = Articulated3Dproblem(num_data);
problemSolver.solver();
problemSolver.plotting();

%% Unit testing

testCheck = unitTesting(problemSolver);

testCheck.testKGmatrix();
testCheck.testForces();
testCheck.testDisplacements();





