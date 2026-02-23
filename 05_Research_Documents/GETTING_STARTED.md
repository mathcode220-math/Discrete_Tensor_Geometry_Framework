# Getting Started: Graph Isomorphism via Curvature
## دليل البدء السريع: تماثل المخططات باستخدام الانحناء

**Project:** Research Project 1  
**Level:** Master's Thesis  
**Time:** 6-12 months

---

## 🚀 ابدأ من هنا - الخطوة بخطوة

---

## الأسبوع ١: الإعداد والتعرف

### اليوم ١: تشغيل الكود الأساسي

#### الخطوة ١: افتح Mathematica

```mathematica
(* انتقل لمجلد المشروع *)
SetDirectory["C:\\Users\\ASUS\\Desktop\\نظرية"]

(* شغل سكريبت الاستكشاف *)
<< "open_problems_exploration.wl"
```

#### الخطوة ٢: افهم المخرجات

ابحث عن قسم "Problem 4: Graph Isomorphism" وشاهد:
- كيف يتم حساب البصمة (fingerprint)
- كيف يتم التمييز بين المخططات

---

### اليوم ٢-٣: جرب أمثلة بسيطة

#### كود للبدء (انسخ والصق في Mathematica):

```mathematica
(* ============================================================= *)
(* Graph Isomorphism via Curvature - Starter Code              *)
(* ============================================================= *)

Print["============================================================="];
Print["Graph Isomorphism via Curvature - Getting Started"];
Print["============================================================="];
Print[""];

(* ------------------------------------------------------------- *)
(* Step 1: Define Curvature Fingerprint Function                *)
(* ------------------------------------------------------------- *)

CurvatureFingerprint[adjacency_] := Module[
  {n, degrees, laplacian, eigenvalues, vertexCurv, edgeCurv},
  
  n = Length[adjacency];
  
  (* 1. Degree sequence (sorted) *)
  degrees = Sort[Total /@ adjacency];
  
  (* 2. Laplacian spectrum (sorted) *)
  laplacian = DiagonalMatrix[Total /@ adjacency] - adjacency;
  eigenvalues = Sort[Eigenvalues[N[laplacian]]];
  
  (* 3. Vertex curvature (angle deficit - simplified) *)
  vertexCurv = Table[
    2 Pi - (2 Pi / Total[adjacency[[v]]]) * Total[adjacency[[v]]],
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

(* ------------------------------------------------------------- *)
(* Step 2: Define Test Graphs                                   *)
(* ------------------------------------------------------------- *)

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

(* ------------------------------------------------------------- *)
(* Step 3: Compute and Compare Fingerprints                     *)
(* ------------------------------------------------------------- *)

Print["Test Graphs:"];
Print["============"];
Print[""];

graphs = {
  {"Path P4", pathP4},
  {"Star K1,3", starK13},
  {"Cycle C4", cycleC4},
  {"Complete K4", completeK4}
};

Do[
  {name, adj} = graphs[[i]];
  fp = CurvatureFingerprint[adj];
  
  Print[name, ":"];
  Print["  Degrees: ", fp["Degrees"]];
  Print["  Spectrum: ", Round[fp["Spectrum"], 0.001]];
  Print["  Vertex Curvature: ", Round[fp["VertexCurvature"], 0.001]];
  Print["  Edge Curvature: ", fp["EdgeCurvature"]];
  Print[""];
, {i, Length[graphs]}];

(* ------------------------------------------------------------- *)
(* Step 4: Check if Fingerprints Distinguish Graphs             *)
(* ------------------------------------------------------------- *)

Print["Distinguishing Test:"];
Print["===================="];
Print[""];

fingerprints = CurvatureFingerprint /@ (graphs[[All, 2]]);

(* Check if all fingerprints are different *)
allDifferent = Length[fingerprints] == Length[DeleteDuplicatesBy[fingerprints, 
  {#["Degrees"], #["Spectrum"], #["EdgeCurvature"]} &]];

Print["All graphs distinguished: ", allDifferent];
Print[""];

(* ------------------------------------------------------------- *)
(* Step 5: Test Isomorphic Graphs                               *)
(* ------------------------------------------------------------- *)

Print["Isomorphic Test:"];
Print["================"];
Print[""];

(* Graph A: Path 1-2-3-4 *)
graphA = {
  {0, 1, 0, 0},
  {1, 0, 1, 0},
  {0, 1, 0, 1},
  {0, 0, 1, 0}
};

(* Graph B: Same path, different labeling: 3-1-4-2 *)
(* Permutation: 1→3, 2→1, 3→4, 4→2 *)
graphB = {
  {0, 0, 1, 0},
  {0, 0, 0, 1},
  {1, 0, 0, 0},
  {0, 1, 0, 0}
};

fpA = CurvatureFingerprint[graphA];
fpB = CurvatureFingerprint[graphB];

Print["Graph A (Path 1-2-3-4):"];
Print["  Degrees: ", fpA["Degrees"]];
Print["  Edge Curvature: ", fpA["EdgeCurvature"]];

Print["Graph B (Path 3-1-4-2):"];
Print["  Degrees: ", fpB["Degrees"]];
Print["  Edge Curvature: ", fpB["EdgeCurvature"]];

Print[""];
Print["Fingerprints match (as expected for isomorphic): ", 
  fpA["Degrees"] == fpB["Degrees"] && fpA["EdgeCurvature"] == fpB["EdgeCurvature"]];
Print[""];

(* ------------------------------------------------------------- *)
(* Step 6: Challenge - Petersen vs Strongly Regular             *)
(* ------------------------------------------------------------- *)

Print["Challenge: Petersen Graph"];
Print["=========================="];
Print[""];

(* Petersen graph (10 vertices) *)
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

(* 4x4 Rook graph (also 16 vertices, but we'll use a smaller test) *)

fpPetersen = CurvatureFingerprint[petersen];

Print["Petersen Graph:"];
Print["  Vertices: ", Length[petersen]];
Print["  Degrees: ", fpPetersen["Degrees"]];
Print["  Edge Curvature: ", fpPetersen["EdgeCurvature"]];
Print[""];

Print["============================================================="];
Print["Getting Started Complete!"];
Print["============================================================="];
```

---

## الأسبوع ٢: قراءة الخلفية النظرية

### أوراق必读 (Must Read):

#### ١. أساسيات (٢-٣ أيام)
```
1. "Discrete Differential Geometry" - Forman (2003)
   - من موقعنا: already in framework
   
2. "Spectral Graph Theory" - Chung (1997)
   - الفصل ١-٣ فقط
```

#### ٢. تماثل المخططات (٣-٤ أيام)
```
3. "Graph Isomorphism in Quasipolynomial Time" - Babai (2016)
   - المقدمة فقط (لفهم المشكلة)
   
4. "Weisfeiler-Lehman Method" - survey paper
   - ابحث عن: "WL test graph isomorphism survey"
```

#### ٣. الانحناء في المخططات (٣-٤ أيام)
```
5. "Ollivier-Ricci Curvature of Markov Chains" (2009)
   - الأقسام ١-٣
   
6. "Forman-Ricci Curvature for Networks" (2015)
   - كامل
```

---

## الأسبوع ٣-٤: تجارب أولية

### التجربة ١: أشجار صغيرة

```mathematica
(* Generate all trees up to n=7 vertices *)
(* Compare fingerprints *)
(* Check for collisions *)
```

### التجربة ٢: مخططات منتظمة

```mathematica
(* Test on:
   - Complete graphs Kn
   - Cycle graphs Cn
   - Hypercube graphs Qn
*)
```

### التجربة ٣: مخططات عشوائية

```mathematica
(* Generate 100 random graphs G(n,p) *)
(* Compute fingerprints *)
(* Count collisions *)
```

---

## الشهر ٢-٣: اختبار على حالات صعبة

### حالة ١: Strongly Regular Graphs

```mathematica
(* Shrikhande graph vs 4x4 Rook graph *)
(* Both have parameters (16,6,2,2) *)
(* Are they distinguished by curvature? *)
```

### حالة ٢: Isospectral Graphs

```mathematica
(* Graphs with same Laplacian spectrum *)
(* Does curvature distinguish them? *)
```

### حالة ٣: SRG Database

```mathematica
(* Download from House of Graphs *)
(* Test all pairs *)
(* Report distinguishing rate *)
```

---

## الشهر ٤-٦: تحليل وكتابة

### تحليل النتائج

```mathematica
(* Compute:
   - Distinguishing power = #distinguished / #total
   - Compare with other invariants
   - Find counterexamples (if any)
*)
```

### كتابة الورقة

```
Structure:
1. Introduction (٢ صفحات)
2. Background (٣ صفحات)
3. Curvature Fingerprint (٤ صفحات)
4. Experiments (٥ صفحات)
5. Results (٣ صفحات)
6. Conclusion (١ صفحة)

Total: ~١٨ صفحة
```

---

## 📊 الجدول الزمني

| الشهر | المهام | المخرجات |
|-------|--------|----------|
| ١ | إعداد + كود أساسي | كود يعمل |
| ٢ | قراءة + تجارب صغيرة | فهم المشكلة |
| ٣ | تجارب على حالات صعبة | نتائج أولية |
| ٤ | تحليل النتائج | جداول ورسوم |
| ٥ | كتابة الورقة | مسودة كاملة |
| ٦ | مراجعة + إرسال | ورقة مرسلة |

---

## 🎯 معايير النجاح

### بعد شهر ١:
- ✅ الكود الأساسي يعمل
- ✅ فهمت المشكلة بوضوح
- ✅ جرّبت ٥-١٠ أمثلة بسيطة

### بعد شهر ٣:
- ✅ جرّبت على ١٠٠+ مخطط
- ✅ وجدت نتائج أولية
- ✅ عرفت إذا البصمة تميز أم لا

### بعد شهر ٦:
- ✅ ورقة مكتوبة
- ✅ نتائج موثقة
- ✅ جاهز للإرسال

---

## 💡 نصائح مهمة

### ١. ابدأ بسيطاً
- لا تحاول حل المشكلة كاملة من البداية
- جرّب على أشجار، دورات، مخططات كاملة

### ٢. وثّق كل شيء
- احفظ كل تجربة في ملف
- اكتب ملاحظات يومية

### ٣. ابحث عن Counterexamples
- إذا وجدت مخططين غير متماثلين بنفس البصمة
- هذا نتيجة مهمة بحد ذاتها!

### ٤. قارن مع Invariants أخرى
- Degree sequence
- Spectrum
- WL test
- كم بصمتك أفضل منهم؟

---

## 📞 عندما تحتاج مساعدة

### أسئلة شائعة:

**س:** كيف أحسب الانحناء بدقة؟  
**ج:** استخدم الكود في الأعلى، أو راجع `verification.wl`

**س:** ماذا لو كانت البصمة لا تميز؟  
**ج:** هذه نتيجة مهمة! اكتب عنها ورقة

**س:** كيف أرسل الورقة؟  
**ج:** اختر مجلة من القائمة في `RESEARCH_PROJECT_1.md`

---

## 🚀 ابدأ الآن!

```mathematica
(* انسخ الكود في الأعلى *)
(* الصقه في Mathematica *)
(* اضغط Shift+Enter *)
(* شاهد النتائج! *)
```

---

**Good Luck! 🍀**

---

**Last Updated:** 2026-02-23  
**Project:** Graph Isomorphism via Curvature  
**Status:** Ready to Start
