# Research Project: Graph Isomorphism via Curvature Invariants
## مشروع بحثي: تماثل المخططات باستخدام ثوابت الانحناء

**Level:** Accessible (Master's Thesis)  
**Time:** 6-12 months  
**Status:** Ready to Start

---

## Problem Statement

### The Question

**Can curvature invariants distinguish non-isomorphic graphs?**

Given two graphs G₁ and G₂:
- If they have the same curvature fingerprints → Are they isomorphic?
- If they are isomorphic → Do they have the same curvature fingerprints?

---

## Why This Problem?

### ✅ Advantages

| Factor | Status |
|--------|--------|
| **Background needed** | Basic graph theory + our framework |
| **Tools available** | Mathematica scripts ready |
| **Partial results valuable** | Yes - even negative results are interesting |
| **Publication potential** | Good - J. Graph Theory, Discrete Math |
| **Computational** | Yes - can test on large datasets |

---

## Research Plan

### Phase 1: Literature Review (Month 1-2)

#### Key Papers to Read

1. **Forman Curvature**
   - Forman, R. (2003). "Discrete differential geometry"
   - Already implemented in our framework

2. **Ollivier-Ricci Curvature**
   - Ollivier, Y. (2009). "Ricci curvature of Markov chains"
   - Different approach, compare with ours

3. **Graph Isomorphism**
   - Babai, L. (2016). "Graph Isomorphism in Quasipolynomial Time"
   - Current state of the art

4. **Spectral Graph Theory**
   - Chung, F. (1997). "Spectral Graph Theory"
   - Eigenvalues as invariants

---

### Phase 2: Define Curvature Fingerprint (Month 2-3)

#### Our Proposed Invariant

```
CurvatureFingerprint(G) = {
  DegreeSequence,
  LaplacianSpectrum,
  VertexCurvatures,
  EdgeCurvatures,
  FaceCurvatures,
  HolonomyGroup
}
```

#### Mathematica Implementation

```mathematica
CurvatureFingerprint[adjacency_] := Module[
  {n, degrees, laplacian, eigenvalues, 
   vertexCurv, edgeCurv, faceCurv, holonomy},
  
  n = Length[adjacency];
  
  (* 1. Degree sequence *)
  degrees = Sort[Total /@ adjacency];
  
  (* 2. Laplacian spectrum *)
  laplacian = DiagonalMatrix[Total /@ adjacency] - adjacency;
  eigenvalues = Sort[Eigenvalues[N[laplacian]]];
  
  (* 3. Vertex curvature (angle deficit) *)
  vertexCurv = Table[
    2 Pi - Sum[Pi/3, {Count[adjacency[[v]], 1]}], (* Simplified *)
    {v, n}
  ];
  vertexCurv = Sort[vertexCurv];
  
  (* 4. Edge curvature *)
  edgeCurv = Flatten[Table[
    If[adjacency[[i,j]] == 1 && i < j,
      4 - (Total[adjacency[[i]]] + Total[adjacency[[j]]]),
      Nothing
    ],
    {i, n}, {j, n}
  ]];
  edgeCurv = Sort[edgeCurv];
  
  (* Return fingerprint *)
  {degrees, eigenvalues, vertexCurv, edgeCurv}
]
```

---

### Phase 3: Test on Known Families (Month 3-5)

#### Test Case 1: Strongly Regular Graphs

**Question:** Can curvature distinguish strongly regular graphs with same parameters?

| Graph Pair | Parameters | Known to be non-isomorphic? |
|------------|------------|----------------------------|
| Shrikhande vs 4×4 Rook | (16,6,2,2) | Yes |
| Clebsch vs ? | (16,5,0,2) | Yes |

**Experiment:**
```mathematica
(* Shrikhande graph *)
shrikhande = (* adjacency matrix *);

(* 4x4 Rook graph *)
rook = (* adjacency matrix *);

fp1 = CurvatureFingerprint[shrikhande];
fp2 = CurvatureFingerprint[rook];

Print["Fingerprints equal: ", fp1 == fp2];
```

**Expected:** Different fingerprints (if our invariant is strong)

---

#### Test Case 2: Isospectral Graphs

**Question:** Can curvature distinguish isospectral graphs?

Known isospectral pairs exist - test if curvature distinguishes them.

---

#### Test Case 3: Random Graphs

**Experiment:**
```mathematica
(* Generate random graphs *)
n = 20; p = 0.3;
graphs = RandomGraph[{n, p}, 100];

(* Compute fingerprints *)
fingerprints = CurvatureFingerprint /@ (AdjacencyMatrix /@ graphs);

(* Check for collisions *)
collisions = Length[fingerprints] - Length[DeleteDuplicates[fingerprints]];

Print["Collisions: ", collisions];
```

**Expected:** Few or no collisions for random graphs

---

### Phase 4: Prove/Falsify Conjecture (Month 5-9)

#### Conjecture A (Optimistic)

**Statement:** Curvature fingerprint is a complete invariant.

**Approach:**
1. Try to prove: If FP(G₁) = FP(G₂) then G₁ ≅ G₂
2. Look for counterexamples
3. If counterexample found, strengthen invariant

---

#### Conjecture B (Realistic)

**Statement:** Curvature fingerprint distinguishes "most" non-isomorphic graphs.

**Measure:**
```
Distinguishing Power = (# distinguished pairs) / (# total pairs)
```

**Goal:** Show power ≥ 99% for graphs up to n=30

---

### Phase 5: Write and Publish (Month 9-12)

#### Paper Structure

1. **Introduction**
   - Graph isomorphism problem
   - Existing invariants

2. **Curvature Framework**
   - Our tensor geometry approach
   - Definition of fingerprint

3. **Experiments**
   - Strongly regular graphs
   - Isospectral graphs
   - Random graphs

4. **Results**
   - Distinguishing power
   - Comparison with other invariants

5. **Conclusion**
   - Conjectures
   - Future work

#### Target Venues

| Venue | Impact | Difficulty |
|-------|--------|------------|
| J. Graph Theory | ⭐⭐⭐ | Medium |
| Discrete Mathematics | ⭐⭐⭐ | Medium |
| Linear Algebra Appl. | ⭐⭐⭐ | Medium |
| Ars Combinatoria | ⭐⭐ | Easier |

---

## Getting Started TODAY

### Step 1: Run Existing Code

```bash
cd "C:\Users\ASUS\Desktop\نظرية"
wolfram -script open_problems_exploration.wl
```

Look at "Problem 4" section - this is your starting point!

---

### Step 2: Extend the Code

Add these test graphs:

```mathematica
(* Petersen graph *)
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

(* Complete graph K5 *)
k5 = Table[If[i==j, 0, 1], {i,5}, {j,5}];

(* Cycle C5 *)
c5 = Table[If[Mod[i-j,5]==1 || Mod[j-i,5]==1, 1, 0], {i,5}, {j,5}];

(* Compare fingerprints *)
fpPetersen = CurvatureFingerprint[petersen];
fpK5 = CurvatureFingerprint[k5];
fpC5 = CurvatureFingerprint[c5];

Print["All different: ", Length[DeleteDuplicates[{fpPetersen, fpK5, fpC5}]] == 3];
```

---

### Step 3: Find Test Graphs

Download graph datasets:

1. **House of Graphs**
   - URL: https://houseofgraphs.org
   - Contains interesting graphs for testing

2. **Nauty Package**
   - Generate all graphs up to n vertices
   - URL: http://users.cecs.anu.edu.au/~bdm/nauty/

---

## Milestones Checklist

### Month 1-2
- [ ] Read 5-10 key papers
- [ ] Understand existing invariants
- [ ] Set up Mathematica environment

### Month 2-3
- [ ] Implement curvature fingerprint
- [ ] Test on small graphs (n ≤ 10)
- [ ] Verify correctness

### Month 3-5
- [ ] Test on strongly regular graphs
- [ ] Test on isospectral graphs
- [ ] Test on random graphs (1000+ samples)

### Month 5-7
- [ ] Analyze results
- [ ] Find/verify counterexamples (if any)
- [ ] Strengthen invariant if needed

### Month 7-9
- [ ] Prove partial results
- [ ] Write paper draft
- [ ] Get advisor feedback

### Month 9-12
- [ ] Revise paper
- [ ] Submit to journal
- [ ] Prepare conference presentation

---

## Expected Outcomes

### Best Case
- ✅ Curvature fingerprint is complete invariant
- ✅ Proof for special graph classes
- ✅ Publication in top journal

### Likely Case
- ✅ High distinguishing power (≥99%)
- ✅ Counterexamples analyzed
- ✅ Publication in good journal

### Minimum Case
- ✅ Curvature invariant defined and tested
- ✅ Computational results documented
- ✅ Publication in combinatorics journal

---

## Resources Needed

### Software
- ✅ Mathematica (already have)
- ✅ Our framework scripts
- [ ] Nauty (for generating graphs)

### Hardware
- ✅ Standard computer
- [ ] HPC access (for large-scale testing, optional)

### Collaboration
- [ ] Graph theory expert (advisor)
- [ ] Computational resources

---

## Contact for Collaboration

This research direction is open for collaboration. The framework is ready - just need to run experiments and analyze results!

---

**Ready to start?** Run the exploration script and begin with Phase 1! 🚀

---

**Last Updated:** 2026-02-23  
**Difficulty:** ⭐⭐ (Accessible)  
**Time:** 6-12 months  
**Publication Potential:** ⭐⭐⭐
