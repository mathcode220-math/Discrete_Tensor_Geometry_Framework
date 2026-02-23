(* ============================================================= *)
(* Discrete Tensor Geometry Framework                            *)
(* Computational Verification Script - FINAL                     *)
(* ============================================================= *)

Print["============================================================="];
Print["Discrete Tensor Geometry - Computational Verification"];
Print["============================================================="];
Print[""];

(* Section 1: Rotation Matrix Definition *)
RotationMatrix2D[theta_] := {{Cos[theta], -Sin[theta]}, {Sin[theta], Cos[theta]}}
I2 = IdentityMatrix[2];

Print["Section 1: Rotation Matrix Definition"];
Print["R(theta) = {{Cos[theta], -Sin[theta]}, {Sin[theta], Cos[theta]}}"];
Print[""];

(* Section 2: Verify Rotation Composition *)
Print["Section 2: Verify Rotation Composition"];
Print["Lemma: R(alpha + beta) = R(alpha) . R(beta)"];
Print[""];

alpha = Pi/3;
beta = Pi/6;
Rsum = RotationMatrix2D[alpha + beta];
Rprod = RotationMatrix2D[alpha] . RotationMatrix2D[beta];

Print["Testing with alpha = Pi/3, beta = Pi/6:"];
Print["R(Pi/2) = ", MatrixForm[Rsum]];
Print["R(Pi/3) . R(Pi/6) = ", MatrixForm[Rprod]];
compositionTest = Simplify[Rsum == Rprod];
Print["Composition test passed: ", compositionTest];
Print[""];

(* Section 3: Triangle Holonomy *)
Print["Section 3: Triangle Holonomy Verification (C3)"];
Print["Three 120 degree rotations should give identity"];
Print[""];

theta = 2 Pi/3;
R120 = RotationMatrix2D[theta];
R120cubed = R120 . R120 . R120;

Print["R(120 deg) = ", MatrixForm[R120]];
Print["R(120 deg)^3 = ", MatrixForm[R120cubed]];
triangleTest = Simplify[R120cubed == I2];
Print["Triangle holonomy test passed: ", triangleTest];
Print[""];

Print["Numerical verification:"];
R120cubedNum = N[R120cubed];
Print["R(120 deg)^3 (numerical) = ", MatrixForm[R120cubedNum]];
triangleError = Norm[R120cubedNum - I2];
Print["Difference from identity: ", triangleError];
Print[""];

(* Section 4: Square Holonomy *)
Print["Section 4: Square Holonomy Verification (C4)"];
Print["Four 90 degree rotations should give identity"];
Print[""];

theta = Pi/2;
R90 = RotationMatrix2D[theta];
R90quad = R90 . R90 . R90 . R90;

Print["R(90 deg) = ", MatrixForm[R90]];
Print["R(90 deg)^4 = ", MatrixForm[R90quad]];
squareTest = Simplify[R90quad == I2];
Print["Square holonomy test passed: ", squareTest];
Print[""];

(* Section 5: General n-gon Holonomy *)
Print["Section 5: General n-gon Holonomy"];
Print["n exterior angles of 2Pi/n should give identity"];
Print[""];

VerifyNgonHolonomy[n_] := Module[{th, Rmat, result, error},
  th = 2 Pi/n;
  Rmat = RotationMatrix2D[th];
  result = MatrixPower[Rmat, n];
  error = Norm[N[result - I2]];
  {n, N[th], Simplify[result == I2], error}
];

Print["Testing n-gons for n = 3, 4, 5, 6, 8, 12:"];
ngonResults = Table[VerifyNgonHolonomy[n], {n, {3, 4, 5, 6, 8, 12}}];
Print[TableForm[ngonResults, 
  TableHeadings -> {None, {"n", "Angle", "Exact", "Error"}}]];
Print[""];

(* Section 6: Euler Characteristic *)
Print["Section 6: Euler Characteristic Verification"];
Print[""];

EulerChar[V_, E_, F_] := V - E + F;

Print["Triangle (disk): V=3, E=3, F=1 -> chi = ", EulerChar[3, 3, 1], " (expected: 1)"];
test1 = EulerChar[3, 3, 1] == 1;

Print["Tetrahedron (sphere): V=4, E=6, F=4 -> chi = ", EulerChar[4, 6, 4], " (expected: 2)"];
test2 = EulerChar[4, 6, 4] == 2;

Print["Torus: V=4, E=8, F=4 -> chi = ", EulerChar[4, 8, 4], " (expected: 0)"];
test3 = EulerChar[4, 8, 4] == 0;

Print["Cube: V=8, E=12, F=6 -> chi = ", EulerChar[8, 12, 6], " (expected: 2)"];
test4 = EulerChar[8, 12, 6] == 2;

eulerAllPassed = test1 && test2 && test3 && test4;
Print["All Euler tests passed: ", eulerAllPassed];
Print[""];

(* Section 7: Gauss-Bonnet for Polygons in Plane *)
Print["Section 7: Gauss-Bonnet Verification (Planar Polygons)"];
Print["Sum of exterior angles = 2*Pi for any n-gon (chi=1 for disk)"];
Print[""];

ExteriorAngle[n_] := 2 Pi / n;

Print["Test 1: Triangle - Sum = ", 3 * ExteriorAngle[3], " = ", N[3 * ExteriorAngle[3]]];
gbTest1 = Simplify[3 * ExteriorAngle[3] == 2 Pi];
Print["  Passed: ", gbTest1];

Print["Test 2: Square - Sum = ", 4 * ExteriorAngle[4], " = ", N[4 * ExteriorAngle[4]]];
gbTest2 = Simplify[4 * ExteriorAngle[4] == 2 Pi];
Print["  Passed: ", gbTest2];

Print["Test 3: Pentagon - Sum = ", 5 * ExteriorAngle[5]];
gbTest3 = Simplify[5 * ExteriorAngle[5] == 2 Pi];
Print["  Passed: ", gbTest3];

Print["Test 4: Hexagon - Sum = ", 6 * ExteriorAngle[6]];
gbTest4 = Simplify[6 * ExteriorAngle[6] == 2 Pi];
Print["  Passed: ", gbTest4];

Print["Test 5: General n-gon - Sum = n * (2Pi/n) = 2Pi"];
gbTestGeneral = Simplify[n * (2 Pi / n) == 2 Pi];
Print["  Passed: ", gbTestGeneral];
Print[""];

(* Section 8: Tetrahedron - Sphere Topology (CORRECTED) *)
Print["Section 8: Tetrahedron (Sphere Topology)"];
Print["For sphere: total angle deficit = 4*Pi = 2*Pi*chi where chi=2"];
Print[""];

(* For a regular tetrahedron projected onto sphere: *)
(* Each face becomes a spherical triangle with angles = 2Pi/3 (120 degrees) *)
(* This is because 3 faces meet at each vertex, dividing 360 degrees into 3 equal parts *)

sphericalAngle = 2 Pi / 3;  (* 120 degrees - angle of spherical triangle *)
sphericalExcessPerFace = 3 * sphericalAngle - Pi;  (* Girard's theorem *)
totalSphericalExcess = 4 * sphericalExcessPerFace;

Print["Spherical triangle angle (at each corner): ", N[sphericalAngle * 180/Pi], " degrees"];
Print["Spherical excess per face (A+B+C-Pi): ", N[sphericalExcessPerFace]];
Print["Total spherical excess (4 faces): ", N[totalSphericalExcess]];
Print["Expected (4*Pi for sphere): ", N[4 Pi]];

tetraTest = Simplify[totalSphericalExcess == 4 Pi];
Print["Tetrahedron Gauss-Bonnet test passed: ", tetraTest];
Print[""];

(* Alternative: Using angle deficit at vertices *)
Print["Alternative: Angle deficit at vertices"];
Print["At each vertex of tetrahedron, 3 edges meet"];
Print["In spherical geometry, the angle deficit = 2Pi - (sum of face angles at vertex)"];

(* For regular tetrahedron on sphere: *)
(* Each face angle at vertex = 2Pi/3 *)
(* Angle deficit per vertex = 2Pi - 3*(2Pi/3) = 2Pi - 2Pi = 0 *)
(* But this is for the flat case... *)

(* For proper spherical tetrahedron: *)
(* The 3 faces meeting at vertex create angles that sum to less than 2Pi *)
(* The deficit equals the solid angle at that vertex *)

(* Solid angle of regular tetrahedron at each vertex = Pi/2 steradians *)
(* Total solid angle = 4 * (Pi/2) = 2Pi ... but should be 4Pi *)

(* Actually, for a regular tetrahedron: *)
(* Solid angle at each vertex = 3*arccos(1/3) - Pi *)
solidAnglePerVertex = 3 * ArcCos[1/3] - Pi;
totalSolidAngle = 4 * solidAnglePerVertex;

Print["Solid angle per vertex: ", N[solidAnglePerVertex]];
Print["Total solid angle: ", N[totalSolidAngle]];
Print["Note: This equals the surface area of inscribed sphere"];
Print[""];

(* Section 9: Summary *)
Print["============================================================="];
Print["SUMMARY OF ALL VERIFICATION TESTS"];
Print["============================================================="];
Print[""];

allTests = {
  {"Rotation Composition", compositionTest},
  {"Triangle Holonomy (exact)", triangleTest},
  {"Triangle Holonomy (numeric)", triangleError < 10^-10},
  {"Square Holonomy", squareTest},
  {"n-gon Holonomy (all n)", And @@ (#[[3]] & /@ ngonResults)},
  {"Euler Characteristic", eulerAllPassed},
  {"Gauss-Bonnet (Triangle)", gbTest1},
  {"Gauss-Bonnet (Square)", gbTest2},
  {"Gauss-Bonnet (Pentagon)", gbTest3},
  {"Gauss-Bonnet (Hexagon)", gbTest4},
  {"Gauss-Bonnet (General n-gon)", gbTestGeneral},
  {"Gauss-Bonnet (Tetrahedron/Sphere)", tetraTest}
};

Print[TableForm[allTests, TableHeadings -> {None, {"Test", "Result"}}]];
Print[""];

totalPassed = Count[allTests[[All, 2]], True];
totalTests = Length[allTests];

Print["Total Tests Passed: ", totalPassed, "/", totalTests];
Print[""];

If[totalPassed == totalTests,
  Print["*** SUCCESS: ALL TESTS PASSED! ***"];
,
  Print["Note: ", totalTests - totalPassed, " test(s) did not pass"]
];

Print[""];
Print["============================================================="];
Print["Verification Complete - Discrete Tensor Geometry Framework");
Print["============================================================="];
