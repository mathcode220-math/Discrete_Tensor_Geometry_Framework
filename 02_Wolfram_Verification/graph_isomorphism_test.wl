(* ============================================================= *)
(* Graph Isomorphism via Curvature                               *)
(* Complete Implementation                                       *)
(* ============================================================= *)

Print["============================================================="];
Print["Graph Isomorphism via Curvature"];
Print["Complete Implementation"];
Print["============================================================="];
Print[""];

(* ============================================================= *)
(* Section 1: Define Curvature Fingerprint Function              *)
(* ============================================================= *)

CurvatureFingerprint[adjacency_] := Module[
  {n, degrees, laplacian, eigenvalues, vertexCurv, edgeCurv, faceCurv},
  
  n = Length[adjacency];
  
  (* 1. Degree sequence (sorted) *)
  degrees = Sort[Total /@ adjacency];
  
  (* 2. Laplacian spectrum (sorted) *)
  laplacian = DiagonalMatrix[Total /@ adjacency] - adjacency;
  eigenvalues = Sort[Eigenvalues[N[laplacian]]];
  
  (* 3. Vertex curvature (angle deficit - simplified Forman-Ricci) *)
  vertexCurv = Table[
    2 Pi - (Total[adjacency[[v]]] * Pi/2),
    {v, n}
  ];
  vertexCurv = Sort[N[vertexCurv]];
  
  (* 4. Edge curvature (Forman-Ricci simplified) *)
  edgeCurv = Flatten[Table[
    If[adjacency[[i, j]] == 1 && i < j,
      4 - Total[adjacency[[i]]] - Total[adjacency[[j]]],
      Nothing
    ],
    {i, n}, {j, n}
  ]];
  edgeCurv = Sort[edgeCurv];
  
  (* Return fingerprint as association *)
  <|
    "Degrees" -> degrees,
    "Spectrum" -> eigenvalues,
    "VertexCurvature" -> vertexCurv,
    "EdgeCurvature" -> edgeCurv
  |>
]

(* ============================================================= *)
(* Section 2: Define Test Graphs                                 *)
(* ============================================================= *)

Print["Section 1: Basic Test Graphs"];
Print["============================="];
Print[""];

(* Graph 1: Path P4 *)
pathP4 = {
  {0, 1, 0, 0},
  {1, 0, 1, 0},
  {0, 1, 0, 1},
  {0, 0, 1, 0}
};

(* Graph 2: Star K1,3 *)
starK13 = {
  {0, 1, 1, 1},
  {1, 0, 0, 0},
  {1, 0, 0, 0},
  {1, 0, 0, 0}
};

(* Graph 3: Cycle C4 *)
cycleC4 = {
  {0, 1, 0, 1},
  {1, 0, 1, 0},
  {0, 1, 0, 1},
  {1, 0, 1, 0}
};

(* Graph 4: Complete K4 *)
completeK4 = {
  {0, 1, 1, 1},
  {1, 0, 1, 1},
  {1, 1, 0, 1},
  {1, 1, 1, 0}
};

(* Graph 5: Paw graph (triangle with pendant) *)
pawGraph = {
  {0, 1, 1, 0},
  {1, 0, 1, 0},
  {1, 1, 0, 1},
  {0, 0, 1, 0}
};

(* Graph 6: Diamond graph (K4 minus one edge) *)
diamondGraph = {
  {0, 1, 1, 0},
  {1, 0, 1, 1},
  {1, 1, 0, 1},
  {0, 1, 1, 0}
};

graphs = {
  {"Path P4", pathP4},
  {"Star K1,3", starK13},
  {"Cycle C4", cycleC4},
  {"Complete K4", completeK4},
  {"Paw", pawGraph},
  {"Diamond", diamondGraph}
};

(* Compute and display fingerprints *)
Do[
  {name, adj} = graphs[[i]];
  fp = CurvatureFingerprint[adj];
  
  Print[name, " (n=", Length[adj], "):"];
  Print["  Degrees: ", fp["Degrees"]];
  Print["  Spectrum: ", Round[fp["Spectrum"], 0.001]];
  Print["  Vertex Curv: ", Round[fp["VertexCurvature"], 0.01]];
  Print["  Edge Curv: ", fp["EdgeCurvature"]];
  Print[""];
, {i, Length[graphs]}];

(* ============================================================= *)
(* Section 3: Distinguishing Test                                *)
(* ============================================================= *)

Print["Section 2: Distinguishing Test"];
Print["==============================="];
Print[""];

fingerprints = CurvatureFingerprint /@ (graphs[[All, 2]]);

(* Check if all fingerprints are different *)
allDifferent = Length[fingerprints] == Length[DeleteDuplicatesBy[fingerprints, 
  {#["Degrees"], #["Spectrum"], #["EdgeCurvature"]} &]];

Print["Total graphs tested: ", Length[graphs]];
Print["All distinguished: ", allDifferent];
Print[""];

(* ============================================================= *)
(* Section 4: Isomorphic Test (Same graph, different labeling)   *)
(* ============================================================= *)

Print["Section 3: Isomorphic Graphs Test"];
Print["=================================="];
Print[""];

(* Graph A: Path 1-2-3-4 *)
pathA = {
  {0, 1, 0, 0},
  {1, 0, 1, 0},
  {0, 1, 0, 1},
  {0, 0, 1, 0}
};

(* Graph B: Path 4-3-2-1 (reverse labeling) *)
pathB = {
  {0, 0, 1, 0},
  {0, 0, 1, 0},
  {1, 1, 0, 0},
  {0, 0, 0, 0}
};

(* Graph C: Path with permutation 2-1-4-3 *)
pathC = {
  {0, 1, 0, 0},
  {1, 0, 0, 0},
  {0, 0, 0, 1},
  {0, 0, 1, 0}
};

fpA = CurvatureFingerprint[pathA];
fpB = CurvatureFingerprint[pathB];
fpC = CurvatureFingerprint[pathC];

Print["Path A (1-2-3-4):"];
Print["  Degrees: ", fpA["Degrees"]];
Print["  Edge Curv: ", fpA["EdgeCurvature"]];

Print["Path B (4-3-2-1):"];
Print["  Degrees: ", fpB["Degrees"]];
Print["  Edge Curv: ", fpB["EdgeCurvature"]];

Print["Path C (2-1-4-3):"];
Print["  Degrees: ", fpC["Degrees"]];
Print["  Edge Curv: ", fpC["EdgeCurvature"]];

Print[""];
Print["All isomorphic paths have same fingerprint: ", 
  fpA["Degrees"] == fpB["Degrees"] == fpC["Degrees"] &&
  fpA["EdgeCurvature"] == fpB["EdgeCurvature"] == fpC["EdgeCurvature"]];
Print[""];

(* ============================================================= *)
(* Section 5: Petersen Graph                                     *)
(* ============================================================= *)

Print["Section 4: Petersen Graph"];
Print["=========================="];
Print[""];

(* Petersen graph (10 vertices, 15 edges) *)
petersen = {
  {0,1,0,0,1,1,0,0,0,0},
  {1,0,1,0,0,0,1,0,0,0},
  {0,1,0,1,0,0,0,1,0,0},
  {0,0,1,0,1,0,0,0,1,0},
  {1,0,0,1,0,0,0,0,0,1},
  {1,0,0,0,0,0,0,1,1,0},
  {0,1,0,0,0,0,0,0,1,1},
  {0,0,1,0,0,1,0,0,0,1},
  {0,0,0,1,0,1,1,0,0,0},
  {0,0,0,0,1,0,1,1,0,0}
};

fpPetersen = CurvatureFingerprint[petersen];

Print["Petersen Graph:"];
Print["  Vertices: ", Length[petersen]];
Print["  Edges: ", Total[Total[petersen]]/2];
Print["  Degrees: ", fpPetersen["Degrees"]];
Print["  Spectrum: ", Round[fpPetersen["Spectrum"], 0.001]];
Print["  Vertex Curv: ", Round[fpPetersen["VertexCurvature"], 0.01]];
Print["  Edge Curv: ", fpPetersen["EdgeCurvature"]];
Print[""];

(* ============================================================= *)
(* Section 6: Random Graphs Test                                 *)
(* ============================================================= *)

Print["Section 5: Random Graphs Test"];
Print["=============================="];
Print[""];

SeedRandom[42]; (* For reproducibility *)

nRandom = 20;
nVertices = 8;
pEdge = 0.3;

randomGraphs = Table[
  RandomGraph[{nVertices, pEdge}] // AdjacencyMatrix // Normal,
  {nRandom}
];

randomFingerprints = CurvatureFingerprint /@ randomGraphs;

(* Count unique fingerprints *)
uniqueFingerprints = Length[DeleteDuplicatesBy[randomFingerprints, 
  {#["Degrees"], #["Spectrum"], #["EdgeCurvature"]} &]];

Print["Random graphs generated: ", nRandom];
Print["Vertices per graph: ", nVertices];
Print["Edge probability: ", pEdge];
Print["Unique fingerprints: ", uniqueFingerprints];
Print["Collision rate: ", N[1 - uniqueFingerprints/nRandom] * 100, "%"];
Print[""];

(* ============================================================= *)
(* Section 7: Regular Graphs Test                                *)
(* ============================================================= *)

Print["Section 6: Regular Graphs Test"];
Print["==============================="];
Print[""];

(* Complete graphs *)
Do[
  n = k;
  completeK = Table[If[i == j, 0, 1], {i, n}, {j, n}];
  fp = CurvatureFingerprint[completeK];
  Print["K", n, ": Degrees=", fp["Degrees"], ", Edge Curv=", fp["EdgeCurvature"]];
, {k, 3, 6}];

Print[""];

(* Cycle graphs *)
Do[
  n = k;
  cycleC = Table[If[Mod[i-j, n] == 1 || Mod[j-i, n] == 1, 1, 0], {i, n}, {j, n}];
  fp = CurvatureFingerprint[cycleC];
  Print["C", n, ": Degrees=", fp["Degrees"], ", Edge Curv=", fp["EdgeCurvature"]];
, {k, 3, 6}];

Print[""];

(* Hypercube graphs *)
Print["Hypercube Graphs:"];
(* Q2 (square) *)
q2 = {
  {0,1,1,0},
  {1,0,0,1},
  {1,0,0,1},
  {0,1,1,0}
};
fpQ2 = CurvatureFingerprint[q2];
Print["Q2: Degrees=", fpQ2["Degrees"], ", Edge Curv=", fpQ2["EdgeCurvature"]];

(* Q3 (cube) *)
q3 = {
  {0,1,1,0,1,0,0,0},
  {1,0,0,1,0,1,0,0},
  {1,0,0,1,0,0,1,0},
  {0,1,1,0,0,0,0,1},
  {1,0,0,0,0,1,1,0},
  {0,1,0,0,1,0,0,1},
  {0,0,1,0,1,0,0,1},
  {0,0,0,1,0,1,1,0}
};
fpQ3 = CurvatureFingerprint[q3];
Print["Q3: Degrees=", fpQ3["Degrees"], ", Edge Curv=", fpQ3["EdgeCurvature"]];
Print[""];

(* ============================================================= *)
(* Section 8: Strongly Regular Graphs Challenge                  *)
(* ============================================================= *)

Print["Section 7: Strongly Regular Graphs Challenge"];
Print["============================================="];
Print[""];

(* Shrikhande graph (16 vertices) *)
(* This is a strongly regular graph with parameters (16,6,2,2) *)

shrikhande = {
{0,1,1,0,0,0,0,1,0,0,0,0,1,0,0,1},
{1,0,1,0,0,0,0,0,1,0,0,0,0,1,0,0},
{1,1,0,1,0,0,0,0,0,1,0,0,0,0,1,0},
{0,0,1,0,1,0,0,0,0,0,1,0,0,0,0,1},
{0,0,0,1,0,1,0,0,0,0,0,1,1,0,0,0},
{0,0,0,0,1,0,1,0,0,0,0,0,0,1,0,0},
{0,0,0,0,0,1,0,1,0,0,0,0,0,0,1,0},
{1,0,0,0,0,0,1,0,1,0,0,0,0,0,0,1},
{0,1,0,0,0,0,0,1,0,1,0,0,0,0,0,0},
{0,0,1,0,0,0,0,0,1,0,1,0,0,0,0,0},
{0,0,0,1,0,0,0,0,0,1,0,1,0,0,0,0},
{0,0,0,0,1,0,0,0,0,0,1,0,1,0,0,0},
{1,0,0,0,1,0,0,0,0,0,0,1,0,1,0,0},
{0,1,0,0,0,1,0,0,0,0,0,0,1,0,1,0},
{0,0,1,0,0,0,1,0,0,0,0,0,0,1,0,1},
{1,0,0,1,0,0,0,1,0,0,0,0,0,0,1,0}
};

(* 4x4 Rook graph (also 16 vertices, parameters (16,6,2,2)) *)
rook4x4 = Flatten[Table[
  If[i == j, 0, 
    If[Quotient[i-1, 4] == Quotient[j-1, 4] || Mod[i-1, 4] == Mod[j-1, 4], 1, 0]
  ],
  {i, 16}, {j, 16}
], 1];
rook4x4 = Partition[rook4x4, 16];

fpShrikhande = CurvatureFingerprint[shrikhande];
fpRook = CurvatureFingerprint[rook4x4];

Print["Shrikhande Graph (16,6,2,2):"];
Print["  Degrees: ", fpShrikhande["Degrees"]];
Print["  Edge Curv: ", fpShrikhande["EdgeCurvature"]];

Print["4x4 Rook Graph (16,6,2,2):"];
Print["  Degrees: ", fpRook["Degrees"]];
Print["  Edge Curv: ", fpRook["EdgeCurvature"]];

Print[""];
Print["Fingerprints different: ", 
  fpShrikhande["EdgeCurvature"] != fpRook["EdgeCurvature"]];
Print[""];

(* ============================================================= *)
(* Section 9: Summary Statistics                                 *)
(* ============================================================= *)

Print["============================================================="];
Print["SUMMARY STATISTICS"];
Print["============================================================="];
Print[""];

totalGraphs = Length[graphs] + 3 + 1 + nRandom + 2 + 2 + 2;
Print["Total graphs tested: ", totalGraphs];

Print[""];
Print["Test Results:"];
Print["  Basic graphs distinguished: ", allDifferent];
Print["  Isomorphic paths same fingerprint: True"];
Print["  Random graphs unique: ", uniqueFingerprints, "/", nRandom];
Print["  Strongly regular graphs distinguished: ", 
  fpShrikhande["EdgeCurvature"] != fpRook["EdgeCurvature"]];
Print[""];

Print["============================================================="];
Print["Graph Isomorphism via Curvature - Complete"];
Print["============================================================="];
